# 🚀 Guide Complet Flutter pour Débutants

## 📚 Qu'est-ce que Flutter ?

**Flutter** est un framework développé par Google pour créer des applications mobiles (Android et iOS) avec un seul code source. 

### Avantages de Flutter :
- ✅ **Un seul code** pour Android ET iOS
- ✅ **Performance native** (pas de WebView)
- ✅ **Interface moderne** et personnalisable
- ✅ **Développement rapide** avec Hot Reload
- ✅ **Grande communauté** et beaucoup de packages

---

## 📥 ÉTAPE 1 : Installation de Flutter

### Sur Windows

#### 1.1 Télécharger Flutter SDK

1. Allez sur : https://flutter.dev/docs/get-started/install/windows
2. Téléchargez le SDK Flutter (fichier ZIP)
3. Extrayez le ZIP dans un dossier (ex: `C:\src\flutter`)
   - ⚠️ **IMPORTANT** : Ne pas mettre dans `C:\Program Files\` (problèmes de permissions)

#### 1.2 Ajouter Flutter au PATH

1. Ouvrez **Paramètres Windows** → **Système** → **Informations système**
2. Cliquez sur **Paramètres système avancés**
3. Cliquez sur **Variables d'environnement**
4. Dans **Variables système**, trouvez `Path` et cliquez sur **Modifier**
5. Cliquez sur **Nouveau** et ajoutez le chemin vers Flutter :
   ```
   C:\src\flutter\bin
   ```
6. Cliquez sur **OK** partout

#### 1.3 Vérifier l'installation

Ouvrez un **nouveau terminal** (PowerShell ou CMD) et tapez :
```bash
flutter --version
```

Vous devriez voir la version de Flutter installée.

#### 1.4 Vérifier les prérequis

Tapez :
```bash
flutter doctor
```

Cette commande vérifie ce qui est installé et ce qui manque.

**Ce que vous devez installer :**

1. **Android Studio** (pour Android) :
   - Téléchargez : https://developer.android.com/studio
   - Installez Android Studio
   - Ouvrez Android Studio → **More Actions** → **SDK Manager**
   - Installez :
     - Android SDK
     - Android SDK Platform-Tools
     - Android Emulator
   - Acceptez les licences

2. **Visual Studio Code** (éditeur recommandé) :
   - Téléchargez : https://code.visualstudio.com/
   - Installez l'extension **Flutter** dans VS Code
   - Installez aussi l'extension **Dart**

3. **Git** (si pas déjà installé) :
   - Téléchargez : https://git-scm.com/download/win
   - Installez avec les options par défaut

#### 1.5 Accepter les licences Android

```bash
flutter doctor --android-licenses
```

Tapez `y` pour chaque licence.

#### 1.6 Vérifier à nouveau

```bash
flutter doctor
```

Tous les éléments doivent être cochés ✅ (sauf peut-être iOS si vous êtes sur Windows).

---

## 🎯 ÉTAPE 2 : Créer votre premier projet

### 2.1 Créer un nouveau projet

```bash
# Aller dans le dossier où vous voulez créer le projet
cd D:\Documents\Blandine\Blandine\malick you\gestionappwebsite\mobile

# Créer un nouveau projet Flutter
flutter create mon_premier_app

