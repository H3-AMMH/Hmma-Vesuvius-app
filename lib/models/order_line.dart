class OrderLine {
  final int menuItemId;
  final String name;
  final double price;
  int quantity;

  OrderLine({
    required this.menuItemId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}
