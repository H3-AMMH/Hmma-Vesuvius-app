class MenuItem {
  final int id;
  final String name;
  final double price;
  final bool isAvalible;

  MenuItem({ 
    required this.id,
    required this.name,
    required this.price,
    required this.isAvalible,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      isAvalible: json['isAvalible'] == 1 || json['isAvalible'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'isAvalible': isAvalible};
  }
}
