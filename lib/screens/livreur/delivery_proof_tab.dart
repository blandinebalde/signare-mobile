import 'package:flutter/material.dart';

class DeliveryProofTab extends StatelessWidget {
  const DeliveryProofTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text('Signature client'),
            subtitle: const Text('Capturer la signature du client'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité "Signature client" à venir')),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.photo_camera, color: Colors.green),
            title: const Text('Photo livraison'),
            subtitle: const Text('Prendre une photo de la livraison'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité "Photo livraison" à venir')),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.keyboard_return, color: Colors.orange),
            title: const Text('Gestion retours'),
            subtitle: const Text('Gérer les retours de colis'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité "Gestion retours" à venir')),
              );
            },
          ),
        ),
      ],
    );
  }
}

