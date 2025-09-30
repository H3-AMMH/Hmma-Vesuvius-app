import 'package:flutter/material.dart';
import '../models/_reservation.dart';
import '../widgets/build_reservations.dart';

class WaiterReservationsTab extends StatelessWidget {
  final bool loading;
  final List<Reservation> reservations;
  final int reservationTabIndex;
  final ValueChanged<int> onTabChanged;
  final Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onRefresh;

  const WaiterReservationsTab({
    super.key,
    required this.loading,
    required this.reservations,
    required this.reservationTabIndex,
    required this.onTabChanged,
    required this.onReorder,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.brown[800],
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: reservationTabIndex == 0
                        ? Colors.white
                        : Colors.white70,
                    backgroundColor: reservationTabIndex == 0
                        ? Colors.brown
                        : Colors.transparent,
                  ),
                  onPressed: () {
                    if (reservationTabIndex != 0) onTabChanged(0);
                  },
                  child: const Text("I dag"),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: reservationTabIndex == 1
                        ? Colors.white
                        : Colors.white70,
                    backgroundColor: reservationTabIndex == 1
                        ? Colors.brown
                        : Colors.transparent,
                  ),
                  onPressed: () {
                    if (reservationTabIndex != 1) onTabChanged(1);
                  },
                  child: const Text("Alle fremtidige"),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: buildReservations(
            loading: loading,
            reservations: reservations,
            onReorder: onReorder,
          ),
        ),
      ],
    );
  }
}
