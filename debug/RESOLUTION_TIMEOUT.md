# 🔧 Résolution du Problème "Timeout de connexion"

## ✅ Diagnostic

D'après les logs, le problème est : **"Timeout de connexion"**

Cela signifie que :
- ✅ Le bouton fonctionne
- ✅ La validation passe
- ✅ L'app essaie de se connecter au serveur
- ❌ Mais le serveur ne répond pas ou n'est pas accessible

---

## 🔍 Étapes de Diagnostic

### Étape 1 : Vérifier que le backend est lancé

**Sur votre PC**, vérifiez que le backend Spring Boot est bien lancé :
- Vous devriez voir dans la console : `Started Application in X seconds`
- Le backend doit être accessible sur `http://localhost:8080/api`

**Test** : Ouvrez dans votre navigateur PC : `http://localhost:8080/api/auth/login`
- Si vous voyez une erreur JSON (ex: "Method not allowed"), c'est **BON** ✅
- Si vous voyez "Impossible d'accéder", le backend n'est pas lancé ❌

---

### Étape 2 : Vérifier votre IP actuelle

**Dans PowerShell**, tapez :
```powershell
ipconfig
```

Cherchez **"Adresse IPv4"** sous votre connexion Wi-Fi.

**Important** : L'IP peut changer si vous vous reconnectez au Wi-Fi !

---

### Étape 3 : Vérifier que l'IP dans l'app correspond

Ouvrez `lib/config/app_config.dart` et vérifiez que l'IP correspond à celle trouvée avec `ipconfig`.

**Actuellement configuré** : `192.168.1.20`

---

### Étape 4 : Tester depuis le téléphone

**Sur votre téléphone**, ouvrez un navigateur et allez à :
```
http://192.168.1.20:8080/api/auth/login
```

**Résultats possibles** :

1. ✅ **Vous voyez une erreur JSON** (ex: "Method not allowed")
   - C'est **BON** ! Le serveur est accessible
   - Le problème vient peut-être de l'app Flutter

2. ❌ **"Impossible d'accéder au site" ou "Connection refused"**
   - Le serveur n'est pas accessible depuis le téléphone
   - Vérifiez les étapes suivantes

---

## 🔧 Solutions

### Solution 1 : Vérifier le pare-feu Windows

Le pare-feu Windows peut bloquer les connexions entrantes.

**Option A : Autoriser le port 8080**

1. Ouvrez **Pare-feu Windows Defender**
2. Cliquez sur **Paramètres avancés**
3. Cliquez sur **Règles de trafic entrant**
4. Cliquez sur **Nouvelle règle**
5. Choisissez **Port** → **Suivant**
6. Choisissez **TCP** → Entrez **8080** → **Suivant**
7. Choisissez **Autoriser la connexion** → **Suivant**
8. Cochez tous les profils → **Suivant**
9. Donnez un nom (ex: "Spring Boot 8080") → **Terminer**

**Option B : Désactiver temporairement le pare-feu** (pour tester uniquement)

1. Ouvrez **Pare-feu Windows Defender**
2. Cliquez sur **Activer ou désactiver le pare-feu Windows Defender**
3. Désactivez pour les réseaux privés (temporairement)
4. Testez à nouveau

---

### Solution 2 : Vérifier que le backend écoute sur toutes les interfaces

Le backend doit écouter sur `0.0.0.0` et non `localhost`.

**Vérifiez** dans `backend/gestionstock_backend/src/main/resources/application.properties` :

```properties
server.address=0.0.0.0
server.port=8080
server.servlet.context-path=/api
```

✅ **C'est déjà configuré correctement !**

Si vous modifiez cette configuration, **relancez le backend**.

---

### Solution 3 : Vérifier que PC et téléphone sont sur le même réseau

**Vérifiez** :
- Les deux sont connectés au **même Wi-Fi**
- Le téléphone peut accéder à Internet
- L'IP du PC commence par la même plage que celle du téléphone
  - Exemple : PC = `192.168.1.20`, téléphone = `192.168.1.XXX`

---

### Solution 4 : Vérifier l'URL dans l'app

Dans les logs, vous devriez voir :
```
🔵 DEBUG ApiService: Full URL: http://192.168.1.20:8080/api/auth/login
```

Vérifiez que cette URL est correcte.

---

### Solution 5 : Augmenter le timeout

Si le réseau est lent, augmentez le timeout dans `lib/config/app_config.dart` :

```dart
static const Duration connectTimeout = Duration(seconds: 60);  // Au lieu de 30
static const Duration receiveTimeout = Duration(seconds: 60);  // Au lieu de 30
```

---

## 🎯 Checklist Complète

- [ ] Backend Spring Boot lancé sur le PC
- [ ] Backend accessible depuis le navigateur PC : `http://localhost:8080/api/auth/login`
- [ ] IP du PC trouvée avec `ipconfig` : `192.168.1.XX`
- [ ] IP dans `app_config.dart` correspond à l'IP trouvée
- [ ] Backend accessible depuis le navigateur téléphone : `http://192.168.1.XX:8080/api/auth/login`
- [ ] Pare-feu Windows autorise le port 8080
- [ ] PC et téléphone sur le même réseau Wi-Fi
- [ ] Backend configuré avec `server.address=0.0.0.0`

---

## 🚀 Test Final

Une fois toutes les vérifications faites :

1. **Relancez le backend** (si vous avez modifié la configuration)
2. **Relancez l'app Flutter** (Hot Restart avec `R`)
3. **Testez la connexion**
4. **Regardez les logs** dans `flutter logs`

Vous devriez voir :
```
🔵 DEBUG ApiService: Full URL: http://192.168.1.20:8080/api/auth/login
✅ DEBUG ApiService: Response status: 200
```

---

## 🐛 Si ça ne fonctionne toujours pas

1. **Vérifiez les logs du backend** pour voir si la requête arrive
2. **Testez avec Postman** depuis le PC vers `http://192.168.1.20:8080/api/auth/login`
3. **Vérifiez les logs réseau** du téléphone (si possible)
4. **Essayez avec une autre IP** (peut-être que l'IP a changé)

---

**Une fois que le serveur est accessible depuis le navigateur du téléphone, l'app devrait fonctionner !** ✅

