import '../models/order_model.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();

  Future<List<Order>> getAllOrders({
    int? entrepotId,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (entrepotId != null) queryParams['entrepotId'] = entrepotId;
      if (status != null) queryParams['status'] = status;

      final response = await _apiService.get('/orders', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          final List<dynamic> ordersJson = data['data'] as List<dynamic>;
          return ordersJson.map((json) => Order.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((json) => Order.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des commandes: $e');
    }
  }

  Future<Order?> getOrderById(int id) async {
    try {
      final response = await _apiService.get('/orders/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Order.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Order.fromJson(data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la commande: $e');
    }
  }

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _apiService.post('/orders', data: orderData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Order.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Order.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la création de la commande');
    } catch (e) {
      throw Exception('Erreur lors de la création de la commande: $e');
    }
  }

  Future<Order> updateOrderStatus(int id, String status) async {
    try {
      final response = await _apiService.put('/orders/$id/status', data: {'status': status});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Order.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Order.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la mise à jour du statut');
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }
}

