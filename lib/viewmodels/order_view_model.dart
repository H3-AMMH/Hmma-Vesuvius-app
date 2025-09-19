import '../models/order.dart';
import '../services/api_service.dart';

class OrderViewModel {
  Future<List<Order>> fetchOrders() async {
    final data = await ApiService.fetchOrders();
    return data.map<Order>((json) => Order.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> updateOrderStatus(int orderId, String status) async {
    return await ApiService.updateOrderStatus(orderId, status);
  }

  Future<Map<String, dynamic>> createOrder(int reservationId) async {
    return await ApiService.createOrder(reservationId);
  }
}