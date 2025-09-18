import 'package:flutter/material.dart';
import '../models/_reservation.dart';
import '../models/menu_item.dart';
import '../models/order_line.dart';

class WaiterOrderTab extends StatelessWidget {
  final List<Reservation> reservations;
  final List<MenuItem> menuItems;
  final List<Map<String, dynamic>> categories;
  final List<OrderLine> orderLines;
  final String menuSearch;
  final int? selectedReservationId;
  final int? selectedCategoryId;
  final bool orderSubmitting;
  final ValueChanged<int?> onReservationChanged;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<String> onMenuSearchChanged;
  final ValueChanged<List<OrderLine>> onOrderLinesChanged;
  final VoidCallback onSubmitOrder;

  const WaiterOrderTab({
    super.key,
    required this.reservations,
    required this.menuItems,
    required this.categories,
    required this.orderLines,
    required this.menuSearch,
    required this.selectedReservationId,
    required this.selectedCategoryId,
    required this.orderSubmitting,
    required this.onReservationChanged,
    required this.onCategoryChanged,
    required this.onMenuSearchChanged,
    required this.onOrderLinesChanged,
    required this.onSubmitOrder,
  });

  @override
  Widget build(BuildContext context) {
    final availableReservations = reservations.where((r) => r.status == 'open').toList();
    final filteredMenu = menuItems.where((item) {
      final matchesCategory = selectedCategoryId == null || item.categoryId == selectedCategoryId;
      final matchesSearch = menuSearch.isEmpty ||
          item.name.toLowerCase().contains(menuSearch.toLowerCase()) ||
          item.descriptionDanish.toLowerCase().contains(menuSearch.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            value: selectedReservationId,
            decoration: const InputDecoration(
              labelText: 'Vælg reservation',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black54,
            ),
            dropdownColor: Colors.black87,
            items: availableReservations.map((r) {
              return DropdownMenuItem(
                value: r.id,
                child: Text('${r.name} (${r.date} ${r.time})', style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: onReservationChanged,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Alle', style: TextStyle(color: Colors.white)),
                  selected: selectedCategoryId == null,
                  onSelected: (_) => onCategoryChanged(null),
                  selectedColor: Colors.brown,
                  backgroundColor: Colors.grey[800],
                ),
                ...categories.map((cat) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat['name'], style: const TextStyle(color: Colors.white)),
                    selected: selectedCategoryId == cat['id'],
                    onSelected: (_) => onCategoryChanged(cat['id']),
                    selectedColor: Colors.brown,
                    backgroundColor: Colors.grey[800],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Søg efter ret...',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.black54,
              prefixIcon: Icon(Icons.search, color: Colors.white54),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: onMenuSearchChanged,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredMenu.isEmpty
                ? const Center(child: Text('Ingen retter fundet', style: TextStyle(color: Colors.white70)))
                : ListView.builder(
                    itemCount: filteredMenu.length,
                    itemBuilder: (context, idx) {
                      final item = filteredMenu[idx];
                      final existing = orderLines.firstWhere(
                        (ol) => ol.menuItemId == item.id,
                        orElse: () => OrderLine(menuItemId: item.id, name: item.name, price: item.price, quantity: 0),
                      );
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          title: Text(item.name, style: const TextStyle(color: Colors.white)),
                          subtitle: Text('${item.price.toStringAsFixed(2)} kr.', style: const TextStyle(color: Colors.white70)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white),
                                onPressed: existing.quantity > 0
                                    ? () {
                                        final newLines = List<OrderLine>.from(orderLines);
                                        final idx = newLines.indexWhere((ol) => ol.menuItemId == item.id);
                                        if (idx != -1) {
                                          newLines[idx].quantity--;
                                          if (newLines[idx].quantity == 0) {
                                            newLines.removeAt(idx);
                                          }
                                          onOrderLinesChanged(newLines);
                                        }
                                      }
                                    : null,
                              ),
                              Text('${existing.quantity}', style: const TextStyle(color: Colors.white)),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  final newLines = List<OrderLine>.from(orderLines);
                                  final idx = newLines.indexWhere((ol) => ol.menuItemId == item.id);
                                  if (idx == -1) {
                                    newLines.add(OrderLine(
                                      menuItemId: item.id,
                                      name: item.name,
                                      price: item.price,
                                      quantity: 1,
                                    ));
                                  } else {
                                    newLines[idx].quantity++;
                                  }
                                  onOrderLinesChanged(newLines);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (orderLines.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.brown[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total: ${orderLines.fold<double>(0, (sum, ol) => sum + ol.price * ol.quantity).toStringAsFixed(2)} kr.',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: orderSubmitting ? null : onSubmitOrder,
                    child: orderSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Bestil'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
