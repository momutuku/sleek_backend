import 'package:flutter/material.dart';
import 'package:sleek/screens/login_screen.dart';
import 'package:sleek/screens/properties_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: PropertiesScreen(),
    );
  }
}
