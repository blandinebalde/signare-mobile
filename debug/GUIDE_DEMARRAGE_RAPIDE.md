# ⚡ Guide de Démarrage Rapide - Gestion Stock App

## 🎯 Pour les débutants absolus

### Étape 1 : Installer Flutter (15-30 minutes)

#### Windows :

1. **Télécharger Flutter** :
   - Allez sur : https://flutter.dev/docs/get-started/install/windows
   - Téléchargez le SDK Flutter
   - Extrayez dans `C:\src\flutter` (ou un autre dossier)

2. **Ajouter au PATH** :
   - Windows → Rechercher "Variables d'environnement"
   - Cliquez sur "Variables d'environnement"
   - Dans "Variables système", trouvez "Path" → "Modifier"
   - Ajoutez : `C:\src\flutter\bin`
   - Cliquez OK partout

3. **Vérifier** :
   - Ouvrez un **nouveau** PowerShell ou CMD
   - Tapez : `flutter --version`
   - Vous devriez voir la version

#### Installer Android Studio :

1. Téléchargez : https://developer.android.com/studio
2. Installez avec les options par défaut
3. Ouvrez Android Studio
4. **More Actions** → **SDK Manager**
5. Cochez :
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Emulator
6. Cliquez "Apply" et attendez

#### Installer VS Code :

1. Téléchargez : https://code.visualstudio.com/
2. Installez
3. Ouvrez VS Code
4. Extensions (Ctrl+Shift+X) → Cherchez "Flutter" → Installez
5. Installez aussi l'extension "Dart"

#### Vérifier tout :

```bash
flutter doctor
```

Résolvez tous les problèmes affichés (généralement accepter les licences) :
```bash
flutter doctor --android-licenses
```
Tapez `y` pour chaque licence.

---

### Étape 2 : Préparer le projet (5 minutes)

```bash
# Aller dans le dossier du projet
cd "D:\Documents\Blandine\Blandine\malick you\gestionappwebsite\mobile\gestion_stock_app"

# Installer les dépendances
flutter pub get
```

---

### Étape 3 : Créer un émulateur Android (10 minutes)

1. Ouvrez **Android Studio**
2. **Tools** → **Device Manager**
3. Cliquez sur **Create Device**
4. Choisissez un appareil (ex: **Pixel 5**)
5. Cliquez **Next**
6. Choisissez une version Android (ex: **Android 11** ou **API 30**)
7. Si pas téléchargé, cliquez **Download** et attendez
8. Cliquez **Next** → **Finish**
9. Dans Device Manager, cliquez sur ▶️ pour démarrer l'émulateur

**Attendez que l'émulateur démarre complètement** (peut prendre 2-3 minutes la première fois)

---

### Étape 4 : Configurer l'API (2 minutes)

Ouvrez le fichier : `lib/config/app_config.dart`

Modifiez la ligne :
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

**Explications** :
- `10.0.2.2` = Adresse pour accéder à localhost depuis l'émulateur Android
- `8080` = Port de votre backend Spring Boot
- Si votre backend est sur une autre machine, utilisez son IP : `http://192.168.1.100:8080/api`

---

### Étape 5 : Lancer l'application (1 minute)

```bash
# Dans le dossier du projet
flutter run
```

**Flutter va** :
1. Compiler l'application
2. L'installer sur l'émulateur
3. La lancer

**La première fois, ça peut prendre 2-5 minutes !**

---

### Étape 6 : Utiliser l'application

Une fois lancée, vous verrez dans le terminal :
```
Flutter run key commands.
r Hot reload. 🔥🔥🔥
```

**Commandes utiles** :
- Appuyez sur `r` = Recharge rapide (après modification du code)
- Appuyez sur `R` = Redémarre complètement
- Appuyez sur `q` = Quitte l'application

---

## 🔥 Hot Reload - Votre meilleur ami

1. **Modifiez** le fichier `lib/main.dart`
2. **Changez** quelque chose (ex: le texte "Gestion Stock")
3. **Sauvegardez** (Ctrl+S)
4. **Appuyez sur `r`** dans le terminal
5. **L'app se met à jour instantanément !** 🎉

---

## 🐛 Problèmes courants

### "flutter: command not found"
→ Flutter n'est pas dans le PATH. Vérifiez l'étape 1.

### "No devices found"
→ Démarrer l'émulateur Android Studio d'abord

### "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### L'app ne se connecte pas au backend
→ Vérifiez que :
1. Le backend Spring Boot est lancé
2. L'URL dans `app_config.dart` est correcte
3. Pour émulateur : utilisez `10.0.2.2`
4. Pour téléphone physique : utilisez l'IP de votre PC

---

## 📱 Tester sur votre téléphone Android

1. **Activer le mode développeur** :
   - Paramètres → À propos du téléphone
   - Tapez 7 fois sur "Numéro de build"

2. **Activer USB Debugging** :
   - Paramètres → Options pour les développeurs
   - Activez "Débogage USB"

3. **Connecter** :
   - Branchez le téléphone via USB
   - Acceptez l'autorisation sur le téléphone

4. **Lancer** :
   ```bash
   flutter run
   ```

5. **Changer l'URL** :
   - Dans `app_config.dart`, utilisez l'IP de votre PC (ex: `http://192.168.1.100:8080/api`)
   - Trouvez votre IP : `ipconfig` dans CMD

---

## ✅ Checklist

- [ ] Flutter installé (`flutter --version` fonctionne)
- [ ] Android Studio installé
- [ ] VS Code avec extensions Flutter et Dart
- [ ] Émulateur Android créé et démarré
- [ ] `flutter doctor` montre tout OK
- [ ] `flutter pub get` exécuté
- [ ] URL API configurée dans `app_config.dart`
- [ ] Backend Spring Boot lancé
- [ ] `flutter run` fonctionne
- [ ] L'app s'affiche sur l'émulateur

---

## 🎓 Commandes essentielles à retenir

```bash
flutter doctor          # Vérifier l'installation
flutter pub get         # Installer les dépendances
flutter run             # Lancer l'app
flutter clean            # Nettoyer le projet
flutter devices          # Voir les appareils disponibles
```

---

## 📚 Besoin d'aide ?

1. **Documentation Flutter** : https://flutter.dev/docs
2. **Erreurs** : Lisez le message d'erreur, Flutter est très clair
3. **Stack Overflow** : Beaucoup de solutions
4. **GitHub Issues** : Pour les bugs

**Bon développement ! 🚀**

