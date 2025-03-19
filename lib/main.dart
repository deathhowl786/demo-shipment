import 'supabase/creds.dart';

import 'screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: creds['supabaseUrl'],
    anonKey: creds['supabaseAnonKey'],
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Book A Shipment'),
          backgroundColor: Colors.blueAccent,
        ),

        body: MainScreen(),
      ),
    ),
  );
}
