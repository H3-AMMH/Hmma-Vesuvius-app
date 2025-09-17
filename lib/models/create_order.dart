class CreateOrder {
  final int resId;
  final String status;

  CreateOrder({required this.resId, required this.status});

  factory CreateOrder.fromJson(Map<String, dynamic> json) {
    return CreateOrder(resId: json['reservation_id'], status: json['status']);
  }
}
