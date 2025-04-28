import 'package:flutter/material.dart';
import 'home_screen.dart';

const String baseUrl = "http://127.0.0.1:5000";  // ✅ Flask server running on localhost:5000

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(  // ✅ Kept dark theme as you had
        scaffoldBackgroundColor: Colors.black,  // ✅ Dark background
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),  // ✅ White text
        ),
      ),
      home: HomeScreen(),
    );
  }
}