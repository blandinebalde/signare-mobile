# 📱 Configuration pour Téléphone Physique

## ⚠️ Important

Quand vous utilisez un **téléphone physique**, vous ne pouvez **PAS** utiliser `localhost` ou `127.0.0.1` car le téléphone ne peut pas accéder à votre PC via localhost.

Vous devez utiliser **l'adresse IP de votre PC** sur le réseau local.

---

## 🔍 Étape 1 : Trouver l'IP de votre PC

### Sur Windows :

1. Ouvrez **Invite de commandes** (CMD) ou **PowerShell**
2. Tapez :
   ```cmd
   ipconfig
   ```
3. Cherchez **"Adresse IPv4"** sous votre connexion réseau (Wi-Fi ou Ethernet)
   - Exemple : `192.168.1.100`
   - Exemple : `192.168.0.50`
   - Exemple : `10.0.0.15`

### Sur Mac :

1. Ouvrez **Terminal**
2. Tapez :
   ```bash
   ifconfig | grep "inet "
   ```
3. Cherchez l'adresse IP (généralement commence par `192.168.` ou `10.0.`)

### Sur Linux :

1. Ouvrez **Terminal**
2. Tapez :
   ```bash
   ip addr
   ```
   ou
   ```bash
   ifconfig
   ```
3. Cherchez l'adresse IP sous votre interface réseau

---

## ⚙️ Étape 2 : Configurer l'application

### Modifier `lib/config/app_config.dart` :

1. Ouvrez le fichier `lib/config/app_config.dart`
2. Remplacez `VOTRE_IP` par l'IP que vous avez trouvée

**Exemple** :
```dart
// Si votre IP est 192.168.1.100
static const String baseUrl = 'http://192.168.1.100:8080/api';
static const String publicApiUrl = 'http://192.168.1.100:8080/api/public';
static const String imageBaseUrl = 'http://192.168.1.100:8080/api/images';
```

---

## ✅ Étape 3 : Vérifier la connexion

### Vérifier que le backend est accessible :

1. **Sur votre téléphone**, ouvrez un navigateur
2. Allez à : `http://VOTRE_IP:8080/api/auth/login`
   - Exemple : `http://192.168.1.100:8080/api/auth/login`
3. Vous devriez voir une erreur (c'est normal, c'est une requête GET), mais cela confirme que le serveur est accessible

### Si ça ne fonctionne pas :

1. **Vérifiez le pare-feu Windows** :
   - Ouvrez "Pare-feu Windows Defender"
   - Autorisez le port 8080 pour les connexions entrantes
   - Ou désactivez temporairement le pare-feu pour tester

2. **Vérifiez que le PC et le téléphone sont sur le même réseau** :
   - Les deux doivent être connectés au même Wi-Fi
   - Vérifiez que le téléphone peut accéder à Internet

3. **Vérifiez que le backend écoute sur toutes les interfaces** :
   - Le backend Spring Boot doit écouter sur `0.0.0.0:8080` et non `localhost:8080`
   - Vérifiez dans `application.properties` :
     ```properties
     server.address=0.0.0.0
     server.port=8080
     ```

---

## 🔧 Configuration Backend (si nécessaire)

### Vérifier que Spring Boot écoute sur toutes les interfaces :

Dans `application.properties` ou `application.yml` :

```properties
# Écouter sur toutes les interfaces (0.0.0.0) et non seulement localhost
server.address=0.0.0.0
server.port=8080
```

Ou dans `application.yml` :
```yaml
server:
  address: 0.0.0.0
  port: 8080
```

---

## 📋 Checklist

- [ ] IP de votre PC trouvée (ex: `192.168.1.100`)
- [ ] `app_config.dart` modifié avec votre IP
- [ ] Backend Spring Boot lancé
- [ ] PC et téléphone sur le même réseau Wi-Fi
- [ ] Pare-feu autorise le port 8080
- [ ] Test dans le navigateur du téléphone : `http://VOTRE_IP:8080/api/auth/login`

---

## 🎯 Exemple Complet

Si votre IP est `192.168.1.100`, votre `app_config.dart` devrait ressembler à :

```dart
class AppConfig {
  static const String baseUrl = 'http://192.168.1.100:8080/api';
  static const String publicApiUrl = 'http://192.168.1.100:8080/api/public';
  static const String imageBaseUrl = 'http://192.168.1.100:8080/api/images';
  // ...
}
```

---

## 🐛 Problèmes Courants

### "Connection refused" ou "Failed to connect"

**Solutions** :
1. Vérifiez que le backend est lancé
2. Vérifiez que l'IP est correcte
3. Vérifiez le pare-feu
4. Vérifiez que vous êtes sur le même réseau

### "Timeout"

**Solutions** :
1. Vérifiez que le backend écoute sur `0.0.0.0:8080`
2. Vérifiez que le port 8080 n'est pas bloqué
3. Augmentez le timeout dans `app_config.dart`

### L'app ne trouve pas le serveur

**Solutions** :
1. Testez l'URL dans le navigateur du téléphone
2. Vérifiez que l'IP n'a pas changé (les IP peuvent changer si vous vous reconnectez au Wi-Fi)
3. Utilisez une IP statique ou notez votre IP

---

## 💡 Astuce

Pour éviter de changer l'IP à chaque fois, vous pouvez :
1. Configurer une **IP statique** sur votre PC
2. Ou utiliser un **service de nom de domaine local** (comme `ngrok` pour tester)

---

**Une fois configuré, relancez l'app avec `flutter run` et testez la connexion !** 🚀

