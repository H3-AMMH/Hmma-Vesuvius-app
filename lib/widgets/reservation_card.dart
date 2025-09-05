import 'package:flutter/material.dart';
import '../models/_reservation.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({required this.reservation, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: const Icon(Icons.drag_handle, color: Colors.white70),
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

Widget buildReservations({
  required bool loading,
  required List<Reservation> reservations,
  required Function(int oldIndex, int newIndex) onReorder,
}) {
  return loading
      ? const Center(child: CircularProgressIndicator())
      : reservations.isEmpty
      ? const Center(
          child: Text(
            "Ingen reservationer i dag",
            style: TextStyle(color: Colors.white),
          ),
        )
      : ReorderableListView.builder(
          buildDefaultDragHandles: false,
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final res = reservations[index];
            return Dismissible(
              key: Key('${res.id}'),
              child: ReservationCard(reservation: res),
            );
          },
          onReorder: onReorder,
        );
}
