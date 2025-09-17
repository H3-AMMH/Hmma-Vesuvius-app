import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String get _baseUrl => dotenv.env['API_BASE_URL'] ?? "";

  static IOClient _client() {
    final ioc = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    return IOClient(ioc);
  }

  // --- Reservations ---
  static Future<List<dynamic>> fetchReservations() async {
    final response = await _client().get(Uri.parse("$_baseUrl/reservations"));
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
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reservation),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }

  // --- Menu ---
  static Future<List<dynamic>> fetchMenu() async {
    final response = await _client().get(Uri.parse("$_baseUrl/menu"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch menu: ${response.statusCode}");
  }

  // --- Orders ---
  static Future<List<dynamic>> fetchOrders() async {
    final response = await _client().get(Uri.parse("$_baseUrl/orders"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch orders: ${response.statusCode}");
  }

  static Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> order,
  ) async {
    final response = await _client().post(
      Uri.parse("$_baseUrl/orders"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> updateOrder(
    int id,
    Map<String, dynamic> order,
  ) async {
    final response = await _client().patch(
      Uri.parse("$_baseUrl/orders/$id"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> deleteOrder(int id) async {
    final response = await _client().delete(Uri.parse("$_baseUrl/orders/$id"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }
}
