import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../models/delivery_model.dart';
import '../../services/delivery_service.dart';
import '../../utils/responsive_helper.dart';
import '../delivery_details_screen.dart';

class MyDeliveriesTab extends StatefulWidget {
  const MyDeliveriesTab({super.key});

  @override
  State<MyDeliveriesTab> createState() => _MyDeliveriesTabState();
}

class _MyDeliveriesTabState extends State<MyDeliveriesTab> {
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
      
      // Mapper le filtre sélectionné vers le format backend pour l'API
      String? backendStatus = _mapFilterToBackendStatus(_selectedFilter);
      
      // Charger les livraisons du livreur avec le filtre backend
      List<Delivery> allDeliveries = await _deliveryService.getAllDeliveries(
        status: backendStatus,
        livreurId: user?.id,
      );
      
      // Filtrer également côté client pour s'assurer de la correspondance exacte
      // (au cas où le backend renvoie des statuts dans un format différent)
      List<Delivery> filteredDeliveries;
      if (_selectedFilter == 'Tous') {
        filteredDeliveries = allDeliveries;
      } else {
        filteredDeliveries = allDeliveries.where((delivery) {
          return _matchesFilter(delivery, _selectedFilter);
        }).toList();
      }
      
      setState(() {
        _deliveries = filteredDeliveries;
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

  /// Mappe le filtre frontend vers le format backend pour l'API
  String? _mapFilterToBackendStatus(String filter) {
    switch (filter) {
      case 'PENDING':
        return 'EN_ATTENTE'; // Le backend utilise EN_ATTENTE
      case 'IN_TRANSIT':
        return 'EN_COURS'; // Le backend utilise EN_COURS
      case 'DELIVERED':
        return 'LIVREE'; // Le backend utilise LIVREE
      default:
        return null; // Tous
    }
  }

  /// Vérifie si une livraison correspond au filtre sélectionné
  /// Gère les deux formats possibles : anglais (PENDING, IN_TRANSIT, DELIVERED) 
  /// et français (EN_ATTENTE, EN_COURS, LIVREE)
  bool _matchesFilter(Delivery delivery, String filter) {
    // Récupérer le statut (peut être dans status ou statutLivraison)
    final status = (delivery.status?.toUpperCase() ?? 
                   delivery.statutLivraison?.toUpperCase() ?? '').trim();
    
    if (status.isEmpty) return false;
    
    switch (filter) {
      case 'PENDING':
        // En attente: PENDING ou EN_ATTENTE
        return status == 'PENDING' || status == 'EN_ATTENTE';
      case 'IN_TRANSIT':
        // En cours: IN_TRANSIT ou EN_COURS
        return status == 'IN_TRANSIT' || status == 'EN_COURS';
      case 'DELIVERED':
        // Livrées: DELIVERED ou LIVREE
        return status == 'DELIVERED' || status == 'LIVREE';
      case 'Tous':
        return true;
      default:
        return true;
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

  String _getStatusLabel(String? status) {
    switch (status?.toUpperCase()) {
      case 'DELIVERED':
        return 'Livrée';
      case 'IN_TRANSIT':
        return 'En transit';
      case 'PENDING':
        return 'En attente';
      case 'CANCELLED':
        return 'Annulée';
      default:
        return status ?? 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filtres
        LayoutBuilder(
          builder: (context, constraints) {
            final padding = ResponsiveHelper.getHorizontalPadding(context);
            final isMobile = ResponsiveHelper.isMobile(context);
            
            return Container(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
              child: isMobile
                  ? SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Tous', label: Text('Tous')),
                        ButtonSegment(value: 'PENDING', label: Text('Attente')),
                        ButtonSegment(value: 'IN_TRANSIT', label: Text('En cours')),
                        ButtonSegment(value: 'DELIVERED', label: Text('Livrées')),
                      ],
                      selected: {_selectedFilter},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedFilter = newSelection.first;
                        });
                        _loadDeliveries();
                      },
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'Tous', label: Text('Tous')),
                              ButtonSegment(value: 'PENDING', label: Text('En attente')),
                              ButtonSegment(value: 'IN_TRANSIT', label: Text('En cours')),
                              ButtonSegment(value: 'DELIVERED', label: Text('Livrées')),
                            ],
                            selected: {_selectedFilter},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _selectedFilter = newSelection.first;
                              });
                              _loadDeliveries();
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
        // Liste des livraisons
        Expanded(
          child: _isLoading
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
                                    elevation: 2,
                                    child: InkWell(
                                      onTap: () async {
                                        final result = await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => DeliveryDetailsScreen(
                                              delivery: delivery,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadDeliveries();
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(isMobile ? 16 : 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: _getStatusColor(delivery.status),
                                          child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                delivery.reference ?? 'Livraison #${delivery.id}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              if (delivery.orderReference != null)
                                                Text(
                                                  'Commande: ${delivery.orderReference}',
                                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            _getStatusLabel(delivery.status),
                                            style: const TextStyle(fontSize: 10, color: Colors.white),
                                          ),
                                          backgroundColor: _getStatusColor(delivery.status),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (delivery.clientName != null)
                                      _buildInfoRow(Icons.person, 'Client', delivery.clientName!),
                                    if (delivery.clientAddress != null)
                                      _buildInfoRow(Icons.location_on, 'Adresse', delivery.clientAddress!),
                                    if (delivery.clientPhone != null)
                                      _buildInfoRow(Icons.phone, 'Téléphone', delivery.clientPhone!),
                                    if (delivery.dateLivraison != null)
                                      _buildInfoRow(
                                        Icons.calendar_today,
                                        'Date',
                                        DateFormat('dd/MM/yyyy HH:mm').format(delivery.dateLivraison!),
                                      ),
                                    if (delivery.montantTotal != null)
                                      _buildInfoRow(
                                        Icons.attach_money,
                                        'Montant',
                                        '${NumberFormat('#,###').format(delivery.montantTotal)} FCFA',
                                      ),
                                    const SizedBox(height: 8),
                                    // Le bouton "Commencer la livraison" est maintenant dans l'écran de détails
                                  ],
                                ),
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
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}

