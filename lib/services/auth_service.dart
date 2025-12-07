import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    debugPrint('🔵 DEBUG AuthService: Début login pour $username');
    debugPrint('🔵 DEBUG AuthService: URL base: ${AppConfig.baseUrl}');
    
    try {
      debugPrint('🔵 DEBUG AuthService: Envoi requête POST à /auth/login');
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      debugPrint('🔵 DEBUG AuthService: Réponse reçue - Status: ${response.statusCode}');
      debugPrint('🔵 DEBUG AuthService: Réponse data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('🔵 DEBUG AuthService: Type de data: ${data.runtimeType}');
        
        // Gérer différents formats de réponse
        Map<String, dynamic> responseData;
        if (data is Map) {
          responseData = Map<String, dynamic>.from(data);
        } else if (data is String) {
          // Si c'est une chaîne JSON
          responseData = jsonDecode(data) as Map<String, dynamic>;
        } else {
          debugPrint('🔴 DEBUG AuthService: Format de réponse inattendu: $data');
          return {'success': false, 'message': 'Format de réponse inattendu du serveur'};
        }
        
        final token = responseData['token'] as String? ?? responseData['jwt'] as String?;
        final userData = responseData['user'] as Map<String, dynamic>?;
        final dataField = responseData['data'] as Map<String, dynamic>?;
        
        // Le rôle peut aussi être directement dans la réponse
        final roleFromResponse = responseData['role'] as String?;

        debugPrint('🔵 DEBUG AuthService: Token: ${token != null ? "présent" : "absent"}');
        debugPrint('🔵 DEBUG AuthService: UserData: ${userData != null ? "présent" : "absent"}');
        debugPrint('🔵 DEBUG AuthService: Data field: ${dataField != null ? "présent" : "absent"}');
        debugPrint('🔵 DEBUG AuthService: Role from response: $roleFromResponse');

        // Essayer aussi dans le champ 'data' si présent
        Map<String, dynamic>? finalUserData = userData ?? dataField;
        
        // Si le rôle est dans la réponse mais pas dans userData, l'ajouter
        if (finalUserData != null && roleFromResponse != null && finalUserData['role'] == null) {
          finalUserData = Map<String, dynamic>.from(finalUserData);
          finalUserData['role'] = roleFromResponse;
          debugPrint('🔵 DEBUG AuthService: Role ajouté au userData: $roleFromResponse');
        }
        
        final finalToken = token;

        if (finalToken != null) {
          debugPrint('✅ DEBUG AuthService: Sauvegarde du token');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppConfig.tokenKey, finalToken);
          
          if (finalUserData != null) {
            debugPrint('✅ DEBUG AuthService: Sauvegarde des données utilisateur');
            debugPrint('🔵 DEBUG AuthService: Contenu userData avant parsing: $finalUserData');
            final user = User.fromJson(finalUserData);
            debugPrint('🔵 DEBUG AuthService: User parsé - Role: ${user.role}, Username: ${user.username}');
            await prefs.setString(AppConfig.userKey, jsonEncode(finalUserData));
            
            debugPrint('✅ DEBUG AuthService: Login réussi');
            return {
              'success': true,
              'token': finalToken,
              'user': user,
            };
          } else {
            debugPrint('⚠️ DEBUG AuthService: Pas de données utilisateur, création d\'un user minimal avec le rôle');
            // Créer un user minimal avec le rôle si disponible
            if (roleFromResponse != null) {
              final minimalUser = User(
                role: roleFromResponse.toUpperCase(),
              );
              return {
                'success': true,
                'token': finalToken,
                'user': minimalUser,
              };
            }
          }

          debugPrint('✅ DEBUG AuthService: Login réussi (sans données utilisateur)');
          return {
            'success': true,
            'token': finalToken,
            'user': null,
          };
        } else {
          debugPrint('🔴 DEBUG AuthService: Aucun token trouvé dans la réponse');
          return {'success': false, 'message': 'Token non reçu du serveur'};
        }
      }

      // Gestion des erreurs HTTP spécifiques
      debugPrint('🔴 DEBUG AuthService: Code HTTP: ${response.statusCode}');
      if (response.statusCode == 401) {
        return {'success': false, 'message': 'Nom d\'utilisateur ou mot de passe incorrect'};
      } else if (response.statusCode == 403) {
        return {'success': false, 'message': 'Accès refusé. Vérifiez vos permissions'};
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Service d\'authentification non trouvé. Vérifiez l\'URL: ${AppConfig.baseUrl}/auth/login'};
      } else if (response.statusCode == 500) {
        return {'success': false, 'message': 'Erreur serveur. Veuillez réessayer plus tard'};
      }

      return {'success': false, 'message': 'Échec de la connexion. Code: ${response.statusCode}'};
    } catch (e, stackTrace) {
      debugPrint('🔴 DEBUG AuthService: Exception: $e');
      debugPrint('🔴 DEBUG AuthService: Type: ${e.runtimeType}');
      debugPrint('🔴 DEBUG AuthService: Stack trace: $stackTrace');
      
      // Gestion des erreurs réseau et autres exceptions
      final errorMessage = e.toString();
      
      if (errorMessage.contains('SocketException') || 
          errorMessage.contains('Failed host lookup') ||
          errorMessage.contains('Connection refused') ||
          errorMessage.contains('connection error')) {
        return {
          'success': false, 
          'message': 'Impossible de se connecter au serveur. Vérifiez que le serveur est démarré sur ${AppConfig.baseUrl} et que l\'URL est correcte.'
        };
      } else if (errorMessage.contains('TimeoutException') || 
                 errorMessage.contains('timeout') ||
                 errorMessage.contains('Timeout')) {
        return {
          'success': false, 
          'message': 'Timeout de connexion. Le serveur met trop de temps à répondre.'
        };
      }
      
      return {'success': false, 'message': 'Erreur: $errorMessage'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userKey);
    await prefs.remove(AppConfig.entrepotKey);
  }

  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConfig.userKey);
      
      if (userJson != null) {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userData);
      }
      
      // Try to get user from API
      final response = await _apiService.get('/auth/me');
      if (response.statusCode == 200) {
        final userData = response.data as Map<String, dynamic>;
        final user = User.fromJson(userData);
        await prefs.setString(AppConfig.userKey, jsonEncode(userData));
        return user;
      }
    } catch (e) {
      // User not authenticated
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

