# ✅ Test de Connexion - IP Confirmée

## ✅ Votre Configuration

D'après `ipconfig`, votre configuration est **correcte** :

- **IP Wi-Fi** : `192.168.1.20` ✅
- **Configuré dans l'app** : `192.168.1.20` ✅
- **Passerelle** : `192.168.1.1`

---

## 🔍 Tests à Effectuer

### Test 1 : Vérifier que le backend est lancé

**Sur votre PC**, ouvrez dans votre navigateur :
```
http://localhost:8080/api/auth/login
```

**Résultat attendu** :
- ✅ Si vous voyez une erreur JSON (ex: `{"error":"Method not allowed"}`), c'est **BON** ! Le backend répond.
- ❌ Si vous voyez "Impossible d'accéder", le backend n'est **pas lancé**.

---

### Test 2 : Tester depuis le navigateur du téléphone

**Sur votre téléphone**, ouvrez un navigateur (Chrome, Firefox, etc.) et allez à :
```
http://192.168.1.20:8080/api/auth/login
```

**Résultats possibles** :

1. ✅ **Vous voyez une erreur JSON** (ex: `{"error":"Method not allowed"}`)
   - C'est **PARFAIT** ! Le serveur est accessible depuis le téléphone
   - Le problème vient peut-être de l'app Flutter ou du timeout
   - Passez au **Test 3**

2. ❌ **"Impossible d'accéder au site" ou "Connection refused"**
   - Le serveur n'est pas accessible depuis le téléphone
   - Vérifiez le **pare-feu Windows** (voir ci-dessous)

3. ❌ **Timeout ou "Le site ne répond pas"**
   - Le pare-feu bloque probablement la connexion
   - Vérifiez le **pare-feu Windows** (voir ci-dessous)

---

### Test 3 : Vérifier le pare-feu Windows

Le pare-feu Windows peut bloquer les connexions entrantes sur le port 8080.

**Solution rapide (pour tester)** :

1. Ouvrez **Pare-feu Windows Defender**
   - Tapez "pare-feu" dans la barre de recherche Windows
   - Ou : Panneau de configuration → Système et sécurité → Pare-feu Windows Defender

2. Cliquez sur **"Activer ou désactiver le pare-feu Windows Defender"**

3. **Désactivez temporairement** le pare-feu pour les **réseaux privés**
   - ⚠️ **Important** : Réactivez-le après les tests !

4. **Testez à nouveau** depuis le navigateur du téléphone

**Solution permanente (recommandée)** :

1. Ouvrez **Pare-feu Windows Defender avec sécurité avancée**
   - Tapez "pare-feu avancé" dans la barre de recherche

2. Cliquez sur **"Règles de trafic entrant"** → **"Nouvelle règle..."**

3. Choisissez **"Port"** → **Suivant**

4. Choisissez **"TCP"** → Entrez **8080** → **Suivant**

5. Choisissez **"Autoriser la connexion"** → **Suivant**

6. Cochez **tous les profils** (Domaine, Privé, Public) → **Suivant**

7. Donnez un nom : **"Spring Boot Port 8080"** → **Terminer**

8. **Testez à nouveau** depuis le navigateur du téléphone

---

### Test 4 : Vérifier que PC et téléphone sont sur le même réseau

**Vérifiez** :
- Les deux sont connectés au **même Wi-Fi** (nom identique)
- Le téléphone peut accéder à Internet
- L'IP du téléphone commence par `192.168.1.XXX` (même plage que le PC)

**Pour vérifier l'IP du téléphone** :
- Android : Paramètres → À propos du téléphone → Statut → Adresse IP
- Ou connectez-vous au routeur et vérifiez les appareils connectés

---

## 🎯 Checklist Complète

- [ ] Backend Spring Boot lancé sur le PC
- [ ] Backend accessible depuis le navigateur PC : `http://localhost:8080/api/auth/login`
- [ ] IP du PC confirmée : `192.168.1.20` ✅
- [ ] IP dans `app_config.dart` : `192.168.1.20` ✅
- [ ] Backend accessible depuis le navigateur téléphone : `http://192.168.1.20:8080/api/auth/login`
- [ ] Pare-feu Windows autorise le port 8080 (ou désactivé temporairement pour test)
- [ ] PC et téléphone sur le même réseau Wi-Fi
- [ ] Backend configuré avec `server.address=0.0.0.0` ✅

---

## 🚀 Si le Test 2 réussit (serveur accessible depuis le téléphone)

1. **Relancez l'app Flutter** (Hot Restart avec `R`)
2. **Testez la connexion** dans l'app
3. **Regardez les logs** dans `flutter logs`

Vous devriez voir :
```
🔵 DEBUG ApiService: Full URL: http://192.168.1.20:8080/api/auth/login
✅ DEBUG ApiService: Response status: 200
✅ DEBUG AuthService: Login réussi
```

---

## 🐛 Si le Test 2 échoue (serveur non accessible)

1. **Vérifiez le pare-feu** (voir Test 3)
2. **Vérifiez que le backend écoute sur 0.0.0.0** (déjà vérifié ✅)
3. **Vérifiez que le backend est bien lancé**
4. **Vérifiez que PC et téléphone sont sur le même réseau**

---

## 📝 Notes Importantes

- L'IP peut changer si vous vous reconnectez au Wi-Fi
- Si l'IP change, mettez à jour `app_config.dart` et relancez l'app
- Le pare-feu doit autoriser le port 8080 pour que le téléphone puisse accéder au serveur
- Le backend doit être lancé avant de tester

---

**Commencez par le Test 1, puis le Test 2. Dites-moi ce que vous obtenez !** 🔍

