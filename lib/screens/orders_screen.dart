import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../utils/navigation_helper.dart';
import '../utils/responsive_helper.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _orderService.getAllOrders(
        status: _selectedFilter != 'Tous' ? _selectedFilter : null,
      );
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'DELIVERED':
        return Colors.green;
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'CONFIRMED':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commandes'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedFilter = value);
              _loadOrders();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Tous', child: Text('Tous')),
              const PopupMenuItem(value: 'PENDING', child: Text('En attente')),
              const PopupMenuItem(value: 'CONFIRMED', child: Text('Confirmées')),
              const PopupMenuItem(value: 'IN_PROGRESS', child: Text('En cours')),
              const PopupMenuItem(value: 'DELIVERED', child: Text('Livrées')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list),
                  const SizedBox(width: 4),
                  Text(_selectedFilter),
                ],
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final userRole = Provider.of<AuthProvider>(context, listen: false)
                  .currentUser
                  ?.role;
              if (NavigationHelper.canCreateOrder(userRole)) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // TODO: Navigate to create order
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Création de commande - À implémenter'),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune commande trouvée',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadOrders,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final padding = ResponsiveHelper.getHorizontalPadding(context);
                      final maxWidth = ResponsiveHelper.getMaxContentWidth(context);
                      final isMobile = ResponsiveHelper.isMobile(context);
                      
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: ListView.builder(
                            padding: EdgeInsets.all(padding),
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              final order = _orders[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(isMobile ? 16 : 20),
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(order.status),
                            child: const Icon(Icons.shopping_cart, color: Colors.white),
                          ),
                          title: Text(
                            order.reference ?? 'Commande #${order.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (order.clientName != null)
                                Text('Client: ${order.clientName}'),
                              if (order.dateCommande != null)
                                Text(
                                  'Date: ${DateFormat('dd/MM/yyyy').format(order.dateCommande!)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              if (order.montantTotal != null)
                                Text(
                                  'Montant: ${NumberFormat('#,###').format(order.montantTotal)} FCFA',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              if (order.status != null)
                                Chip(
                                  label: Text(
                                    order.status!,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: _getStatusColor(order.status).withOpacity(0.2),
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              // TODO: Navigate to order details
                            },
                          ),
                        ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}


