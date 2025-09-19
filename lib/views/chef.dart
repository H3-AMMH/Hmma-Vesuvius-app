import 'package:flutter/material.dart';
import '../viewmodels/chef_view_model.dart';
import '../viewmodels/order_view_model.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../widgets/order_list.dart';

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
  final _orderViewModel = OrderViewModel();
  List<MenuItem> _menuItems = [];
  List<Order> _orders = [];
  bool _loading = false;
  bool _loadingOrders = false;

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

  Future<void> _fetchOrders() async {
    setState(() => _loadingOrders = true);
    try {
      final orders = await _orderViewModel.fetchOrders();
      setState(() {
        _orders = orders;
        _loadingOrders = false;
      });
    } catch (e) {
      setState(() => _loadingOrders = false);
      debugPrint('Error fetching orders: $e');
    }
  }

  Future<void> _updateOrderStatus(Order order, String newStatus) async {
    try {
      await _orderViewModel.updateOrderStatus(order.id, newStatus);
      _fetchOrders(); // Refresh the orders list
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ordre status opdateret til ${Order(id: 0, reservationId: 0, status: newStatus).statusDisplay}')),
      );
    } catch (e) {
      debugPrint('Error updating order status: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fejl ved opdatering af ordre status')),
      );
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
        return const Center(child: Text("Ingen retter fundet"));
      }
      return ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return ListTile(
            title: Text(item.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              "${item.price} kr.",
              style: const TextStyle(color: Colors.white70),
            ),
          );
        },
      );
    } else if (_currentIndex == 2) {
      return Column(
        children: [
          Container(
            color: Colors.brown[800],
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Ordrer - Kok',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: OrderListWidget(
              orders: _orders,
              loading: _loadingOrders,
              onStatusUpdate: _updateOrderStatus,
              onRefresh: _fetchOrders,
            ),
          ),
        ],
      );
    } else {
      return const Center(child: Text("Ukendt fane"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Vesuvius - Chef'),
        actions: _currentIndex == 2
            ? [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchOrders,
                ),
              ]
            : null,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Hjem'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Ordrer'),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            _fetchMenu(); // fetch menu when user taps Menu
          } else if (index == 2) {
            _fetchOrders(); // fetch orders when user taps Orders
          }
        },
      ),
    );
  }
}
