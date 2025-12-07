# Structure de l'Application Flutter

## Architecture

L'application suit une architecture en couches :

```
┌─────────────────────────────────────┐
│         UI Layer (Screens)          │
│  - Login, Dashboard, Products, etc. │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      State Management (Providers)     │
│  - AuthProvider, ProductProvider    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        Service Layer                 │
│  - AuthService, ProductService, etc.│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        API Service (Dio)            │
│  - HTTP requests, interceptors      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        Backend API                   │
│  - Spring Boot REST API              │
└──────────────────────────────────────┘
```

## Flux de Données

1. **User Action** → Screen
2. **Screen** → Provider (via Consumer)
3. **Provider** → Service
4. **Service** → ApiService
5. **ApiService** → Backend API
6. **Response** → Service → Provider → Screen (UI Update)

## Modèles de Données

Tous les modèles étendent `Equatable` pour la comparaison :
- `User` : Informations utilisateur
- `Product` : Produit de base
- `EntrepotProduct` : Produit dans un entrepôt (avec stock)
- `Vente` : Transaction de vente
- `Transaction` : Transaction financière
- `Account` : Compte bancaire/financier

## Services

### ApiService
- Singleton pour toutes les requêtes HTTP
- Gestion automatique des tokens
- Gestion centralisée des erreurs
- Intercepteurs pour logging et auth

### AuthService
- Login/Logout
- Gestion des tokens
- Récupération de l'utilisateur actuel

### ProductService
- CRUD produits
- Recherche et filtrage
- Gestion des stocks

### VenteService
- Liste des ventes
- Création de ventes
- Statistiques de ventes

### FinanceService
- Gestion des comptes
- Transactions financières
- Dépenses
- Revenus des ventes

## Providers (State Management)

### AuthProvider
- État d'authentification
- Utilisateur actuel
- Méthodes login/logout

### ProductProvider
- Liste des produits
- État de chargement
- Gestion des erreurs

## Navigation

Navigation basée sur `BottomNavigationBar` :
- **Accueil** : Dashboard avec statistiques
- **Produits** : Liste et gestion des produits
- **Ventes** : Liste des ventes
- **Profil** : Informations utilisateur et paramètres

## Configuration

### app_config.dart
- URLs de l'API
- Timeouts
- Clés de stockage
- Formats de date

## Bonnes Pratiques

1. **Séparation des responsabilités** : Chaque couche a un rôle précis
2. **Réutilisabilité** : Services et widgets réutilisables
3. **Gestion d'erreurs** : Erreurs gérées à chaque niveau
4. **Performance** : Mise en cache et lazy loading
5. **Sécurité** : Tokens stockés de manière sécurisée

