class AppConfig {
  // API Configuration
  // IMPORTANT: Remplacez VOTRE_IP par l'adresse IP de votre PC sur le réseau local
  // Pour trouver votre IP:
  //   Windows: Ouvrez CMD et tapez "ipconfig", cherchez "Adresse IPv4" (ex: 192.168.1.100)
  //   Mac/Linux: Ouvrez Terminal et tapez "ifconfig" ou "ip addr"
  // 
  // Options selon votre environnement:
  // - Téléphone physique: Utilisez l'IP de votre PC (ex: 192.168.1.100)
  // - Émulateur Android: Utilisez 10.0.2.2
  // - Windows Desktop/Chrome: Utilisez localhost
  
  // ⚠️ REMPLACEZ CETTE IP PAR L'IP DE VOTRE PC ⚠️
  static const String baseUrl = 'http://192.168.1.20:8080/api';  // Exemple: 'http://192.168.1.100:8080/api'
  static const String publicApiUrl = 'http://192.168.1.20:8080/api/public';
  static const String imageBaseUrl = 'http://192.168.1.20:8080/api/images';
  
  // Décommentez la ligne appropriée selon votre environnement:
  // static const String baseUrl = 'http://10.0.2.2:8080/api';  // Émulateur Android
  // static const String baseUrl = 'http://localhost:8080/api';  // Windows Desktop/Chrome
  
  // API Timeout (augmenté pour les connexions réseau lentes)
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  
  // App Info
  static const String appName = 'Gestion Stock';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String entrepotKey = 'selected_entrepot';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss';
}

