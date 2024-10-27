import 'package:flutter/material.dart';
import 'package:hackathon_rower/screens/main/screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
      )),
    );
  }
}
