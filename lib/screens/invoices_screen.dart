import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import '../models/income_model.dart';
import '../services/income_service.dart';
import '../utils/responsive_helper.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final IncomeService _incomeService = IncomeService();
  List<Income> _invoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    setState(() => _isLoading = true);
    try {
      final invoices = await _incomeService.getWeeklyInvoices();
      setState(() {
        _invoices = invoices;
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

  Future<void> _downloadInvoice(Income invoice) async {
    if (invoice.id == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Téléchargement en cours...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      final file = await _incomeService.downloadInvoicePdf(invoice.id!);
      
      if (file != null && mounted) {
        await OpenFile.open(file.path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facture téléchargée: ${file.path}'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du téléchargement'),
            backgroundColor: Colors.red,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures de la Semaine'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _invoices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune facture cette semaine',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadInvoices,
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
                            itemCount: _invoices.length,
                            itemBuilder: (context, index) {
                              final invoice = _invoices[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(isMobile ? 16 : 20),
                          leading: CircleAvatar(
                            backgroundColor: invoice.isPaid == true
                                ? Colors.green
                                : Colors.orange,
                            child: Icon(
                              invoice.isPaid == true
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            invoice.numeroFacture ?? 'Facture #${invoice.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (invoice.clientName != null)
                                Text('Client: ${invoice.clientName}'),
                              Text(
                                'Date: ${DateFormat('dd/MM/yyyy').format(invoice.date)}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                'Montant: ${NumberFormat('#,###').format(invoice.amount)} FCFA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      invoice.statusFacture ?? 'EN_ATTENTE',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    backgroundColor: invoice.isPaid == true
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                    padding: EdgeInsets.zero,
                                  ),
                                  if (invoice.typeFacture != null) ...[
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        invoice.typeFacture!,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: Colors.blue.withOpacity(0.2),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () => _downloadInvoice(invoice),
                            tooltip: 'Télécharger la facture',
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

