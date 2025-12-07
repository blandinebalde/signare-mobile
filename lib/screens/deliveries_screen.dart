import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../models/delivery_model.dart';
import '../services/delivery_service.dart';
import '../utils/responsive_helper.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  final DeliveryService _deliveryService = DeliveryService();
  List<Delivery> _deliveries = [];
  bool _isLoading = true;
  String _selectedFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      final userRole = user?.role;
      
      // Si c'est un livreur, charger seulement ses livraisons
      final livreurId = userRole == 'LIVREUR' ? user?.id : null;
      
      final deliveries = await _deliveryService.getAllDeliveries(
        status: _selectedFilter != 'Tous' ? _selectedFilter : null,
        livreurId: livreurId,
      );
      setState(() {
        _deliveries = deliveries;
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
      case 'IN_TRANSIT':
        return Colors.blue;
      case 'PENDING':
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
        title: const Text('Livraisons'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedFilter = value);
              _loadDeliveries();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Tous', child: Text('Tous')),
              const PopupMenuItem(value: 'PENDING', child: Text('En attente')),
              const PopupMenuItem(value: 'IN_TRANSIT', child: Text('En transit')),
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
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _deliveries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune livraison trouvée',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDeliveries,
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
                            itemCount: _deliveries.length,
                            itemBuilder: (context, index) {
                              final delivery = _deliveries[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(isMobile ? 16 : 20),
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(delivery.status),
                            child: const Icon(Icons.local_shipping, color: Colors.white),
                          ),
                          title: Text(
                            delivery.reference ?? 'Livraison #${delivery.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (delivery.orderReference != null)
                                Text('Commande: ${delivery.orderReference}'),
                              if (delivery.clientName != null)
                                Text('Client: ${delivery.clientName}'),
                              if (delivery.clientAddress != null)
                                Text(
                                  'Adresse: ${delivery.clientAddress}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              if (delivery.dateLivraison != null)
                                Text(
                                  'Date: ${DateFormat('dd/MM/yyyy').format(delivery.dateLivraison!)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              if (delivery.montantTotal != null)
                                Text(
                                  'Montant: ${NumberFormat('#,###').format(delivery.montantTotal)} FCFA',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              if (delivery.status != null)
                                Chip(
                                  label: Text(
                                    delivery.status!,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: _getStatusColor(delivery.status).withOpacity(0.2),
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                          trailing: delivery.status != 'DELIVERED'
                              ? IconButton(
                                  icon: const Icon(Icons.check_circle_outline),
                                  onPressed: () async {
                                    try {
                                      await _deliveryService.updateDeliveryStatus(
                                        delivery.id!,
                                        'DELIVERED',
                                      );
                                      _loadDeliveries();
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Livraison marquée comme livrée'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Erreur: ${e.toString()}'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                )
                              : null,
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

