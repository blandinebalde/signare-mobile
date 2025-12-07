# ✅ Vérification de la Configuration

## 📋 Checklist Rapide

### 1. Vérifier votre IP actuelle

Dans PowerShell, tapez :
```powershell
ipconfig
```

Cherchez votre **Adresse IPv4** sous votre connexion Wi-Fi.

### 2. Vérifier que l'IP dans `app_config.dart` correspond

Ouvrez `lib/config/app_config.dart` et vérifiez que l'IP correspond à celle trouvée avec `ipconfig`.

### 3. Vérifier que le backend est accessible

**Sur votre téléphone**, ouvrez un navigateur et allez à :
```
http://VOTRE_IP:8080/api/auth/login
```

**Exemple** : Si votre IP est `192.168.1.20`, allez à :
```
http://192.168.1.20:8080/api/auth/login
```

**Résultat attendu** :
- ✅ Si vous voyez une erreur JSON (ex: "Method not allowed"), c'est **BON** ! Le serveur répond.
- ❌ Si vous voyez "Impossible d'accéder au site" ou "Connection refused", le serveur n'est pas accessible.

---

## 🔧 Si le serveur n'est pas accessible

### Problème 1 : Pare-feu Windows

**Solution** :
1. Ouvrez **Pare-feu Windows Defender**
2. Cliquez sur **Paramètres avancés**
3. Cliquez sur **Règles de trafic entrant**
4. Cliquez sur **Nouvelle règle**
5. Choisissez **Port** → **TCP** → **8080**
6. Autorisez la connexion
7. Appliquez à tous les profils

**OU** temporairement désactivez le pare-feu pour tester.

### Problème 2 : Backend n'écoute pas sur toutes les interfaces

**Vérifiez** dans votre backend Spring Boot (`application.properties`) :
```properties
server.address=0.0.0.0
server.port=8080
```

Si c'est `server.address=localhost`, changez-le en `0.0.0.0`.

### Problème 3 : PC et téléphone pas sur le même réseau

**Vérifiez** :
- Les deux sont connectés au **même Wi-Fi**
- Le téléphone peut accéder à Internet

---

## 🎯 Configuration Finale

Une fois que vous avez trouvé votre IP (ex: `192.168.1.20`), votre `app_config.dart` devrait être :

```dart
static const String baseUrl = 'http://192.168.1.20:8080/api';
static const String publicApiUrl = 'http://192.168.1.20:8080/api/public';
static const String imageBaseUrl = 'http://192.168.1.20:8080/api/images';
```

---

## 🚀 Test Final

1. **Relancez l'app** : `flutter run`
2. **Testez la connexion** avec vos identifiants
3. **Regardez les logs** dans le terminal pour voir les requêtes

---

**Si tout est bien configuré, la connexion devrait fonctionner !** ✅

