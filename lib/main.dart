import 'package:flutter/material.dart';
import 'package:notemaster/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteMaster',
      home: HomeScreen(),
    );
  }
}
