import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Vesuvius - Chef',
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const ChefPage(),
    );
  }
}

class ChefPage extends StatelessWidget {
  const ChefPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Vesuvius - Chef'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Chef Page',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}