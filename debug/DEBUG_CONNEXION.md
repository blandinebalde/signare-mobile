# 🐛 Guide de Débogage - Problème de Connexion

## ✅ Modifications Apportées

J'ai ajouté des **logs de débogage** partout dans le code pour identifier le problème.

### Logs Ajoutés

1. **Dans LoginScreen** :
   - Log quand le bouton est cliqué
   - Log de la validation
   - Log du résultat de la connexion
   - Log des exceptions

2. **Dans AuthService** :
   - Log de l'URL utilisée
   - Log de la requête envoyée
   - Log de la réponse reçue
   - Log du format de données

3. **Dans ApiService** :
   - Log de la requête HTTP
   - Log des erreurs DioException
   - Log des codes de statut

---

## 🔍 Comment Déboguer

### Étape 1 : Vérifier les Logs

Lancez l'application et regardez la console :

```bash
flutter run
```

Puis dans le terminal, vous verrez tous les logs avec le préfixe `DEBUG:`.

### Étape 2 : Tester la Connexion

1. Entrez un nom d'utilisateur et un mot de passe
2. Cliquez sur "Se connecter"
3. Regardez les logs dans le terminal

### Étape 3 : Analyser les Logs

Cherchez ces messages dans l'ordre :

1. `DEBUG: Début de la connexion pour: [username]`
   - Si vous ne voyez pas ce message → Le bouton ne fonctionne pas

2. `DEBUG: Appel de authProvider.login()`
   - Si vous ne voyez pas ce message → Problème avec le Provider

3. `DEBUG AuthService: Envoi requête POST à /auth/login`
   - Si vous ne voyez pas ce message → Problème avant l'envoi

4. `DEBUG ApiService: POST /auth/login`
   - Si vous ne voyez pas ce message → Problème avec ApiService

5. `DEBUG ApiService: Response status: [code]`
   - Code 200 = Succès
   - Code 401 = Identifiants incorrects
   - Code 404 = URL incorrecte
   - Code 500 = Erreur serveur
   - Pas de réponse = Problème réseau

---

## 🔧 Problèmes Courants et Solutions

### Problème 1 : "Rien ne se passe" - Pas de logs

**Cause** : Le bouton ne déclenche pas la fonction

**Solution** :
- Vérifiez que le formulaire est valide
- Vérifiez que `_isLoading` n'est pas déjà `true`
- Vérifiez la console pour les erreurs

### Problème 2 : Logs jusqu'à "Envoi requête" mais pas de réponse

**Cause** : Problème réseau ou serveur non démarré

**Solution** :
- Vérifiez que le backend est lancé : `http://localhost:8080`
- Vérifiez l'URL dans `app_config.dart`
- Pour émulateur : utilisez `10.0.2.2` au lieu de `localhost`

### Problème 3 : Erreur "Connection refused" ou "Failed host lookup"

**Cause** : Impossible de se connecter au serveur

**Solution** :
1. Vérifiez que le backend Spring Boot est lancé
2. Vérifiez l'URL dans `app_config.dart` :
   - Émulateur Android : `http://10.0.2.2:8080/api`
   - Windows/Chrome : `http://localhost:8080/api`
3. Testez l'URL dans un navigateur : `http://localhost:8080/api/auth/login`

### Problème 4 : Code 404 - "Service non trouvé"

**Cause** : L'endpoint n'existe pas ou l'URL est incorrecte

**Solution** :
- Vérifiez que l'endpoint est `/auth/login` (pas `/api/auth/login` car `/api` est déjà dans `baseUrl`)
- Vérifiez que le backend expose bien `/api/auth/login`

### Problème 5 : Code 401 - "Non autorisé"

**Cause** : Identifiants incorrects

**Solution** :
- Vérifiez le nom d'utilisateur et le mot de passe
- Vérifiez que l'utilisateur existe dans la base de données

### Problème 6 : Code 500 - "Erreur serveur"

**Cause** : Erreur côté serveur

**Solution** :
- Regardez les logs du backend Spring Boot
- Vérifiez la base de données
- Vérifiez la configuration du backend

---

## 📋 Checklist de Vérification

Avant de tester, vérifiez :

- [ ] Backend Spring Boot lancé sur le port 8080
- [ ] URL correcte dans `app_config.dart`
- [ ] Endpoint `/auth/login` existe dans le backend
- [ ] Utilisateur de test existe dans la base de données
- [ ] Pas d'erreurs dans la console Flutter
- [ ] Pas d'erreurs dans les logs du backend

---

## 🎯 Test Rapide

Pour tester rapidement si le backend répond :

1. **Dans un navigateur** (si vous êtes sur Windows/Chrome) :
   ```
   http://localhost:8080/api/auth/login
   ```
   Vous devriez voir une erreur (c'est normal, c'est une requête GET), mais cela confirme que le serveur répond.

2. **Avec curl** (si installé) :
   ```bash
   curl -X POST http://localhost:8080/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"username":"test","password":"test"}'
   ```

---

## 📝 Format de Réponse Attendu

Le backend devrait retourner :

```json
{
  "success": true,
  "message": "Connexion réussie",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    ...
  },
  "role": "ADMIN"
}
```

---

## 🚀 Prochaines Étapes

1. **Lancez l'app** avec `flutter run`
2. **Regardez les logs** dans le terminal
3. **Testez la connexion**
4. **Copiez les logs** et partagez-les pour analyse

Les logs vous diront exactement où le problème se situe !

---

**Note** : Une fois le problème résolu, vous pouvez retirer les logs `DEBUG:` pour nettoyer le code.

