import 'package:duitku/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
    await Supabase.initialize(
    url: 'https://prsbsxqddrfdwyxntgfn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InByc2JzeHFkZHJmZHd5eG50Z2ZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwOTI4NzUsImV4cCI6MjA2MjY2ODg3NX0.FCdb0mN02TfNzD30bihChlnD9l_EVArGIuwAAX3FjAE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}