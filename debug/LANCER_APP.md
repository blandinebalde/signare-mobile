# 🚀 Comment Lancer l'Application

## ✅ Votre Configuration

Vous avez maintenant **4 appareils disponibles** :

1. ✅ **Émulateur Android** (`emulator-5554`) - Android 15
2. ✅ **Windows Desktop** (`windows`)
3. ✅ **Chrome** (`chrome`)
4. ✅ **Edge** (`edge`)

---

## 🎯 Option 1 : Lancer sur l'Émulateur Android (Recommandé)

C'est la meilleure option pour tester une application mobile !

```bash
flutter run -d emulator-5554
```

Ou simplement :
```bash
flutter run
```
(Flutter choisira automatiquement l'émulateur Android)

**⚠️ Important** : Assurez-vous que votre backend Spring Boot est lancé sur `http://localhost:8080`

**Configuration API pour émulateur** :
- Dans `lib/config/app_config.dart`, utilisez : `http://10.0.2.2:8080/api`
- `10.0.2.2` est l'adresse spéciale pour accéder à `localhost` depuis l'émulateur Android

---

## 🖥️ Option 2 : Lancer sur Windows Desktop

Pour tester rapidement sans émulateur :

```bash
flutter run -d windows
```

**Configuration API pour Windows** :
- Dans `lib/config/app_config.dart`, utilisez : `http://localhost:8080/api`

---

## 🌐 Option 3 : Lancer dans Chrome

Pour tester dans le navigateur :

```bash
flutter run -d chrome
```

**Configuration API pour Chrome** :
- Dans `lib/config/app_config.dart`, utilisez : `http://localhost:8080/api`

---

## ⚙️ Configuration de l'API

Avant de lancer, configurez l'URL de votre backend dans `lib/config/app_config.dart` :

### Pour Émulateur Android :
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

### Pour Windows/Chrome :
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

### Pour Téléphone Physique :
```dart
static const String baseUrl = 'http://192.168.1.XXX:8080/api';
```
(Remplacez XXX par l'IP de votre PC - trouvez-la avec `ipconfig`)

---

## 🔥 Commandes Utiles Pendant l'Exécution

Une fois l'app lancée, vous verrez dans le terminal :

```
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
q Quit (terminate the application on the device).
```

- **Appuyez sur `r`** = Recharge rapide (après modification du code)
- **Appuyez sur `R`** = Redémarre complètement l'app
- **Appuyez sur `q`** = Quitte l'application

---

## 📱 Première Lancement

La première fois que vous lancez l'app, Flutter va :

1. **Compiler** l'application (peut prendre 2-5 minutes)
2. **Installer** sur l'émulateur
3. **Lancer** l'application

**Soyez patient la première fois !** Les lancements suivants seront beaucoup plus rapides.

---

## 🐛 Problèmes Courants

### L'app ne se connecte pas au backend

1. Vérifiez que le backend Spring Boot est lancé
2. Vérifiez l'URL dans `app_config.dart`
3. Pour l'émulateur, utilisez `10.0.2.2` au lieu de `localhost`

### L'émulateur est lent

- Fermez d'autres applications
- Augmentez la RAM allouée à l'émulateur dans Android Studio
- Utilisez Windows Desktop à la place : `flutter run -d windows`

### Erreur "No devices found"

- Vérifiez que l'émulateur est démarré
- Ou utilisez : `flutter run -d windows` ou `flutter run -d chrome`

---

## ✅ Checklist Avant de Lancer

- [ ] Backend Spring Boot lancé sur le port 8080
- [ ] URL API configurée dans `app_config.dart`
- [ ] Émulateur Android démarré (si vous utilisez l'émulateur)
- [ ] Dépendances installées (`flutter pub get` déjà fait ✅)

---

## 🎯 Commande Rapide

Pour lancer sur l'émulateur Android (recommandé) :

```bash
flutter run
```

C'est tout ! 🚀

