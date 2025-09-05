import 'package:flutter/material.dart';
import '../models/_reservation.dart';
import 'reservation_card.dart';

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
              key: Key('${res.id ?? index}'),
              child: ReservationCard(reservation: res, index: index),
            );
          },
          onReorder: onReorder,
        );
}
