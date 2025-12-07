import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/income_model.dart';
import '../config/app_config.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeService {
  final ApiService _apiService = ApiService();

  Future<List<Income>> getInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    int? entrepotId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }
      if (status != null) queryParams['status'] = status;
      if (entrepotId != null) queryParams['entrepotId'] = entrepotId;

      final response = await _apiService.get('/incomes', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        // La réponse peut être dans 'data' ou directement une liste
        if (data is Map) {
          if (data.containsKey('data')) {
            final incomesData = data['data'];
            if (incomesData is List) {
              return incomesData.map((json) => Income.fromJson(json as Map<String, dynamic>)).toList();
            }
          } else if (data.containsKey('content')) {
            final List<dynamic> incomesJson = data['content'] as List<dynamic>;
            return incomesJson.map((json) => Income.fromJson(json as Map<String, dynamic>)).toList();
          }
        } else if (data is List) {
          return data.map((json) => Income.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des factures: $e');
    }
  }

  Future<List<Income>> getWeeklyInvoices() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return getInvoices(
      startDate: startOfWeek,
      endDate: endOfWeek,
    );
  }

  Future<Income?> getInvoiceById(int id) async {
    try {
      final response = await _apiService.get('/incomes/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          return Income.fromJson(data['data'] as Map<String, dynamic>);
        }
        return Income.fromJson(data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la facture: $e');
    }
  }

  Future<File?> downloadInvoicePdf(int invoiceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final url = Uri.parse('${AppConfig.baseUrl}/pdf/facture/$invoiceId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/pdf',
        },
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/facture_$invoiceId.pdf');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors du téléchargement de la facture: $e');
    }
  }
}

