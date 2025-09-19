import 'package:flutter/material.dart';
import '../viewmodels/chef_view_model.dart';
import '../models/menu_item.dart';

class ChefApp extends StatelessWidget {
  const ChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Vesuvius - Chef',
      theme: Theme.of(
        context,
      ).copyWith(scaffoldBackgroundColor: const Color(0xFF000000)),
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
  final _viewModel = ChefViewModel();
  List<MenuItem> _menuItems = [];
  bool _loading = false;

  final Map<int, bool> _switchStates = {};

  Future<void> _fetchMenu() async {
    setState(() => _loading = true);
    try {
      final menu = await _viewModel.fetchMenu();
      setState(() {
        _menuItems = menu;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint(e.toString());
    }
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return const Center(child: Text("Velkommen til Kokke-siden"));
    } else if (_currentIndex == 1) {
      if (_loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_menuItems.isEmpty) {
        return const Center(child: Text("Ingen retter fundet"));
      }
      return ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];

          _switchStates.putIfAbsent(index, () => true);

          return ListTile(
            title: Text(item.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              "${item.price} kr.",
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Switch(
              value: _switchStates[index]!,
              activeColor: const Color(0xFFA67B5B),
              inactiveThumbColor: const Color(0xFF4B3621),
              onChanged: (bool value) {
                setState(() {
                  _switchStates[index] = value;
                  //item.isAvalible = value;
                });
              },
            ),
          );
        },
      );
    } else {
      return const Center(child: Text("Ordrer"));
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Indstillinger',
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            _fetchMenu(); // fetch menu when user taps Menu
          }
        },
      ),
    );
  }
}
