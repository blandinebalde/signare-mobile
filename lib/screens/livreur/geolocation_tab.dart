import 'package:flutter/material.dart';

class GeolocationTab extends StatelessWidget {
  const GeolocationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gps_fixed, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Géolocalisation',
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
                const SnackBar(content: Text('Fonctionnalité "Géolocalisation" à venir')),
              );
            },
            icon: const Icon(Icons.gps_fixed),
            label: const Text('Activer la géolocalisation'),
          ),
        ],
      ),
    );
  }
}

