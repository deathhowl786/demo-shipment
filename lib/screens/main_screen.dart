import '/screens/payment_gateway.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = false;
  final TextEditingController _pickup = TextEditingController();
  final TextEditingController _delivery = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  List<Map<String, dynamic>> shipmentDetails = [];
  int selectedRate = 0;

  @override
  void initState() {
    // TODO: implement initState
    fetchRates();
    super.initState();
  }

  fetchRates() async {
    setState(() => isLoading = true);

    final supabase = Supabase.instance.client;
    final response = await supabase.from('shipments').select('''
            id, name, rate 
        ''');

    setState(() {
      shipmentDetails =
          response.map<Map<String, dynamic>>((shipment) {
            return {
              'id': shipment['id'] ?? 0,
              'name': shipment['name'] ?? 'NIL',
              'rate': shipment['rate'] ?? 0,
            };
          }).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 350,
            child: TextFormField(
              maxLength: 200,
              maxLines: 5,
              controller: _pickup,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Pickup Address',
              ),
            ),
          ),

          SizedBox(
            width: 350,
            child: TextFormField(
              maxLength: 200,
              maxLines: 5,
              controller: _delivery,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Delivery Address',
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 300,
                height: 100,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Choose a Shipping Company',
                  ),
                  items:
                      shipmentDetails.map((shipment) {
                        return DropdownMenuItem(
                          value: shipment['rate'].toString(),
                          child: Text(shipment['name']),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => selectedRate = int.parse(value ?? '0'));
                  },
                ),
              ),
              SizedBox(
                width: 150,
                height: 100,
                child: TextFormField(
                  maxLength: 10,
                  controller: _weight,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Weigth in Kgs',
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // int w = int.parse(_weight.text);
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        (_weight.text.isNotEmpty && selectedRate != 0)
                            ? 'Price = Rs. ${int.parse(_weight.text) * selectedRate}'
                            : 'Invalid Details',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Calculate Price'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_pickup.text.isNotEmpty &&
                        _delivery.text.isNotEmpty &&
                        _weight.text.isNotEmpty &&
                        selectedRate != 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentGateway(),
                        ),
                      );
                    } else {
                      SnackBar snackBar = SnackBar(
                        content: const Text('Invalid Details'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Pay Amount'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
