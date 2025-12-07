import '../models/delivery_model.dart';
import 'api_service.dart';

class DeliveryService {
  final ApiService _apiService = ApiService();

  Future<List<Delivery>> getAllDeliveries({
    String? status,
    int? livreurId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (livreurId != null) queryParams['livreurId'] = livreurId;

      final response = await _apiService.get('/deliveries', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          final List<dynamic> deliveriesJson = data['data'] as List<dynamic>;
          return deliveriesJson.map((json) => Delivery.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((json) => Delivery.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des livraisons: $e');
    }
  }

  Future<Delivery?> getDeliveryById(int id) async {
    try {
      final response = await _apiService.get('/deliveries/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Delivery.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Delivery.fromJson(data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la livraison: $e');
    }
  }

  Future<Delivery> updateDeliveryStatus(int id, String status) async {
    try {
      final response = await _apiService.put(
        '/deliveries/$id/status',
        data: {'status': status},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Delivery.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Delivery.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la mise à jour du statut');
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }

  Future<List<Delivery>> getMyDeliveries() async {
    try {
      final response = await _apiService.get('/delivery/livreur/my-deliveries');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          final List<dynamic> deliveriesJson = data['data'] as List<dynamic>;
          return deliveriesJson.map((json) => Delivery.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((json) => Delivery.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération de mes livraisons: $e');
    }
  }

  /// Démarrer une livraison en utilisant la référence
  /// Met à jour automatiquement le statut de la livraison ET de la commande associée
  Future<Delivery> startDelivery(String reference) async {
    try {
      final response = await _apiService.patch('/deliveries/$reference/start-delivery');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Delivery.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Delivery.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors du démarrage de la livraison');
    } catch (e) {
      throw Exception('Erreur lors du démarrage de la livraison: $e');
    }
  }

  /// Terminer une livraison avec paiement
  /// Crée automatiquement la facture et enregistre le paiement
  Future<Delivery> finishDeliveryWithPayment(String reference, Map<String, dynamic> paymentData) async {
    try {
      final response = await _apiService.patch(
        '/deliveries/$reference/finish-delivery',
        data: paymentData,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Delivery.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Delivery.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la finalisation de la livraison');
    } catch (e) {
      throw Exception('Erreur lors de la finalisation de la livraison: $e');
    }
  }

  /// Terminer une livraison sans paiement (paiement différé)
  Future<Delivery> finishDelivery(String reference) async {
    try {
      final response = await _apiService.patch('/deliveries/$reference/finish-delivery');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Delivery.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Delivery.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la finalisation de la livraison');
    } catch (e) {
      throw Exception('Erreur lors de la finalisation de la livraison: $e');
    }
  }

  /// Retourner une livraison (annuler une commande en cours)
  /// Met à jour automatiquement le statut de la livraison ET de la commande associée
  Future<Delivery> returnDelivery(String reference, String reason) async {
    try {
      final response = await _apiService.patch(
        '/deliveries/$reference/return',
        data: {'reason': reason},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Delivery.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Delivery.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors du retour de la livraison');
    } catch (e) {
      throw Exception('Erreur lors du retour de la livraison: $e');
    }
  }
}