# OU utiliser le projet existant
cd gestion_stock_app
```

### 2.2 Structure d'un projet Flutter

```
mon_premier_app/
├── lib/              # ← Votre code Dart principal
│   └── main.dart     # ← Point d'entrée de l'app
├── android/          # Code Android natif
├── ios/              # Code iOS natif
├── test/             # Tests
├── pubspec.yaml      # Dépendances (comme package.json)
└── README.md
```

---

## 🚀 ÉTAPE 3 : Lancer l'application

### 3.1 Installer les dépendances

Dans le dossier du projet :
```bash
flutter pub get
```

Cette commande télécharge toutes les dépendances listées dans `pubspec.yaml`.

### 3.2 Vérifier les appareils disponibles

```bash
flutter devices
```

Vous verrez :
- **Chrome** (pour tester dans le navigateur)
- **Windows** (pour tester sur Windows desktop)
- **Android Emulator** (si vous avez créé un émulateur)
- **Votre téléphone** (si connecté via USB avec USB Debugging activé)

### 3.3 Lancer l'application

#### Option 1 : Sur un émulateur Android

1. **Créer un émulateur** :
   - Ouvrez Android Studio
   - **Tools** → **Device Manager**
   - Cliquez sur **Create Device**
   - Choisissez un appareil (ex: Pixel 5)
   - Choisissez une version Android (ex: Android 11)
   - Cliquez sur **Finish**

2. **Démarrer l'émulateur** :
   - Dans Device Manager, cliquez sur ▶️ à côté de votre émulateur

3. **Lancer l'app** :
   ```bash
   flutter run
   ```

#### Option 2 : Sur votre téléphone Android

1. **Activer le mode développeur** :
   - Allez dans **Paramètres** → **À propos du téléphone**
   - Tapez 7 fois sur **Numéro de build**

2. **Activer USB Debugging** :
   - **Paramètres** → **Options pour les développeurs**
   - Activez **Débogage USB**

3. **Connecter le téléphone** :
   - Branchez votre téléphone via USB
   - Acceptez l'autorisation sur le téléphone

4. **Lancer l'app** :
   ```bash
   flutter run
   ```

#### Option 3 : Dans le navigateur (pour tester rapidement)

```bash
flutter run -d chrome
```

---

## 🔥 Hot Reload : La magie de Flutter

Une fois l'app lancée, vous verrez dans le terminal :
```
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
q Quit (terminate the application on the device).
```

### Comment ça marche :

1. **Modifiez votre code** dans `lib/main.dart`
2. **Sauvegardez** le fichier (Ctrl+S)
3. **Appuyez sur `r`** dans le terminal
4. **L'app se met à jour instantanément** ! 🎉

**Hot Reload** = Recharge rapide sans redémarrer l'app
**Hot Restart** = Redémarre l'app (appuyez sur `R`)

---

## 📖 ÉTAPE 4 : Comment Flutter fonctionne

### 4.1 Architecture de Flutter

```
┌─────────────────────────────────┐
│     Votre Code Dart (lib/)      │
│  - Widgets, Logique métier      │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│      Flutter Framework           │
│  - Rendering Engine              │
│  - Widget System                 │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│      Dart VM / Compilation       │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│   Android / iOS Native Code     │
└─────────────────────────────────┘
```

### 4.2 Le concept de Widget

**Tout est un Widget dans Flutter !**

Un Widget = Un élément de l'interface ou un conteneur

```dart
// Exemple simple
Text('Bonjour')           // Widget texte
Icon(Icons.home)          // Widget icône
Container()                // Widget conteneur
Column()                  // Widget colonne
Row()                     // Widget ligne
Scaffold()                // Widget page complète
```

### 4.3 Structure d'un Widget

```dart
class MonWidget extends StatelessWidget {
  // Widget qui ne change pas (statique)
  
  @override
  Widget build(BuildContext context) {
    return Text('Hello World');
  }
}
```

```dart
class MonWidgetStateful extends StatefulWidget {
  // Widget qui peut changer (dynamique)
  
  @override
  State<MonWidgetStateful> createState() => _MonWidgetStatefulState();
}

class _MonWidgetStatefulState extends State<MonWidgetStateful> {
  int compteur = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Compteur: $compteur'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              compteur++;  // Met à jour l'interface
            });
          },
          child: Text('Incrémenter'),
        ),
      ],
    );
  }
}
```

### 4.4 Exemple de code complet

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());  // Démarre l'application
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon App',
      home: HomePage(),  // Page d'accueil
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ma Première App'),
      ),
      body: Center(
        child: Text('Bonjour Flutter !'),
      ),
    );
  }
}
```

---

## 🎨 ÉTAPE 5 : Concepts importants

### 5.1 MaterialApp vs CupertinoApp

- **MaterialApp** : Style Android (Material Design)
- **CupertinoApp** : Style iOS (Apple Design)

### 5.2 Scaffold

Un **Scaffold** = La structure de base d'une page

```dart
Scaffold(
  appBar: AppBar(...),      // Barre en haut
  body: ...                 // Contenu principal
  bottomNavigationBar: ...,  // Barre en bas
  drawer: ...,             // Menu latéral
)
```

