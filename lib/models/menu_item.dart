class MenuItem {
  final int id;
  final String name;
  final double price;
  bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    bool availability = false;

    if (json['isAvailable'] != null) {
      var val = json['isAvailable'];
      if (val is int) {
        availability = val == 1;
      } else if (val is bool) {
        availability = val;
      }
    }

    return MenuItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isAvailable: availability,
    );
  }
}
