import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() => runApp(const ChefApp());

class ChefApp extends StatelessWidget {
  const ChefApp({super.key});

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

class ChefPage extends StatefulWidget {
  const ChefPage({super.key});

  @override
  State<ChefPage> createState() => _ChefPageState();
}

class _ChefPageState extends State<ChefPage> {
  int _currentIndex = 0;
  List<dynamic> _menuItems = [];
  bool _loading = false;

  Future<void> fetchMenu() async {
    setState(() => _loading = true);

    final ioc = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // ignore self-signed certs
    final client = IOClient(ioc);

    final response =
        await client.get(Uri.parse("https://10.130.54.40:3000/api/menu"));

    if (response.statusCode == 200) {
      setState(() {
        _menuItems = json.decode(response.body);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      throw Exception("Failed to load menu: ${response.statusCode}");
    }
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return const Center(child: Text("Velkommen til Kok-siden"));
    } else if (_currentIndex == 1) {
      if (_loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_menuItems.isEmpty) {
        return const Center(child: Text("No menu items found"));
      }
      return ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return ListTile(
            title: Text(item["name"], style: const TextStyle(color: Colors.white)),
            subtitle: Text("${item["price"]} kr.",
                style: const TextStyle(color: Colors.white70)),
          );
        },
      );
    } else {
      return const Center(child: Text("Innstillingssiden"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Café Vesuvius - Chef')),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Hjem'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Innstillinger'),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            fetchMenu(); // fetch menu when user taps Menu
          }
        },
      ),
    );
  }
}
