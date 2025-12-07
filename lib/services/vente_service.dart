import '../models/vente_model.dart';
import 'api_service.dart';

class VenteService {
  final ApiService _apiService = ApiService();

  // Get all sales
  Future<List<Vente>> getVentes({
    int? page,
    int? size,
    int? entrepotId,
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (size != null) queryParams['size'] = size;
      if (entrepotId != null) queryParams['entrepotId'] = entrepotId;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (status != null) queryParams['status'] = status;

      final response = await _apiService.get('/ventes', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('content')) {
          final List<dynamic> ventesJson = data['content'] as List<dynamic>;
          return ventesJson.map((json) => Vente.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((json) => Vente.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des ventes: $e');
    }
  }

  // Get sale by ID
  Future<Vente?> getVenteById(int id) async {
    try {
      final response = await _apiService.get('/ventes/$id');
      if (response.statusCode == 200) {
        return Vente.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la vente: $e');
    }
  }

  // Create sale
  Future<Vente> createVente(Map<String, dynamic> venteData) async {
    try {
      final response = await _apiService.post('/ventes', data: venteData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Vente.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la création de la vente');
    } catch (e) {
      throw Exception('Erreur lors de la création de la vente: $e');
    }
  }

  // Get sales statistics
  Future<Map<String, dynamic>> getSalesStatistics({
    int? entrepotId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (entrepotId != null) queryParams['entrepotId'] = entrepotId;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get('/ventes/statistics', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      throw Exception('Erreur lors de la récupération des statistiques: $e');
    }
  }
}

