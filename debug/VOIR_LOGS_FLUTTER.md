# 📊 Comment Voir les Logs Flutter

## 🔍 Problème

Les logs Flutter (`debugPrint`) ne s'affichent pas toujours dans le terminal standard où vous avez lancé `flutter run`. Ils peuvent être noyés dans les logs Android système.

---

## ✅ Solutions

### Solution 1 : Utiliser `flutter logs` (Recommandé)

Dans un **nouveau terminal**, tapez :

```bash
flutter logs
```

Cela affichera **uniquement** les logs Flutter, filtrés des logs système Android.

**Astuce** : Gardez ce terminal ouvert pendant que vous testez l'app.

---

### Solution 2 : Filtrer les logs dans le terminal actuel

Dans le terminal où `flutter run` est actif, utilisez :

**Windows PowerShell** :
```powershell
flutter run | Select-String "DEBUG"
```

**Windows CMD** :
```cmd
flutter run | findstr "DEBUG"
```

**Linux/Mac** :
```bash
flutter run | grep "DEBUG"
```

---

### Solution 3 : Utiliser Android Studio Logcat

1. Ouvrez **Android Studio**
2. Allez dans **View** → **Tool Windows** → **Logcat**
3. Dans le filtre, tapez : `DEBUG` ou `flutter`
4. Les logs Flutter apparaîtront avec les emojis 🔵 ✅ 🔴

---

### Solution 4 : Utiliser VS Code

1. Dans VS Code, ouvrez le **Debug Console**
2. Les logs Flutter s'affichent automatiquement
3. Utilisez le filtre pour chercher "DEBUG"

---

## 🎯 Logs à Chercher

Quand vous cliquez sur "Se connecter", vous devriez voir :

```
🔵🔵🔵 DEBUG LoginScreen: BOUTON CLIQUÉ - FONCTION APPELÉE 🔵🔵🔵
🔵 DEBUG LoginScreen: Début de la connexion pour: [votre_username]
🔵 DEBUG AuthService: Début login pour [votre_username]
🔵 DEBUG ApiService: POST /auth/login
✅ DEBUG ApiService: Response status: 200
✅ DEBUG AuthService: Login réussi
```

---

## 🐛 Si Aucun Log N'Apparaît

1. **Vérifiez que l'app a été relancée** :
   - Appuyez sur `R` dans le terminal (Hot Restart)
   - Ou arrêtez et relancez : `flutter run`

2. **Vérifiez que le code a été sauvegardé** :
   - Les fichiers doivent être sauvegardés avant le Hot Restart

3. **Testez avec un log simple** :
   - Ajoutez `debugPrint('TEST SIMPLE');` au début de `_handleLogin`
   - Si ce log n'apparaît pas, le problème vient de l'affichage des logs

---

## 📱 Test Visuel Alternatif

Si les logs ne fonctionnent pas, nous avons ajouté un **SnackBar** qui s'affiche quand vous cliquez sur le bouton, même si la validation échoue. Cela confirme que le bouton fonctionne.

---

## 🚀 Commande Rapide

Pour voir les logs en temps réel :

```bash
# Terminal 1 : Lancer l'app
flutter run

# Terminal 2 : Voir les logs
flutter logs | Select-String "DEBUG"
```

---

**Une fois que vous voyez les logs, vous pourrez identifier exactement où le problème se situe !** 🔍

