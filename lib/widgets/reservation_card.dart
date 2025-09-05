import 'package:flutter/material.dart';
import '../models/_reservation.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final int index;

  const ReservationCard({
    required this.reservation,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle, color: Colors.white70),
        ),
        title: Text(
          reservation.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
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
        isThreeLine: true,
      ),
    );
  }
}
