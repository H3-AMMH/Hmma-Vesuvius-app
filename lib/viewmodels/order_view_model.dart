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
}
