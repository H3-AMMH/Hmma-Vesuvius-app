class MenuItem {
  final int id;
  final String name;
  final int categoryId;
  final String descriptionDanish;
  final String? descriptionEnglish;
  final double price;

  MenuItem({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.descriptionDanish,
    this.descriptionEnglish,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      descriptionDanish: json['description_danish'],
      descriptionEnglish: json['description_english'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num).toDouble(),
    );
  }
}
