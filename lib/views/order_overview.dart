import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../viewmodels/order_view_model.dart';

class OrderOverviewTab extends StatelessWidget {
  final List<Order> orders;
  final bool loading;
  final VoidCallback onRefresh;

  const OrderOverviewTab({
    super.key,
    required this.orders,
    required this.loading,
    required this.onRefresh,
  });

  Future<void> _showOrderDetails(
    BuildContext context,
    Order order,
    VoidCallback onOrderClosed,
  ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return _OrderDetailsSheet(order: order, onOrderClosed: onOrderClosed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ingen ordrer fundet',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Opdater'),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, idx) {
          final order = orders[idx];
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              title: Text(
                'Ordre #${order.id} - ${order.reservationName}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Bord(e): ${order.tableNumbers ?? "-"}\nOprettet: ${order.createdAt}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(order.status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () => _showOrderDetails(context, order, onRefresh),
            ),
          );
        },
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'open':
      return Colors.green;
    case 'in progress':
      return Colors.orange;
    case 'closed':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

class _OrderDetailsSheet extends StatefulWidget {
  final Order order;
  final VoidCallback onOrderClosed;

  const _OrderDetailsSheet({required this.order, required this.onOrderClosed});

  @override
  State<_OrderDetailsSheet> createState() => _OrderDetailsSheetState();
}

class _OrderDetailsSheetState extends State<_OrderDetailsSheet> {
  bool _loading = true;
  bool _closing = false;
  bool _deleting = false;
  List<dynamic> _orderLines = [];
  String? _error;
  late final OrderViewModel _orderViewModel;

  @override
  void initState() {
    super.initState();
    _orderViewModel = OrderViewModel();
    _fetchOrderLines();
  }

  Future<void> _fetchOrderLines() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lines = await ApiService.fetchOrderLines(widget.order.id);
      setState(() {
        _orderLines = lines;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Kunne ikke hente ordrelinjer';
        _loading = false;
      });
    }
  }

  Future<void> _closeOrder() async {
    await _orderViewModel.closeOrder(
      orderId: widget.order.id,
      reservationId: widget.order.reservationId,
      onLoading: (loading) {
        if (mounted) setState(() => _closing = loading);
      },
    );
    widget.onOrderClosed();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ordre markeret som lukket')));
  }

  Future<void> _deleteOrder() async {
    await _orderViewModel.deleteOrderWithState(
      orderId: widget.order.id,
      onLoading: (loading) {
        if (mounted) setState(() => _deleting = loading);
      },
    );
    widget.onOrderClosed();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ordre slettet')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ordre #${widget.order.id}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Status: ${widget.order.status}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Reservation: ${widget.order.reservationName}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Bord(e): ${widget.order.tableNumbers ?? "-"}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Indhold:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  if (_orderLines.isEmpty && _error == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Ingen ordrelinjer',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  if (_orderLines.isNotEmpty)
                    ..._orderLines.map(
                      (line) => ListTile(
                        dense: true,
                        title: Text(
                          line['name'] ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '${line['quantity']} x ${line['unit_price']} kr.',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (widget.order.status != 'closed')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _closing ? null : _closeOrder,
                        icon: _closing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: const Text('Markér som lukket'),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                      ),
                      onPressed: _deleting ? null : _deleteOrder,
                      icon: _deleting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        'Slet ordre',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
