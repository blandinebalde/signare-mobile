import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        _currentUser = await _authService.getCurrentUser();
        _isAuthenticated = _currentUser != null;
      }
    } catch (e) {
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    // Réinitialiser l'état avant de commencer le login
    debugPrint('🔵 DEBUG AuthProvider: Réinitialisation de l\'état avant login');
    _isLoading = true;
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();

    try {
      debugPrint('🔵 DEBUG AuthProvider: Début login pour $username');
      final result = await _authService.login(username, password);
      
      debugPrint('🔵 DEBUG AuthProvider: Résultat login: ${result['success']}');
      debugPrint('🔵 DEBUG AuthProvider: User reçu: ${result['user']}');
      
      if (result['success'] == true) {
        _currentUser = result['user'] as User?;
        debugPrint('🔵 DEBUG AuthProvider: CurrentUser défini - Role: ${_currentUser?.role}, Username: ${_currentUser?.username}');
        
        // S'assurer que l'utilisateur est bien défini avant de marquer comme authentifié
        if (_currentUser != null) {
          _isAuthenticated = true;
          debugPrint('✅ DEBUG AuthProvider: Authentification réussie - isAuthenticated: $_isAuthenticated');
        } else {
          debugPrint('⚠️ DEBUG AuthProvider: User est null, tentative de récupération depuis le service');
          // Essayer de récupérer l'utilisateur depuis le service
          _currentUser = await _authService.getCurrentUser();
          _isAuthenticated = _currentUser != null;
          debugPrint('🔵 DEBUG AuthProvider: User récupéré depuis service - isAuthenticated: $_isAuthenticated');
        }
        
        // Notifier immédiatement après avoir défini l'état
        _isLoading = false;
        notifyListeners();
        debugPrint('✅ DEBUG AuthProvider: Listeners notifiés - isAuthenticated: $_isAuthenticated, currentUser: ${_currentUser?.username}');
        
        return {'success': true};
      } else {
        debugPrint('🔴 DEBUG AuthProvider: Échec login - ${result['message']}');
        _isLoading = false;
        _isAuthenticated = false;
        _currentUser = null;
        notifyListeners();
        return result;
      }
    } catch (e, stackTrace) {
      debugPrint('🔴 DEBUG AuthProvider: Exception lors du login: $e');
      debugPrint('🔴 DEBUG AuthProvider: Stack trace: $stackTrace');
      _isLoading = false;
      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> logout() async {
    debugPrint('🔵 DEBUG AuthProvider: Début déconnexion');
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.logout();
      debugPrint('✅ DEBUG AuthProvider: Logout service terminé');
    } catch (e) {
      debugPrint('⚠️ DEBUG AuthProvider: Erreur lors du logout service: $e');
    }
    
    // Réinitialiser complètement l'état
    _currentUser = null;
    _isAuthenticated = false;
    _isLoading = false;
    
    debugPrint('✅ DEBUG AuthProvider: État réinitialisé - isAuthenticated: $_isAuthenticated');
    notifyListeners();
    debugPrint('✅ DEBUG AuthProvider: Listeners notifiés après logout');
  }
}

