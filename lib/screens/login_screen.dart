import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _clearError() {
    // Les erreurs sont maintenant affichées via SnackBar, pas besoin de state
  }

  String _getErrorMessage(dynamic error) {
    if (error == null) return 'Une erreur est survenue';
    
    final errorString = error.toString().toLowerCase();
    
    // Messages d'erreur spécifiques
    if (errorString.contains('timeout') || errorString.contains('connection')) {
      return 'Erreur de connexion. Vérifiez votre connexion internet et que le serveur est démarré.';
    }
    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return 'Nom d\'utilisateur ou mot de passe incorrect.';
    }
    if (errorString.contains('403') || errorString.contains('forbidden')) {
      return 'Accès refusé. Vérifiez vos permissions.';
    }
    if (errorString.contains('404') || errorString.contains('not found')) {
      return 'Service non trouvé. Vérifiez la configuration de l\'API.';
    }
    if (errorString.contains('500') || errorString.contains('server')) {
      return 'Erreur serveur. Veuillez réessayer plus tard.';
    }
    if (errorString.contains('network') || errorString.contains('socket')) {
      return 'Problème de réseau. Vérifiez votre connexion.';
    }
    
    // Message par défaut
    return 'Erreur de connexion. Veuillez réessayer.';
  }

  Future<void> _handleLogin() async {
    // Test immédiat pour vérifier que le bouton fonctionne
    debugPrint('🔵🔵🔵 DEBUG LoginScreen: BOUTON CLIQUÉ - FONCTION APPELÉE 🔵🔵🔵');
    
    // Test visuel immédiat - SnackBar pour confirmer que le bouton fonctionne
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Connexion en cours...'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ),
    );
    
    _clearError();
    
    // Debug: Vérifier la validation
    if (!_formKey.currentState!.validate()) {
      debugPrint('🔴 DEBUG LoginScreen: Validation échouée');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Veuillez remplir tous les champs correctement',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    
    debugPrint('🔵 DEBUG LoginScreen: Début de la connexion pour: $username');
    debugPrint('🔵 DEBUG LoginScreen: Mot de passe fourni: ${password.isNotEmpty ? "Oui" : "Non"}');

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔵 DEBUG LoginScreen: Récupération du AuthProvider');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      debugPrint('🔵 DEBUG LoginScreen: Appel de authProvider.login()');
      
      final result = await authProvider.login(username, password);

      debugPrint('🔵 DEBUG LoginScreen: Résultat reçu: $result');
      debugPrint('🔵 DEBUG LoginScreen: Success: ${result['success']}');
      debugPrint('🔵 DEBUG LoginScreen: Message: ${result['message']}');

      if (!mounted) {
        debugPrint('🔴 DEBUG LoginScreen: Widget non monté, retour');
        return;
      }

      if (result['success'] == true) {
        debugPrint('✅ DEBUG LoginScreen: Connexion réussie');
        // Succès - Le AuthWrapper dans main.dart gérera automatiquement la navigation
        // Pas besoin de navigation manuelle, le Provider notifiera les listeners
        setState(() {
          _isLoading = false;
        });
        // Le AuthWrapper détectera le changement d'état et affichera le dashboard
      } else {
        debugPrint('🔴 DEBUG LoginScreen: Échec de connexion: ${result['message']}');
        // Erreur de connexion - Afficher un SnackBar
        setState(() {
          _isLoading = false;
        });
        final errorMsg = _getErrorMessage(result['message']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMsg,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: 'Fermer',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('🔴 DEBUG LoginScreen: Exception capturée: $e');
      debugPrint('🔴 DEBUG LoginScreen: Type: ${e.runtimeType}');
      debugPrint('🔴 DEBUG LoginScreen: Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        final errorMsg = _getErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    errorMsg,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Fermer',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final padding = ResponsiveHelper.getHorizontalPadding(context);
                final maxWidth = ResponsiveHelper.isMobile(context) 
                    ? double.infinity 
                    : ResponsiveHelper.isTablet(context)
                        ? 500.0
                        : 400.0;
                
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: ResponsiveHelper.isMobile(context) ? 24.0 : 32.0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inventory_2,
                          size: 64,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // App Name
                      Text(
                        'Gestion Stock',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connectez-vous pour accéder à votre espace',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      // Username Field
                      TextFormField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Nom d\'utilisateur',
                          hintText: 'Entrez votre nom d\'utilisateur',
                          prefixIcon: Icon(Icons.person_outline, color: theme.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.primaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez entrer votre nom d\'utilisateur';
                          }
                          if (value.trim().length < 3) {
                            return 'Le nom d\'utilisateur doit contenir au moins 3 caractères';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _usernameFocusNode.unfocus();
                          _passwordFocusNode.requestFocus();
                        },
                        onChanged: (_) => _clearError(),
                      ),
                      const SizedBox(height: 20),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          hintText: 'Entrez votre mot de passe',
                          prefixIcon: Icon(Icons.lock_outline, color: theme.primaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.primaryColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          if (value.length < 4) {
                            return 'Le mot de passe doit contenir au moins 4 caractères';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        onChanged: (_) => _clearError(),
                      ),
                      const SizedBox(height: 32),
                      
                      // Login Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Help Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Problème de connexion ? Contactez l\'administrateur',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
                },
              ),
            ),
          ),
        ),
      );
    }
  }
