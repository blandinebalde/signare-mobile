# Gestion Stock App - Application Flutter

Application mobile Flutter pour la gestion de stock, intégrée avec le backend Spring Boot.

## 📋 Prérequis

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code avec extensions Flutter
- Backend Spring Boot en cours d'exécution (port 8080)

## 🚀 Installation

1. **Installer les dépendances Flutter** :
```bash
cd mobile/gestion_stock_app
flutter pub get
```

2. **Configurer l'URL de l'API** :
Modifiez le fichier `lib/config/app_config.dart` pour pointer vers votre backend :
```dart
static const String baseUrl = 'http://VOTRE_IP:8080/api';
```

Pour Android Emulator, utilisez `http://10.0.2.2:8080/api`
Pour iOS Simulator, utilisez `http://localhost:8080/api`
Pour un appareil physique, utilisez l'IP de votre machine : `http://192.168.x.x:8080/api`

3. **Lancer l'application** :
```bash
flutter run
```

## 📱 Structure du Projet

```
lib/
├── config/              # Configuration de l'application
│   └── app_config.dart
├── models/              # Modèles de données
│   ├── user_model.dart
│   ├── product_model.dart
│   ├── entrepot_product_model.dart
│   ├── vente_model.dart
│   ├── transaction_model.dart
│   └── account_model.dart
├── services/            # Services API
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── product_service.dart
│   ├── vente_service.dart
│   └── finance_service.dart
├── providers/           # State Management (Provider)
│   ├── auth_provider.dart
│   └── product_provider.dart
├── screens/             # Écrans de l'application
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── products_screen.dart
│   ├── sales_screen.dart
│   └── profile_screen.dart
└── main.dart            # Point d'entrée
```

## 🔧 Dépendances Principales

- **provider** : Gestion d'état
- **dio** : Client HTTP pour les appels API
- **shared_preferences** : Stockage local
- **intl** : Formatage des dates et nombres
- **equatable** : Comparaison d'objets

## 📦 Fonctionnalités

### ✅ Implémentées

- 🔐 Authentification (Login/Logout)
- 📊 Tableau de bord avec statistiques
- 📦 Gestion des produits
- 💰 Gestion des ventes
- 👤 Profil utilisateur
- 🔄 Pull-to-refresh
- 🔍 Recherche de produits

### 🚧 À implémenter

- ➕ Création/Modification de produits
- ➕ Création de ventes
- 📈 Graphiques et analytics
- 💳 Module Finance complet
- 📱 Notifications push
- 🔔 Alertes de stock
- 📸 Scan de codes-barres
- 🌐 Mode hors ligne

## 🔌 Intégration Backend

L'application communique avec le backend via les endpoints suivants :

- **Authentification** : `/api/auth/login`, `/api/auth/me`
- **Produits** : `/api/products`, `/api/entrepot-products`
- **Ventes** : `/api/ventes`
- **Finance** : `/api/finance/*`

## 🛠️ Développement

### Lancer en mode debug
```bash
flutter run
```

### Lancer sur un appareil spécifique
```bash
flutter devices                    # Lister les appareils
flutter run -d <device-id>         # Lancer sur un appareil
```

### Construire pour Android
```bash
flutter build apk                  # APK de release
flutter build apk --split-per-abi # APK optimisé par architecture
```

### Construire pour iOS
```bash
flutter build ios
```

## 🐛 Dépannage

### Erreur de connexion au backend
- Vérifiez que le backend est en cours d'exécution
- Vérifiez l'URL dans `app_config.dart`
- Pour Android Emulator, utilisez `10.0.2.2` au lieu de `localhost`
- Vérifiez les permissions réseau dans `AndroidManifest.xml`

### Erreurs de dépendances
```bash
flutter clean
flutter pub get
```

### Erreurs de build
```bash
flutter doctor                    # Vérifier l'installation
flutter upgrade                   # Mettre à jour Flutter
```

## 📝 Notes

- L'application utilise Provider pour la gestion d'état
- Les tokens d'authentification sont stockés localement
- Les données sont mises en cache pour améliorer les performances
- L'application supporte le mode hors ligne basique (avec limitations)

## 🔐 Sécurité

- Les tokens sont stockés de manière sécurisée avec `shared_preferences`
- Les requêtes API incluent automatiquement le token d'authentification
- Les erreurs sont gérées de manière centralisée

## 📄 Licence

Ce projet fait partie du système de gestion de stock.
