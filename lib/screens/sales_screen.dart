import 'package:flutter/material.dart';
import '../services/vente_service.dart';
import '../models/vente_model.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final VenteService _venteService = VenteService();
  List<Vente> _ventes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVentes();
  }

  Future<void> _loadVentes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final ventes = await _venteService.getVentes();
      setState(() {
        _ventes = ventes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVentes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Erreur: $_error',
                        style: TextStyle(color: Colors.red[300]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadVentes,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _ventes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune vente trouvée',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadVentes,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _ventes.length,
                        itemBuilder: (context, index) {
                          return _buildVenteCard(_ventes[index]);
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to new sale
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVenteCard(Vente vente) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(vente.status).withOpacity(0.2),
          child: Icon(
            Icons.receipt,
            color: _getStatusColor(vente.status),
          ),
        ),
        title: Text(
          'Vente #${vente.id ?? 'N/A'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vente.clientName != null) Text('Client: ${vente.clientName}'),
            if (vente.entrepotName != null) Text('Entrepôt: ${vente.entrepotName}'),
            Text(vente.formattedDate),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              vente.formattedAmount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(vente.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                vente.status ?? 'N/A',
                style: TextStyle(
                  color: _getStatusColor(vente.status),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigate to sale details
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'COMPLETED':
      case 'TERMINE':
        return Colors.green;
      case 'PENDING':
      case 'EN_ATTENTE':
        return Colors.orange;
      case 'CANCELLED':
      case 'ANNULE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

