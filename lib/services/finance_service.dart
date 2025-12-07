import '../models/transaction_model.dart';
import '../models/account_model.dart';
import 'api_service.dart';

class FinanceService {
  final ApiService _apiService = ApiService();

  // Get all accounts
  Future<List<Account>> getAccounts() async {
    try {
      final response = await _apiService.get('/finance/accounts');
      if (response.statusCode == 200) {
        final List<dynamic> accountsJson = response.data as List<dynamic>;
        return accountsJson.map((json) => Account.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des comptes: $e');
    }
  }

  // Get all transactions
  Future<List<Transaction>> getTransactions({
    String? type,
    int? accountId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      if (accountId != null) queryParams['accountId'] = accountId;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get('/finance/transactions', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final List<dynamic> transactionsJson = response.data as List<dynamic>;
        return transactionsJson.map((json) => Transaction.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des transactions: $e');
    }
  }

  // Get expenses
  Future<List<Transaction>> getExpenses({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get('/finance/expenses', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final List<dynamic> expensesJson = response.data as List<dynamic>;
        return expensesJson.map((json) => Transaction.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des dépenses: $e');
    }
  }

  // Create expense
  Future<Transaction> createExpense(Transaction expense) async {
    try {
      final response = await _apiService.post('/finance/expenses', data: expense.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Transaction.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Erreur lors de la création de la dépense');
    } catch (e) {
      throw Exception('Erreur lors de la création de la dépense: $e');
    }
  }

  // Get sales revenue summary
  Future<Map<String, dynamic>> getSalesRevenueSummary({
    int? entrepotId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (entrepotId != null) queryParams['entrepotId'] = entrepotId;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get('/finance/sales/revenue/summary', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      throw Exception('Erreur lors de la récupération du résumé des ventes: $e');
    }
  }

  // Get finance dashboard summary
  Future<Map<String, dynamic>> getFinanceDashboardSummary() async {
    try {
      final response = await _apiService.get('/finance/dashboard/summary');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      throw Exception('Erreur lors de la récupération du résumé financier: $e');
    }
  }
}

