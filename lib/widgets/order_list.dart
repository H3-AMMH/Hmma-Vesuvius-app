import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderListWidget extends StatelessWidget {
  final List<Order> orders;
  final bool loading;
  final Function(Order, String) onStatusUpdate;
  final VoidCallback? onRefresh;

  const OrderListWidget({
    super.key,
    required this.orders,
    required this.loading,
    required this.onStatusUpdate,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Ingen ordrer fundet',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh != null ? () async => onRefresh!() : () async {},
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onStatusUpdate: (newStatus) => onStatusUpdate(order, newStatus),
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final Function(String) onStatusUpdate;

  const OrderCard({
    super.key,
    required this.order,
    required this.onStatusUpdate,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'being_prepared':
        return Colors.blue;
      case 'ready_for_pickup':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordre #${order.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order.statusDisplay,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (order.reservationName != null) ...[
              Text(
                'Reservation: ${order.reservationName}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 4),
            ],
            if (order.tableNumbers != null) ...[
              Text(
                'Borde: ${order.tableNumbers}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              'Reservation ID: ${order.reservationId}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            if (order.nextStatus != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(order.nextStatus!),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => onStatusUpdate(order.nextStatus!),
                    child: Text(order.nextStatusDisplay ?? 'Opdater'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}