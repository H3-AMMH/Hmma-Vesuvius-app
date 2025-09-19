class Order {
  final int id;
  final int reservationId;
  final String status;
  final String? reservationName;
  final String? tableNumbers;
  final DateTime? createdAt;

  Order({
    required this.id,
    required this.reservationId,
    required this.status,
    this.reservationName,
    this.tableNumbers,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      reservationId: json['reservation_id'],
      status: json['status'] ?? 'open',
      reservationName: json['reservation_name'],
      tableNumbers: json['table_numbers'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservation_id': reservationId,
      'status': status,
      'reservation_name': reservationName,
      'table_numbers': tableNumbers,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Order copyWith({
    int? id,
    int? reservationId,
    String? status,
    String? reservationName,
    String? tableNumbers,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      reservationId: reservationId ?? this.reservationId,
      status: status ?? this.status,
      reservationName: reservationName ?? this.reservationName,
      tableNumbers: tableNumbers ?? this.tableNumbers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper method to get display name for status
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Åben';
      case 'being_prepared':
        return 'Under forberedelse';
      case 'ready_for_pickup':
        return 'Klar til afhentning';
      default:
        return status;
    }
  }

  // Helper method to get next status
  String? get nextStatus {
    switch (status.toLowerCase()) {
      case 'open':
        return 'being_prepared';
      case 'being_prepared':
        return 'ready_for_pickup';
      case 'ready_for_pickup':
        return null; // No next status
      default:
        return null;
    }
  }

  // Helper method to get next status display
  String? get nextStatusDisplay {
    final next = nextStatus;
    if (next == null) return null;
    
    switch (next) {
      case 'being_prepared':
        return 'Start forberedelse';
      case 'ready_for_pickup':
        return 'Marker som klar';
      default:
        return next;
    }
  }
}