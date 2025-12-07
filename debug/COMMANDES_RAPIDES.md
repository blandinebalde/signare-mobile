# ⚡ Commandes Rapides - Gestion Stock App

## 🚀 Lancer l'Application

### Sur l'émulateur Android (Recommandé) :
```bash
flutter run
```
ou
```bash
flutter run -d emulator-5554
```

### Sur Windows Desktop :
```bash
flutter run -d windows
```

### Dans Chrome :
```bash
flutter run -d chrome
```

---

## 🔥 Pendant l'Exécution

Une fois l'app lancée, dans le terminal :

- **`r`** = Hot Reload (recharge rapide)
- **`R`** = Hot Restart (redémarre complètement)
- **`q`** = Quitter l'application

---

## 📦 Gestion des Dépendances

```bash
flutter pub get          # Installer les dépendances
flutter pub upgrade      # Mettre à jour les dépendances
flutter clean           # Nettoyer le projet
```

---

## 🔍 Vérifications

```bash
flutter doctor          # Vérifier l'installation
flutter devices         # Voir les appareils disponibles
flutter emulators       # Voir les émulateurs disponibles
```

---

## 🐛 Dépannage

```bash
flutter clean           # Nettoyer
flutter pub get         # Réinstaller les dépendances
flutter run             # Relancer
```

---

## ⚙️ Configuration API

**Pour Émulateur Android** : `http://10.0.2.2:8080/api`
**Pour Windows/Chrome** : `http://localhost:8080/api`

Modifiez dans : `lib/config/app_config.dart`

---

## ✅ Checklist Avant de Lancer

- [ ] Backend Spring Boot lancé (port 8080)
- [ ] URL API configurée dans `app_config.dart`
- [ ] Émulateur démarré (si vous utilisez l'émulateur)
- [ ] `flutter pub get` exécuté ✅

---

**Commande la plus simple** : `flutter run` 🚀

