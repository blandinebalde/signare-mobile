# 🔔 Guide des Notifications

## 📋 Vue d'ensemble

L'application Flutter envoie des notifications automatiques pour :
- ✅ **Nouvelles livraisons** : Quand une nouvelle livraison est assignée au livreur
- ✅ **Livraisons complétées** : Quand une livraison est marquée comme terminée
- ✅ **Livraisons retournées** : Quand une livraison est retournée ou annulée

## 🚀 Installation

### 1. Installer les dépendances

```bash
cd mobile/gestion_stock_app
flutter pub get
```

### 2. Permissions Android

Les permissions sont déjà configurées dans `AndroidManifest.xml` :
- `POST_NOTIFICATIONS` : Pour afficher les notifications
- `VIBRATE` : Pour la vibration
- `RECEIVE_BOOT_COMPLETED` : Pour redémarrer le service après le boot
- `WAKE_LOCK` : Pour maintenir l'app active

### 3. Rebuild de l'application

```bash
flutter clean
flutter run
```

## 🔧 Fonctionnement

### Service de Polling

Le `DeliveryPollingService` vérifie automatiquement les nouvelles livraisons toutes les **30 secondes** (configurable).

- **Démarrage automatique** : Le polling démarre automatiquement quand un utilisateur avec le rôle `LIVREUR` se connecte
- **Arrêt automatique** : Le polling s'arrête quand l'utilisateur se déconnecte
- **Stockage local** : Les IDs des livraisons déjà notifiées sont stockés localement pour éviter les doublons

### Types de Notifications

1. **Nouvelle livraison** (`newDelivery`)
   - Déclenché quand une livraison avec le statut `EN_ATTENTE` est détectée
   - Seulement pour les livraisons créées dans les dernières 24h

2. **Livraison complétée** (`deliveryCompleted`)
   - Déclenché quand une livraison passe au statut `LIVREE`
   - Seulement pour les mises à jour récentes (dans les 2 dernières heures)

3. **Livraison retournée** (`deliveryReturned`)
   - Déclenché quand une livraison passe au statut `RETOURNE` ou `ANNULEE`

## 📱 Interface Utilisateur

### Badge de Notifications

Un badge rouge avec le nombre de notifications non lues apparaît sur l'icône de notifications dans la barre d'application.

### Écran de Notifications

L'écran de notifications (`NotificationsScreen`) affiche :
- Liste de toutes les notifications
- Indicateur visuel pour les notifications non lues
- Possibilité de marquer toutes les notifications comme lues
- Possibilité de supprimer une notification par glissement
- Navigation vers les détails de la livraison en tapant sur une notification

## ⚙️ Configuration

### Modifier l'intervalle de polling

Dans `main.dart`, modifiez l'intervalle (en secondes) :

```dart
_pollingService.startPolling(intervalSeconds: 60); // 60 secondes au lieu de 30
```

### Personnaliser les notifications

Dans `notification_service.dart`, vous pouvez modifier :
- Les icônes
- Les couleurs
- Les sons
- Les vibrations

## 🐛 Dépannage

### Les notifications ne s'affichent pas

1. **Vérifier les permissions** : Assurez-vous que les permissions sont accordées dans les paramètres Android
2. **Vérifier les logs** : Regardez les logs Flutter pour voir si le polling fonctionne
3. **Vérifier la connexion** : Assurez-vous que l'app peut se connecter au backend

### Le polling ne démarre pas

1. **Vérifier le rôle** : Le polling ne démarre que pour les utilisateurs avec le rôle `LIVREUR`
2. **Vérifier les logs** : Regardez les logs pour voir les messages de démarrage/arrêt

### Notifications en double

Les IDs des livraisons notifiées sont stockés localement. Si vous voyez des doublons :
1. Vider le cache de l'app
2. Réinstaller l'app

## 📝 Notes Techniques

- Les notifications sont stockées localement dans la mémoire de l'app
- Les IDs notifiés sont sauvegardés dans `SharedPreferences`
- Le polling s'arrête automatiquement quand l'app est fermée
- Les notifications persistent même après redémarrage de l'app (via SharedPreferences)