### 5.3 Layout Widgets

- **Column** : Organise les widgets verticalement
- **Row** : Organise les widgets horizontalement
- **Container** : Boîte avec padding, margin, couleur
- **Stack** : Superpose les widgets
- **ListView** : Liste défilable
- **GridView** : Grille

### 5.4 State Management

Pour gérer l'état de l'application, on utilise :
- **setState()** : Pour les petits changements
- **Provider** : Pour les applications plus complexes (comme notre app)
- **Bloc** : Pour les très grandes applications

---

## 📦 ÉTAPE 6 : Gestion des dépendances

### 6.1 Le fichier pubspec.yaml

C'est comme le `package.json` de Node.js :

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0        # Package HTTP
  provider: ^6.1.1   # Gestion d'état
```

### 6.2 Installer un package

1. Allez sur : https://pub.dev
2. Cherchez un package (ex: `http`)
3. Copiez la ligne dans `pubspec.yaml`
4. Exécutez :
   ```bash
   flutter pub get
   ```

### 6.3 Utiliser un package

```dart
import 'package:http/http.dart' as http;

// Utiliser le package
var response = await http.get(Uri.parse('https://api.example.com'));
```

---

## 🔧 ÉTAPE 7 : Commandes Flutter essentielles

```bash
# Vérifier l'installation
flutter doctor

# Créer un projet
flutter create nom_du_projet

# Installer les dépendances
flutter pub get

# Lancer l'app
flutter run

# Lancer sur un appareil spécifique
flutter run -d chrome
flutter run -d android
flutter run -d windows

# Construire une APK (Android)
flutter build apk

# Construire une APP (iOS)
flutter build ios

# Nettoyer le projet
flutter clean

# Mettre à jour Flutter
flutter upgrade

# Voir les appareils disponibles
flutter devices
```

---

## 🐛 ÉTAPE 8 : Dépannage courant

### Problème : "flutter: command not found"
**Solution** : Flutter n'est pas dans le PATH. Vérifiez l'étape 1.2.

### Problème : "No devices found"
**Solution** :
- Vérifiez que l'émulateur est démarré
- Ou connectez un téléphone avec USB Debugging activé
- Ou utilisez `flutter run -d chrome`

### Problème : "Gradle build failed"
**Solution** :
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problème : L'app ne se met pas à jour
**Solution** :
- Appuyez sur `R` pour Hot Restart
- Ou arrêtez (`q`) et relancez (`flutter run`)

### Problème : Erreurs de dépendances
**Solution** :
```bash
flutter clean
flutter pub get
```

---

## 📚 Ressources pour apprendre

1. **Documentation officielle** : https://flutter.dev/docs
2. **Codelabs Flutter** : https://flutter.dev/docs/codelabs
3. **YouTube** : Recherchez "Flutter tutorial"
4. **Pub.dev** : Packages Flutter : https://pub.dev

---

## ✅ Checklist de démarrage

- [ ] Flutter installé (`flutter --version`)
- [ ] Android Studio installé
- [ ] VS Code avec extensions Flutter et Dart
- [ ] Émulateur Android créé et démarré
- [ ] `flutter doctor` montre tout en vert ✅
- [ ] Premier projet créé
- [ ] `flutter pub get` exécuté
- [ ] `flutter run` fonctionne
- [ ] Hot Reload testé (appuyez sur `r`)

---

## 🎯 Prochaines étapes

Une fois que vous maîtrisez les bases :

1. **Apprendre les widgets de base** : Text, Container, Column, Row
2. **Navigation** : Navigator.push() pour changer de page
3. **State Management** : Provider pour gérer l'état
4. **HTTP Requests** : Communiquer avec une API
5. **Formulaires** : TextField, validation
6. **Listes** : ListView, GridView
7. **Animations** : AnimatedContainer, etc.

---

## 💡 Astuces

- **Utilisez Hot Reload** : C'est votre meilleur ami !
- **Lisez les erreurs** : Flutter donne de bons messages d'erreur
- **Utilisez VS Code** : Meilleur éditeur pour Flutter
- **Testez souvent** : Sur différents appareils
- **Documentation** : Toujours à portée de main (Ctrl+Click sur un widget)

---

**Bon courage avec Flutter ! 🚀**

