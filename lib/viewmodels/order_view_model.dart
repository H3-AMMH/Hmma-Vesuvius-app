import '../models/order.dart';
import '../services/api_service.dart';

class OrderViewModel {
  Future<List<Order>> fetchOrders() async {
    final data = await ApiService.fetchOrders();
    return data.map<Order>((json) => Order.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> deleteOrder(int orderId) async {
    return await ApiService.deleteOrder(orderId);
  }

  /// Handles closing an order and exposes loading state via callbacks.
  Future<void> closeOrder({
    required int orderId,
    required int reservationId,
    required void Function(bool) onLoading,
  }) async {
    onLoading(true);
    try {
      await ApiService.updateOrderStatus(orderId, status: 'closed', reservationId: reservationId);
    } finally {
      onLoading(false);
    }
  }

  /// Handles deleting an order and exposes loading state via callbacks.
  Future<void> deleteOrderWithState({
    required int orderId,
    required void Function(bool) onLoading,
  }) async {
    onLoading(true);
    try {
      await deleteOrder(orderId);
    } finally {
      onLoading(false);
    }
  }
}
