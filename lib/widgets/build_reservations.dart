import 'package:flutter/material.dart';
import '../models/_reservation.dart';
import 'reservation_card.dart';

Widget buildReservations({
  required bool loading,
  required List<Reservation> reservations,
}) {
  return loading
      ? const Center(child: CircularProgressIndicator())
      : reservations.isEmpty
          ? const Center(child: Text("Ingen reservationer i dag", style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final res = reservations[index];
                return ReservationCard(reservation: res);
              },
            );
}