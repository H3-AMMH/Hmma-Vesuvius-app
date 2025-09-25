import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiService {
  static String get _baseUrl => dotenv.env['API_BASE_URL'] ?? "";
  static String get _apiKey => dotenv.env['API_KEY'] ?? "";

  static IOClient _client() {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return IOClient(ioc);
  }

  static Map<String, String> _headers({Map<String, String>? extra}) {
    return {'x-api-key': _apiKey, if (extra != null) ...extra};
  }

  // --- Menu ---
  static Future<List<dynamic>> fetchMenu() async {
    final response = await _client().get(
      Uri.parse("$_baseUrl/menu"),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch menu: ${response.statusCode}");
  }

  static Future<List<dynamic>> fullUpdateMenu(int id) async {
    final response = await _client().put(
      Uri.parse("$_baseUrl/menu/$id"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update menu item");
    }
    return json.decode(response.body);
  }

  static Future<List<dynamic>> updateMenuAvailability(
    int id,
    bool isAvailable,
  ) async {
    final response = await _client().patch(
      Uri.parse("$_baseUrl/api/menu/$id"),
      headers: _headers(extra: {'Content-Type': 'application/json'}),
      body: json.encode({'isAvailable': isAvailable ? 1 : 0}),
    );
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
    return json.decode(response.body);
  }

  static Future<List<dynamic>> fetchReservations({
    String? date,
    bool future = false,
  }) async {
    String url = "$_baseUrl/reservations";
    if (future) {
      url += "?future=true";
    } else if (date != null) {
      url += "?date=$date";
    }
    final response = await _client().get(Uri.parse(url), headers: _headers());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch reservations: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> createReservation(
    Map<String, dynamic> reservation,
  ) async {
    final response = await _client().post(
      Uri.parse("$_baseUrl/reservations"),
      headers: _headers(extra: {'Content-Type': 'application/json'}),
      body: json.encode(reservation),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }

  static Future<List<dynamic>> fetchOrders() async {
    final response = await _client().get(
      Uri.parse("$_baseUrl/orders"),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Fejlede at hente orders: ${response.statusCode}");
  }

  static Future<List<dynamic>> fetchOrderLines(int orderId) async {
    final response = await _client().get(
      Uri.parse("$_baseUrl/order_lines/$orderId"),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch order lines: ${response.statusCode}");
  }

  static Future<List<dynamic>> fetchCategories() async {
    final response = await _client().get(
      Uri.parse("$_baseUrl/categories"),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch categories: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> createOrder(int reservationId) async {
    final response = await _client().post(
      Uri.parse("$_baseUrl/orders"),
      headers: _headers(extra: {'Content-Type': 'application/json'}),
      body: json.encode({'reservation_id': reservationId}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception(
      "Failed to create order: ${response.statusCode} - ${response.body}",
    );
  }

  static Future<Map<String, dynamic>> createOrderLine({
    required int orderId,
    required int menuItemId,
    required int quantity,
    required double unitPrice,
  }) async {
    final response = await _client().post(
      Uri.parse("$_baseUrl/order_lines"),
      headers: _headers(extra: {'Content-Type': 'application/json'}),
      body: json.encode({
        'order_id': orderId,
        'menu_item_id': menuItemId,
        'quantity': quantity,
        'unit_price': unitPrice,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to create order line: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> updateOrderLine({
    required int orderLineId,
    required int quantity,
  }) async {
    final response = await _client().patch(
      Uri.parse("$_baseUrl/order_lines/$orderLineId"),
      headers: _headers(extra: {'Content-Type': 'application/json'}),
      body: json.encode({'quantity': quantity}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to update order line: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> deleteOrderLine(int orderLineId) async {
    final response = await _client().delete(
      Uri.parse("$_baseUrl/order_lines/$orderLineId"),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to delete order line: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> updateOrderStatus(
    int orderId, {
    required String status,
    required int reservationId,
  }) async {
    final response = await _client().patch(
      Uri.parse("$_baseUrl/orders/$orderId"),
      headers: _headers(extra: {'Content-Type': 'application/json'}),
      body: json.encode({'status': status, 'reservation_id': reservationId}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to update order status: ${response.statusCode}");
  }
}
