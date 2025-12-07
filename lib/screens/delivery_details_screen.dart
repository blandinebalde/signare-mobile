import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/delivery_model.dart';
import '../models/order_model.dart';
import '../services/delivery_service.dart';
import '../services/order_service.dart';
import '../utils/responsive_helper.dart';
import '../config/app_config.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final Delivery delivery;

  const DeliveryDetailsScreen({
    super.key,
    required this.delivery,
  });

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final DeliveryService _deliveryService = DeliveryService();
  final OrderService _orderService = OrderService();
  
  Order? _order;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    setState(() => _isLoading = true);
    
    // Si pas d'orderId, on peut quand même afficher les détails de livraison
    if (widget.delivery.orderId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Appel API pour récupérer les détails complets de la commande
      final order = await _orderService.getOrderById(widget.delivery.orderId!);
      
      if (mounted) {
        setState(() {
          _order = order;
          _isLoading = false;
        });
        
        // Log pour debug
        if (order != null) {
          debugPrint('✅ Commande chargée: ID=${order.id}, Items=${order.items?.length ?? 0}');
        } else {
          debugPrint('⚠️ Commande non trouvée pour orderId: ${widget.delivery.orderId}');
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur lors du chargement de la commande: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement de la commande: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'DELIVERED':
      case 'LIVREE':
        return Colors.green;
      case 'IN_TRANSIT':
      case 'EN_COURS':
        return Colors.blue;
      case 'PENDING':
      case 'EN_ATTENTE':
        return Colors.orange;
      case 'CANCELLED':
      case 'ANNULEE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String? status) {
    switch (status?.toUpperCase()) {
      case 'DELIVERED':
      case 'LIVREE':
        return 'Livrée';
      case 'IN_TRANSIT':
      case 'EN_COURS':
        return 'En cours';
      case 'PENDING':
      case 'EN_ATTENTE':
        return 'En attente';
      case 'CANCELLED':
      case 'ANNULEE':
        return 'Annulée';
      default:
        return status ?? 'Inconnu';
    }
  }

  Future<void> _showStartDeliveryConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer le début de la livraison'),
        content: Text(
          'Voulez-vous vraiment commencer la livraison ${widget.delivery.reference ?? '#${widget.delivery.id}'} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _startDelivery();
    }
  }

  Future<void> _startDelivery() async {
    setState(() => _isUpdating = true);
    try {
      // Utiliser l'endpoint start-delivery qui met à jour la livraison ET la commande en un seul appel
      final reference = widget.delivery.reference ?? widget.delivery.id.toString();
      await _deliveryService.startDelivery(reference);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Livraison démarrée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Retour avec succès
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
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = ResponsiveHelper.getHorizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Livraison ${widget.delivery.reference ?? '#${widget.delivery.id}'}',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Détails de la livraison
                      _buildSection(
                        title: 'Détails de la livraison',
                        icon: Icons.local_shipping,
                        child: _buildDeliveryDetails(isMobile),
                      ),
                      const SizedBox(height: 24),

                      // Détails de la commande
                      if (_order != null)
                        _buildSection(
                          title: 'Détails de la commande',
                          icon: Icons.shopping_cart,
                          child: _buildOrderDetails(_order!, isMobile),
                        ),
                      if (_order != null) const SizedBox(height: 24),

                      // Produits de la commande
                      if (_order != null && _order!.items != null && _order!.items!.isNotEmpty)
                        _buildSection(
                          title: 'Produits de la commande',
                          icon: Icons.inventory_2,
                          child: _buildProductsList(_order!.items!, isMobile),
                        ),
                      
                      // Message si la commande n'a pas pu être chargée
                      if (widget.delivery.orderId != null && _order == null && !_isLoading)
                        _buildSection(
                          title: 'Détails de la commande',
                          icon: Icons.shopping_cart,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(Icons.error_outline, color: Colors.orange, size: 48),
                                const SizedBox(height: 8),
                                Text(
                                  'Impossible de charger les détails de la commande',
                                  style: TextStyle(color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ID Commande: ${widget.delivery.orderId}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomActions(padding),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDetails(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          'Référence',
          widget.delivery.reference ?? '#${widget.delivery.id}',
          Icons.tag,
        ),
        _buildInfoRow(
          'Statut',
          _getStatusLabel(widget.delivery.status),
          Icons.info,
          valueColor: _getStatusColor(widget.delivery.status),
        ),
        if (widget.delivery.fullClientName.isNotEmpty)
          _buildInfoRow(
            'Client',
            widget.delivery.fullClientName,
            Icons.person,
          ),
        if (widget.delivery.address.isNotEmpty)
          _buildInfoRow(
            'Adresse',
            widget.delivery.address,
            Icons.location_on,
          ),
        if (widget.delivery.numeroTelephone != null || widget.delivery.clientPhone != null)
          _buildInfoRow(
            'Téléphone',
            widget.delivery.numeroTelephone ?? widget.delivery.clientPhone ?? '',
            Icons.phone,
          ),
        if (widget.delivery.dateLivraison != null)
          _buildInfoRow(
            'Date de livraison',
            DateFormat('dd/MM/yyyy HH:mm').format(widget.delivery.dateLivraison!),
            Icons.calendar_today,
          ),
        if (widget.delivery.montantTotal != null)
          _buildInfoRow(
            'Montant total',
            '${NumberFormat('#,###').format(widget.delivery.montantTotal)} FCFA',
            Icons.attach_money,
            valueColor: Colors.green,
          ),
        if (widget.delivery.livreurName != null)
          _buildInfoRow(
            'Livreur',
            widget.delivery.livreurName!,
            Icons.delivery_dining,
          ),
      ],
    );
  }

  Widget _buildOrderDetails(Order order, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          'Référence',
          order.reference ?? order.numeroCommande ?? '#${order.id}',
          Icons.tag,
        ),
        if (order.status != null)
          _buildInfoRow(
            'Statut',
            order.status!,
            Icons.info,
          ),
        if (order.dateCommande != null)
          _buildInfoRow(
            'Date de commande',
            DateFormat('dd/MM/yyyy HH:mm').format(order.dateCommande!),
            Icons.calendar_today,
          ),
        if (order.clientName != null || order.nomClient != null)
          _buildInfoRow(
            'Client',
            order.clientName ?? order.nomClient ?? 'Client inconnu',
            Icons.person,
          ),
        if (order.clientPhone != null)
          _buildInfoRow(
            'Téléphone',
            order.clientPhone!,
            Icons.phone,
          ),
        if (order.entrepotName != null)
          _buildInfoRow(
            'Entrepôt',
            order.entrepotName!,
            Icons.warehouse,
          ),
        if (order.montantTotal != null || order.totalAmount != null)
          _buildInfoRow(
            'Montant total',
            '${NumberFormat('#,###').format(order.montantTotal ?? order.totalAmount ?? 0)} FCFA',
            Icons.attach_money,
            valueColor: Colors.green,
          ),
      ],
    );
  }

  Widget _buildProductsList(List<OrderItem> items, bool isMobile) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final imageUrl = _getProductImageUrl(item.productImagePath);
        
        return Card(
          margin: EdgeInsets.only(bottom: index < items.length - 1 ? 8 : 0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo du produit
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                              size: 32,
                            ),
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.inventory_2,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Informations du produit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom du produit
                      Text(
                        item.productName ?? 'Produit #${item.productId ?? 'N/A'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Quantité
                      Row(
                        children: [
                          Icon(Icons.shopping_cart, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Quantité: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Prix unitaire
                      if (item.prixUnitaire != null)
                        Row(
                          children: [
                            Icon(Icons.attach_money, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Prix unitaire: ${NumberFormat('#,###').format(item.prixUnitaire)} FCFA',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Montant total
                if (item.montantTotal != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${NumberFormat('#,###').format(item.montantTotal)} FCFA',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Construit l'URL complète de l'image du produit
  /// Basé sur la logique du composant Angular produit-list.component.ts
  /// Format: {apiUrl}/images/products/{cleanPath}
  String? _getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      debugPrint('No imagePath provided');
      return null;
    }

    // Nettoyer le chemin (enlever le slash initial s'il existe)
    final cleanPath = imagePath.startsWith('/') 
        ? imagePath.substring(1) 
        : imagePath;

    // Construire l'URL complète
    // AppConfig.imageBaseUrl = 'http://IP:8080/api/images'
    // Format final: http://IP:8080/api/images/products/{cleanPath}
    final fullUrl = '${AppConfig.imageBaseUrl}/products/$cleanPath';

    debugPrint('Image URL constructed: originalPath=$imagePath, cleanPath=$cleanPath, fullUrl=$fullUrl');
    
    return fullUrl;
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor ?? Colors.grey[800],
                    fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomActions(double padding) {
    final status = widget.delivery.status ?? widget.delivery.statutLivraison ?? '';
    final isPending = status == 'PENDING' || status == 'EN_ATTENTE';
    final isInProgress = status == 'IN_TRANSIT' || status == 'EN_COURS';
    final isDelivered = status == 'DELIVERED' || status == 'LIVREE';
    final isReturned = status == 'RETOURNE' || status == 'ANNULEE';

    // Si déjà livrée ou retournée, pas d'actions
    if (isDelivered || isReturned) {
      return null;
    }

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton principal selon le statut
            if (isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isUpdating ? null : _showStartDeliveryConfirmation,
                  icon: _isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(
                    _isUpdating ? 'Démarrage...' : 'Commencer la livraison',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            
            if (isInProgress) ...[
              // Bouton Terminer la livraison
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isUpdating ? null : _showFinishDeliveryDialog,
                  icon: _isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    _isUpdating ? 'Traitement...' : 'Terminer la livraison',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Bouton Retourner la commande
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isUpdating ? null : _showReturnDeliveryDialog,
                  icon: const Icon(Icons.keyboard_return),
                  label: const Text(
                    'Retourner la commande',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showFinishDeliveryDialog() async {
    // Demander si le client a payé
    final paymentChoice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminer la livraison'),
        content: const Text('Le client a-t-il payé ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('no'),
            child: const Text('Non (Paiement différé)'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('yes'),
            child: const Text('Oui'),
          ),
        ],
      ),
    );

    if (paymentChoice == null) return;

    if (paymentChoice == 'yes') {
      // Ouvrir le formulaire de paiement
      await _showPaymentForm();
    } else {
      // Terminer sans paiement
      await _finishDeliveryWithoutPayment();
    }
  }

  Future<void> _showPaymentForm() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentFormDialog(
        order: _order,
        delivery: widget.delivery,
        onPaymentSubmitted: (paymentData) async {
          Navigator.of(context).pop();
          await _finishDeliveryWithPayment(paymentData);
        },
      ),
    );
  }

  Future<void> _finishDeliveryWithPayment(Map<String, dynamic> paymentData) async {
    setState(() => _isUpdating = true);
    try {
      final reference = widget.delivery.reference ?? widget.delivery.id.toString();
      await _deliveryService.finishDeliveryWithPayment(reference, paymentData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Livraison terminée avec paiement enregistré'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
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
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _finishDeliveryWithoutPayment() async {
    setState(() => _isUpdating = true);
    try {
      final reference = widget.delivery.reference ?? widget.delivery.id.toString();
      await _deliveryService.finishDelivery(reference);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Livraison terminée (paiement différé)'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
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
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _showReturnDeliveryDialog() async {
    final reasonController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retourner la commande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Veuillez indiquer la raison du retour :'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Raison du retour',
                hintText: 'Ex: Client absent, Adresse incorrecte, etc.',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true && reasonController.text.trim().isNotEmpty) {
      await _returnDelivery(reasonController.text.trim());
    }
  }

  Future<void> _returnDelivery(String reason) async {
    setState(() => _isUpdating = true);
    try {
      final reference = widget.delivery.reference ?? widget.delivery.id.toString();
      await _deliveryService.returnDelivery(reference, reason);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commande retournée: $reason'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pop(true);
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
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}

/// Dialog pour le formulaire de paiement
class PaymentFormDialog extends StatefulWidget {
  final Order? order;
  final Delivery delivery;
  final Function(Map<String, dynamic>) onPaymentSubmitted;

  const PaymentFormDialog({
    super.key,
    required this.order,
    required this.delivery,
    required this.onPaymentSubmitted,
  });

  @override
  State<PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'ESPECES';
  final _montantController = TextEditingController();
  final _referenceController = TextEditingController();
  
  // Mobile Money
  final _mobilePhoneController = TextEditingController();
  String _selectedOperator = 'Orange Money';
  
  // Chèque
  final _chequeNumberController = TextEditingController();
  final _chequeBankController = TextEditingController();
  final _chequeTitulaireController = TextEditingController();
  final _chequeDateController = TextEditingController();
  
  // Virement
  final _virementRefController = TextEditingController();
  final _virementBankController = TextEditingController();
  final _virementAccountController = TextEditingController();
  final _virementTitulaireController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialiser le montant avec le montant total de la commande
    if (widget.order != null) {
      final total = widget.order!.montantTotal ?? widget.order!.totalAmount ?? 0.0;
      _montantController.text = total.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _montantController.dispose();
    _referenceController.dispose();
    _mobilePhoneController.dispose();
    _chequeNumberController.dispose();
    _chequeBankController.dispose();
    _chequeTitulaireController.dispose();
    _chequeDateController.dispose();
    _virementRefController.dispose();
    _virementBankController.dispose();
    _virementAccountController.dispose();
    _virementTitulaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.order?.montantTotal ?? widget.order?.totalAmount ?? 0.0;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payment, color: Colors.green),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Enregistrer le paiement',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Montant total
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Montant total:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${NumberFormat('#,###').format(totalAmount)} FCFA',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Type de paiement
                    const Text(
                      'Moyen de paiement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Moyen de paiement',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'ESPECES', child: Text('Espèces')),
                        DropdownMenuItem(value: 'MOBILE_MONEY', child: Text('Mobile Money')),
                        DropdownMenuItem(value: 'CHEQUE', child: Text('Chèque')),
                        DropdownMenuItem(value: 'VIREMENT', child: Text('Virement bancaire')),
                        DropdownMenuItem(value: 'CARTE_BANCAIRE', child: Text('Carte bancaire')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Montant payé
                    TextFormField(
                      controller: _montantController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Montant payé (FCFA)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le montant';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Montant invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Référence (optionnel)
                    TextFormField(
                      controller: _referenceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Référence (optionnel)',
                        prefixIcon: Icon(Icons.tag),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Champs spécifiques selon le type de paiement
                    if (_selectedPaymentMethod == 'MOBILE_MONEY') ...[
                      _buildMobileMoneyFields(),
                    ] else if (_selectedPaymentMethod == 'CHEQUE') ...[
                      _buildChequeFields(),
                    ] else if (_selectedPaymentMethod == 'VIREMENT') ...[
                      _buildVirementFields(),
                    ],
                  ],
                ),
              ),
            ),
            
            // Boutons d'action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Enregistrer le paiement'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMoneyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations Mobile Money',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _mobilePhoneController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Numéro de téléphone',
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer le numéro de téléphone';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedOperator,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Opérateur',
          ),
          items: const [
            DropdownMenuItem(value: 'Orange Money', child: Text('Orange Money')),
            DropdownMenuItem(value: 'MTN Mobile Money', child: Text('MTN Mobile Money')),
            DropdownMenuItem(value: 'Moov Money', child: Text('Moov Money')),
            DropdownMenuItem(value: 'Wave', child: Text('Wave')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedOperator = value!;
            });
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Titulaire',
            prefixIcon: Icon(Icons.person),
          ),
          initialValue: widget.delivery.fullClientName,
        ),
      ],
    );
  }

  Widget _buildChequeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations Chèque',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _chequeNumberController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Numéro de chèque',
            prefixIcon: Icon(Icons.confirmation_number),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer le numéro de chèque';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _chequeBankController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Banque',
            prefixIcon: Icon(Icons.account_balance),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer la banque';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _chequeTitulaireController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Titulaire',
            prefixIcon: Icon(Icons.person),
          ),
          initialValue: widget.delivery.fullClientName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer le titulaire';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _chequeDateController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Date du chèque (JJ/MM/AAAA)',
            prefixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              _chequeDateController.text = DateFormat('dd/MM/yyyy').format(date);
            }
          },
        ),
      ],
    );
  }

  Widget _buildVirementFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations Virement',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _virementRefController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Référence du virement',
            prefixIcon: Icon(Icons.tag),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer la référence';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _virementBankController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Banque',
            prefixIcon: Icon(Icons.account_balance),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer la banque';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _virementAccountController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Numéro de compte',
            prefixIcon: Icon(Icons.account_circle),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer le numéro de compte';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _virementTitulaireController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Titulaire',
            prefixIcon: Icon(Icons.person),
          ),
          initialValue: widget.delivery.fullClientName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer le titulaire';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _submitPayment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final montant = double.parse(_montantController.text);
    final paymentData = <String, dynamic>{
      'paiement': {
        'montant': montant,
        'datePaiement': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'moyenPaiement': _selectedPaymentMethod,
        'reference': _referenceController.text.isEmpty ? null : _referenceController.text,
        'status': 'VALIDE',
        'typePaiement': 'SUR_FACTURE',
      },
    };

    // Ajouter les informations spécifiques selon le type de paiement
    if (_selectedPaymentMethod == 'MOBILE_MONEY') {
      paymentData['mobileMoney'] = {
        'numeroTelephone': _mobilePhoneController.text,
        'operateur': _selectedOperator,
        'titulaire': widget.delivery.fullClientName,
        'montant': montant,
        'dateTransaction': DateTime.now().toIso8601String(),
      };
    } else if (_selectedPaymentMethod == 'CHEQUE') {
      paymentData['cheque'] = {
        'numeroCheque': _chequeNumberController.text,
        'banque': _chequeBankController.text,
        'titulaire': _chequeTitulaireController.text.isEmpty 
            ? widget.delivery.fullClientName 
            : _chequeTitulaireController.text,
        'montant': montant,
        'dateCheque': _chequeDateController.text.isNotEmpty
            ? _parseDate(_chequeDateController.text)
            : DateTime.now().toIso8601String(),
      };
    } else if (_selectedPaymentMethod == 'VIREMENT') {
      paymentData['virement'] = {
        'reference': _virementRefController.text,
        'montant': montant,
        'dateVirement': DateTime.now().toIso8601String(),
        'banque': _virementBankController.text,
        'numeroCompte': _virementAccountController.text,
        'titulaire': _virementTitulaireController.text.isEmpty
            ? widget.delivery.fullClientName
            : _virementTitulaireController.text,
      };
    }

    // Ajouter le client si disponible
    if (widget.order?.clientId != null) {
      paymentData['client'] = {
        'id': widget.order!.clientId,
      };
    }

    widget.onPaymentSubmitted(paymentData);
  }

  String _parseDate(String dateStr) {
    try {
      // Format: JJ/MM/AAAA
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final date = DateTime(year, month, day);
        return date.toIso8601String();
      }
    } catch (e) {
      debugPrint('Erreur parsing date: $e');
    }
    return DateTime.now().toIso8601String();
  }
}

