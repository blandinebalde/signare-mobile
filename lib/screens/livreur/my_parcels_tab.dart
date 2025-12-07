import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/delivery_model.dart';
import '../../services/delivery_service.dart';
import '../../utils/responsive_helper.dart';

class MyParcelsTab extends StatefulWidget {
  const MyParcelsTab({super.key});

  @override
  State<MyParcelsTab> createState() => _MyParcelsTabState();
}

class _MyParcelsTabState extends State<MyParcelsTab> {
  final DeliveryService _deliveryService = DeliveryService();
  List<Delivery> _parcels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParcels();
  }

  Future<void> _loadParcels() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      // Charger les colis en attente et en transit pour le livreur
      final deliveries = await _deliveryService.getAllDeliveries(
        livreurId: user?.id,
      );
      
      // Filtrer pour ne garder que les colis à livrer (PENDING et IN_TRANSIT)
      setState(() {
        _parcels = deliveries.where((d) => 
          d.status == 'PENDING' || d.status == 'IN_TRANSIT'
        ).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _parcels.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun colis à livrer',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadParcels,
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
                            itemCount: _parcels.length,
                            itemBuilder: (context, index) {
                              final parcel = _parcels[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                        child: ListTile(
                          leading: const Icon(Icons.inventory, color: Colors.orange),
                          title: Text(
                            parcel.reference ?? 'Colis #${parcel.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (parcel.clientName != null)
                                Text('Client: ${parcel.clientName}'),
                              if (parcel.clientAddress != null)
                                Text('Adresse: ${parcel.clientAddress}'),
                            ],
                          ),
                          trailing: parcel.status == 'PENDING'
                              ? const Chip(
                                  label: Text('À livrer', style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.orange,
                                )
                              : const Chip(
                                  label: Text('En cours', style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.blue,
                                ),
                                onTap: () {
                                  // TODO: Navigate to parcel details
                                },
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

