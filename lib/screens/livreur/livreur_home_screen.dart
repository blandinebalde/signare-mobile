import 'package:flutter/material.dart';
import 'my_deliveries_tab.dart';
import 'my_routes_tab.dart';
import 'my_parcels_tab.dart';
import 'route_sheets_tab.dart';
import 'geolocation_tab.dart';
import 'delivery_proof_tab.dart';

class LivreurHomeScreen extends StatefulWidget {
  const LivreurHomeScreen({super.key});

  @override
  State<LivreurHomeScreen> createState() => _LivreurHomeScreenState();
}

class _LivreurHomeScreenState extends State<LivreurHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Livreur'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.local_shipping), text: 'Mes Livraisons'),
            Tab(icon: Icon(Icons.map), text: 'Mes Routes'),
            Tab(icon: Icon(Icons.inventory), text: 'Mes Colis'),
            Tab(icon: Icon(Icons.description), text: 'Feuilles de Route'),
            Tab(icon: Icon(Icons.gps_fixed), text: 'Géolocalisation'),
            Tab(icon: Icon(Icons.photo_camera), text: 'Preuves'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MyDeliveriesTab(),
          MyRoutesTab(),
          MyParcelsTab(),
          RouteSheetsTab(),
          GeolocationTab(),
          DeliveryProofTab(),
        ],
      ),
    );
  }
}

