import 'package:flutter/material.dart';

class RouteSheetsTab extends StatelessWidget {
  const RouteSheetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Feuilles de Route',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            'Fonctionnalité à implémenter',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité "Feuilles de Route" à venir')),
              );
            },
            icon: const Icon(Icons.description),
            label: const Text('Voir les feuilles de route'),
          ),
        ],
      ),
    );
  }
}

