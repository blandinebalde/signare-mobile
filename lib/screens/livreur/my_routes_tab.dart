import 'package:flutter/material.dart';

class MyRoutesTab extends StatelessWidget {
  const MyRoutesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Mes Routes',
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
                const SnackBar(content: Text('Fonctionnalité "Mes Routes" à venir')),
              );
            },
            icon: const Icon(Icons.map),
            label: const Text('Voir mes routes'),
          ),
        ],
      ),
    );
  }
}

