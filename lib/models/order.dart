class Order {
  final int id;
  final int reservationId;
  final String status;
  final String createdAt;
  final String reservationName;
  final String? tableNumbers;

  Order({
    required this.id,
    required this.reservationId,
    required this.status,
    required this.createdAt,
    required this.reservationName,
    this.tableNumbers,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      reservationId: json['reservation_id'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      reservationName: json['reservation_name'] ?? '',
      tableNumbers: json['table_numbers'],
    );
  }
}
