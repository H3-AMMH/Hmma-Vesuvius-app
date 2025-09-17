import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/waiter_view_model.dart';
import '../models/_reservation.dart';
import '../models/create_reservation.dart';
import '../models/menu_item.dart';
import '../models/order_line.dart';
import '../widgets/reservation_form.dart';
import 'waiter_reservations_tab.dart';
import 'waiter_order_tab.dart';

class WaiterApp extends StatelessWidget {
  const WaiterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Vesuvius - Tjener',
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.brown),
      ),
      home: const WaiterPage(),
    );
  }
}

class WaiterPage extends StatefulWidget {
  const WaiterPage({super.key});

  @override
  State<WaiterPage> createState() => _WaiterPageState();
}

class _WaiterPageState extends State<WaiterPage> {
  final _viewModel = WaiterViewModel();
  List<Reservation> _reservations = [];
  bool _loading = false;
  int _currentIndex = 0;

  // Add: 0 = today, 1 = all upcoming
  int _reservationTabIndex = 0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _partySizeController = TextEditingController();
  bool _submitting = false;
  late String _defaultDate;
  late String _defaultTime;

  // For order tab
  List<MenuItem> _menuItems = [];
  List<Map<String, dynamic>> _categories = [];
  List<OrderLine> _orderLines = [];
  String _menuSearch = '';
  int? _selectedReservationId;
  int? _selectedCategoryId;
  bool _orderSubmitting = false;

  Future<void> _fetchReservations() async {
    setState(() => _loading = true);
    try {
      final reservations = await _viewModel.fetchReservations(
        future: _reservationTabIndex == 1,
      );
      setState(() {
        _reservations = reservations;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint(e.toString());
    }
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final reservation = CreateReservation(
        name: _nameController.text,
        tel: _telController.text,
        date: _dateController.text,
        time: _timeController.text,
        partySize: int.parse(_partySizeController.text),
      );
      final result = await _viewModel.createReservation(reservation);
      setState(() => _submitting = false);
      if (!mounted) return;
      if (result['success'] == true) {
        String smsMsg = '';
        if (result.containsKey('sms_error')) {
          smsMsg = '\n(SMS fejlede: ${result['sms_error']})';
        } else if (result.containsKey('sms_sid')) {
          smsMsg = '\n(SMS sendt)';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Reservation created!$smsMsg')));
        _nameController.clear();
        _telController.clear();
        //_dateController.clear();
        _timeController.clear();
        _timeController.text = DateFormat('HH:mm').format(DateTime.now());
        _partySizeController.text = "1";
        _fetchReservations();
        setState(() => _currentIndex = 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Unknown error')),
        );
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      debugPrint('Reservation error: $e');
    }
  }

  Future<void> _fetchMenuAndCategories() async {
    try {
      final menu = await _viewModel.fetchMenu();
      final categories = await _viewModel.fetchCategories();
      debugPrint('Menu items: $menu');
      debugPrint('Categories: $categories');
      setState(() {
        _menuItems = menu;
        _categories = categories;
      });
    } catch (e) {
      debugPrint('Menu/category fetch error: $e');
    }
  }

  void _resetOrderTab() {
    setState(() {
      _selectedReservationId = null;
      _selectedCategoryId = null;
      _menuSearch = '';
      _orderLines = [];
    });
    _fetchReservations();
    _fetchMenuAndCategories();
  }

  Future<void> _submitOrder() async {
    if (_selectedReservationId == null || _orderLines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vælg reservation og tilføj mindst én ret')),
      );
      return;
    }
    setState(() => _orderSubmitting = true);
    try {
      final orderResult = await _viewModel.createOrder(_selectedReservationId!);
      if (orderResult['id'] == null) throw Exception('Kunne ikke oprette bestilling');
      final orderId = orderResult['id'];
      for (final line in _orderLines) {
        await _viewModel.createOrderLine(
          orderId: orderId,
          menuItemId: line.menuItemId,
          quantity: line.quantity,
          unitPrice: line.price,
        );
      }
      setState(() => _orderSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bestilling oprettet!')),
      );
      _resetOrderTab();
    } catch (e) {
      setState(() => _orderSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fejl: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(now);
    _timeController.text = DateFormat('HH:mm').format(now);
    _partySizeController.text = "1";
    _fetchReservations();
    _fetchMenuAndCategories();
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return WaiterReservationsTab(
        loading: _loading,
        reservations: _reservations,
        reservationTabIndex: _reservationTabIndex,
        onTabChanged: (idx) {
          setState(() => _reservationTabIndex = idx);
          _fetchReservations();
        },
        onReorder: _onReorder,
        onRefresh: _fetchReservations,
      );
    } else if (_currentIndex == 1) {
      return ReservationForm(
        formKey: _formKey,
        nameController: _nameController,
        telController: _telController,
        dateController: _dateController,
        timeController: _timeController,
        partySizeController: _partySizeController,
        submitting: _submitting,
        onSubmit: _submitReservation,
      );
    } else if (_currentIndex == 2) {
      return WaiterOrderTab(
        reservations: _reservations,
        menuItems: _menuItems,
        categories: _categories,
        orderLines: _orderLines,
        menuSearch: _menuSearch,
        selectedReservationId: _selectedReservationId,
        selectedCategoryId: _selectedCategoryId,
        orderSubmitting: _orderSubmitting,
        onReservationChanged: (id) => setState(() => _selectedReservationId = id),
        onCategoryChanged: (id) => setState(() => _selectedCategoryId = id),
        onMenuSearchChanged: (val) => setState(() => _menuSearch = val),
        onOrderLinesChanged: (lines) => setState(() => _orderLines = lines),
        onSubmitOrder: _submitOrder,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Vesuvius - Tjener'),
        actions: _currentIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchReservations,
                ),
              ]
            : null,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Reservationer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Opret reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Bestil',
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) _fetchReservations();
          if (index == 2) _resetOrderTab();
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Reservation item = _reservations.removeAt(oldIndex);
      _reservations.insert(newIndex, item);
    });
  }
}
