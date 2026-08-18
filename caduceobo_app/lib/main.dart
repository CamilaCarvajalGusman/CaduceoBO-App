import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaduceoBO',
      home: Scaffold(
        appBar: AppBar(title: const Text('CaduceoBO')),
        body: const Center(child: Text('Bienvenido a CaduceoBO!')),
      ),
    );
  }
}
