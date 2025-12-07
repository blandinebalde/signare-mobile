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
}

