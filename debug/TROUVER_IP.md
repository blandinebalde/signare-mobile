# 🔍 Comment Trouver l'IP de votre PC

## Sur Windows (votre cas)

### Méthode 1 : Via CMD/PowerShell

1. Ouvrez **PowerShell** ou **Invite de commandes**
2. Tapez :
   ```powershell
   ipconfig
   ```
3. Cherchez la section de votre connexion Wi-Fi ou Ethernet
4. Trouvez **"Adresse IPv4"** ou **"IPv4 Address"**
   - Exemple : `192.168.1.100`
   - Exemple : `192.168.0.50`

### Méthode 2 : Via les Paramètres Windows

1. Ouvrez **Paramètres** → **Réseau et Internet**
2. Cliquez sur **Wi-Fi** ou **Ethernet**
3. Cliquez sur votre connexion active
4. Faites défiler jusqu'à **"Propriétés"**
5. Cherchez **"Adresse IPv4"**

### Méthode 3 : Via PowerShell (plus rapide)

Dans PowerShell, tapez :
```powershell
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress
```

Cela affichera directement votre IP.

---

## ⚠️ Important

- Utilisez l'IP de votre **connexion Wi-Fi** (pas Ethernet si vous êtes en Wi-Fi)
- L'IP peut changer si vous vous reconnectez au Wi-Fi
- Assurez-vous que votre **PC et votre téléphone sont sur le même réseau Wi-Fi**

---

## 📝 Exemple

Si votre IP est `192.168.1.100`, modifiez `app_config.dart` comme ceci :

```dart
static const String baseUrl = 'http://192.168.1.100:8080/api';
static const String publicApiUrl = 'http://192.168.1.100:8080/api/public';
static const String imageBaseUrl = 'http://192.168.1.100:8080/api/images';
```

---

## ✅ Vérification

Une fois configuré, testez dans le navigateur de votre téléphone :
```
http://VOTRE_IP:8080/api/auth/login
```

Si vous voyez une erreur (c'est normal), cela signifie que le serveur est accessible ! ✅

