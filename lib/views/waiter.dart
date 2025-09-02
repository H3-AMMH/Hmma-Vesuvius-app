import 'package:flutter/material.dart';

void main() => runApp(const WaiterApp());

class WaiterApp extends StatelessWidget {
  const WaiterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Vesuvius - Tjener',
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const WaiterPage(),
    );
  }
}

class WaiterPage extends StatelessWidget {
  const WaiterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Vesuvius - Tjener'),
      ),
      body: Center(
        child: Text(
          'Velkommen til Tjener-siden',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
