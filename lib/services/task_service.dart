import '../models/task_model.dart';
import 'api_service.dart';

class TaskService {
  final ApiService _apiService = ApiService();

  Future<List<Task>> getTasks({
    int page = 0,
    int size = 20,
    String? status,
    String? priority,
    String sortBy = 'scheduledDate',
    String sortDir = 'desc',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'sortDir': sortDir,
      };
      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;

      final response = await _apiService.get(
        '/operations/taches',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('content')) {
          final List<dynamic> tasksJson = data['content'] as List<dynamic>;
          return tasksJson.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is Map && data.containsKey('data')) {
          final List<dynamic> tasksJson = data['data'] as List<dynamic>;
          return tasksJson.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des tâches: $e');
    }
  }

  Future<Task?> getTaskById(int id) async {
    try {
      final response = await _apiService.get('/operations/taches/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Task.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Task.fromJson(data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la tâche: $e');
    }
  }

  Future<Task> updateTaskStatus(int id, String status) async {
    try {
      final response = await _apiService.put(
        '/operations/taches/$id/status',
        data: {'status': status},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Task.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Task.fromJson(data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la mise à jour du statut');
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }
}

