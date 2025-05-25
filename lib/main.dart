import 'package:duitku/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
    await Supabase.initialize(
    url: 'https://sbvrheibklrxsbgtuugk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNidnJoZWlia2xyeHNiZ3R1dWdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUyMzczMzYsImV4cCI6MjA2MDgxMzMzNn0.Nk6kigFdJEiEXrU13AXvaTdstdpUiHCv4jR7RwkzdjY',
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