import 'package:flutter/material.dart';
import '../models/_reservation.dart';
import '../services/api_service.dart'; // where updateReservation lives

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final int index;
  final Widget? trailing;

  const ReservationCard({
    required this.reservation,
    required this.index,
    this.trailing,
    super.key,
  });

  Future<void> _closeReservation(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ApiService.updateReservation(reservation.id, "closed");
      messenger.showSnackBar(
        const SnackBar(content: Text("Reservation closed")),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: Container(
            height: 200,
            width: 75,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: const Icon(Icons.reorder, color: Colors.white70, size: 50),
          ),
        ),
        title: Text(
          reservation.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Telefon: ${reservation.tel}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Tid: ${reservation.time}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Antal personer: ${reservation.partySize}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Borde nødvendige: ${reservation.tablesNeeded}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Status: ${reservation.status}",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        trailing:
            trailing ??
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                _closeReservation(context);
              },
            ),
      ),
    );
  }
}
