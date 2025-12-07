import 'api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getLivreurDashboard() async {
    try {
      final response = await _apiService.get('/dashboard/livreur');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return data['data'] as Map<String, dynamic>;
        }
        return data as Map<String, dynamic>;
      }
      throw Exception('Erreur lors de la récupération du dashboard livreur');
    } catch (e) {
      throw Exception('Erreur lors de la récupération du dashboard livreur: $e');
    }
  }
}

