import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/notification_service.dart';
import 'services/delivery_polling_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  
  // Initialiser le service de notifications
  await NotificationService().initialize();
  
  runApp(const GestionStockApp());
}

class GestionStockApp extends StatelessWidget {
  const GestionStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Gestion Stock',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final DeliveryPollingService _pollingService = DeliveryPollingService();

  @override
  void dispose() {
    _pollingService.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        debugPrint('🔵 DEBUG AuthWrapper: isLoading: ${authProvider.isLoading}, isAuthenticated: ${authProvider.isAuthenticated}');
        debugPrint('🔵 DEBUG AuthWrapper: currentUser: ${authProvider.currentUser?.username}, role: ${authProvider.currentUser?.role}');
        
        if (authProvider.isLoading) {
          debugPrint('🔵 DEBUG AuthWrapper: Affichage du loader');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (authProvider.isAuthenticated && authProvider.currentUser != null) {
          debugPrint('✅ DEBUG AuthWrapper: Navigation vers DashboardScreen');
          
          // Démarrer le polling pour les notifications si l'utilisateur est un livreur
          final userRole = authProvider.currentUser?.role;
          if (userRole == 'LIVREUR' || userRole == 'livreur') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _pollingService.startPolling(intervalSeconds: 30);
            });
          }
          
          // Utiliser une clé unique basée sur l'utilisateur pour forcer la reconstruction
          return DashboardScreen(key: ValueKey('dashboard_${authProvider.currentUser?.id}_${authProvider.currentUser?.username}'));
        } else {
          // Arrêter le polling si l'utilisateur se déconnecte
          _pollingService.stopPolling();
        }
        
        debugPrint('🔵 DEBUG AuthWrapper: Affichage du LoginScreen');
        return const LoginScreen();
      },
    );
  }
}
