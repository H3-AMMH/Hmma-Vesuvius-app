import 'package:flutter/material.dart';
import '../viewmodels/waiter_view_model.dart';
import '../models/_reservation.dart';

void main() => runApp(const WaiterApp());

class WaiterApp extends StatelessWidget {
  const WaiterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Vesuvius - Tjener',
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
        ),
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

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Vesuvius - Tjener'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchReservations,
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _reservations.isEmpty
              ? const Center(child: Text("Ingen reservationer i dag", style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final res = _reservations[index];
                    return ReservationCard(reservation: res);
                  },
                ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  const ReservationCard({required this.reservation, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(reservation.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Telefon: ${reservation.tel}", style: const TextStyle(color: Colors.white70)),
            Text("Tid: ${reservation.time}", style: const TextStyle(color: Colors.white70)),
            Text("Antal personer: ${reservation.partySize}", style: const TextStyle(color: Colors.white70)),
            Text("Borde nødvendige: ${reservation.tablesNeeded}", style: const TextStyle(color: Colors.white70)),
            Text("Status: ${reservation.status}", style: const TextStyle(color: Colors.white70)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
