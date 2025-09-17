import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/waiter_view_model.dart';
import '../models/_reservation.dart';
import '../models/create_reservation.dart';
import '../widgets/build_reservations.dart';
import '../widgets/reservation_form.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _partySizeController = TextEditingController();
  bool _submitting = false;

  Future<void> _fetchReservations() async {
    setState(() => _loading = true);
    try {
      final reservations = await _viewModel.fetchReservations();
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
        //_timeController.clear();
        //_timeController.text = DateFormat('HH:mm').format(DateTime.now());
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

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //_timeController.text = DateFormat('HH:mm').format(DateTime.now());
    _partySizeController.text = "1";
    _fetchReservations();
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return buildReservations(
        loading: _loading,
        reservations: _reservations,
        onReorder: _onReorder,
      );
    } else if (_currentIndex == 1) {
      _timeController.text = DateFormat('HH:mm').format(DateTime.now());
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
    } else {
      return const Center(
        child: Text("Opret ordrer", style: TextStyle(color: Colors.white)),
      );
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
            icon: Icon(Icons.receipt_long),
            label: 'Opret ordrer',
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) _fetchReservations();
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
