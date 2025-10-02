import 'package:flutter/material.dart';
import '../viewmodels/chef_view_model.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../viewmodels/order_view_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

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

  // Orders
  final _orderViewModel = OrderViewModel();
  List<Order> _orders = [];
  bool _ordersLoading = false;
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
    setState(() => _ordersLoading = true);
    try {
      final orders = await _orderViewModel.fetchOrders();
      setState(() {
        _orders = orders;
        _ordersLoading = false;
      });
    } catch (e) {
      setState(() => _ordersLoading = false);
      debugPrint('Order fetch error: $e');
    }
  }

  Future<void> _markOrderReady(Order order) async {
    try {
      await ApiService.updateOrderStatus(
        order.id,
        status: 'ready',
        reservationId: order.reservationId,
      );
      await NotificationService.showOrderReadyNotification(
        orderId: order.id,
        tableNumbers: order.tableNumbers,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ordre #${order.id} er klar!')));
      }
      _fetchOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fejl ved markering af ordre: $e')),
        );
      }
    }
  }

  Widget _buildOrdersTab() {
    if (_ordersLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ingen ordrer fundet',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _fetchOrders,
              icon: const Icon(Icons.refresh),
              label: const Text('Opdater'),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, idx) {
          final order = _orders[idx];
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              title: Text(
                'Ordre #${order.id} - ${order.reservationName}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Status: ${order.status} | Bord(e): ${order.tableNumbers ?? "-"}\nOprettet: ${order.createdAt}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: order.status == 'open'
                  ? ElevatedButton.icon(
                      onPressed: () => _markOrderReady(order),
                      icon: const Icon(Icons.check),
                      label: const Text('Markér som klar'),
                    )
                  : Text(
                      order.status == 'ready' ? 'Klar' : order.status,
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
              onTap: () => _showOrderDetails(context, order),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showOrderDetails(BuildContext context, Order order) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _ChefOrderDetailsSheet(order: order),
    );
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

          return ListTile(
            title: Text(item.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              "${item.price} kr.",
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Switch(
              value: item.isAvailable,
              activeThumbColor: const Color(0xFFA67B5B),
              inactiveThumbColor: const Color(0xFF4B3621),
              onChanged: (bool value) async {
                setState(() {
                  item.isAvailable = value;
                });

                try {
                  await ApiService.updateMenuAvailability(item.id, value);
                } catch (e) {
                  setState(() {
                    item.isAvailable = !value;
                  });
                  debugPrint("Failed to update availability: $e");
                }
              },
            ),
          );
        },
      );
    } else if (_currentIndex == 2) {
      return _buildOrdersTab();
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
            icon: Icon(Icons.receipt_long),
            label: 'Ordrer',
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            _fetchMenu();
          }
          if (index == 2) {
            _fetchOrders();
          }
        },
      ),
    );
  }
}

class _ChefOrderDetailsSheet extends StatefulWidget {
  final Order order;
  const _ChefOrderDetailsSheet({required this.order});

  @override
  State<_ChefOrderDetailsSheet> createState() => _ChefOrderDetailsSheetState();
}

class _ChefOrderDetailsSheetState extends State<_ChefOrderDetailsSheet> {
  bool _loading = true;
  List<dynamic> _orderLines = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOrderLines();
  }

  Future<void> _fetchOrderLines() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lines = await ApiService.fetchOrderLines(widget.order.id);
      setState(() {
        _orderLines = lines;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Kunne ikke hente ordrelinjer';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ordre #${widget.order.id}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Status: ${widget.order.status}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Reservation: ${widget.order.reservationName}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Bord(e): ${widget.order.tableNumbers ?? "-"}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Indhold:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  if (_orderLines.isEmpty && _error == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Ingen ordrelinjer',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  if (_orderLines.isNotEmpty)
                    ..._orderLines.map(
                      (line) => ListTile(
                        dense: true,
                        title: Text(
                          line['name'] ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '${line['quantity']} x ${line['unit_price']} kr.',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
