# 💡 Exemples Flutter - Comprendre par la pratique

## 🎯 Exemple 1 : Votre première application

Créez un fichier `test_app.dart` et copiez ce code :

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
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Bonjour Flutter !',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
```

**Explication** :
- `main()` = Point d'entrée (comme en Java/C++)
- `MyApp` = Configuration de l'application
- `HomePage` = Votre première page
- `Scaffold` = Structure de base d'une page
- `AppBar` = Barre en haut
- `body` = Contenu principal

---

## 🎯 Exemple 2 : Bouton qui change le texte

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int compteur = 0;  // Variable qui change

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compteur')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Compteur: $compteur',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {  // ← Important ! Met à jour l'interface
                  compteur++;
                });
              },
              child: Text('Incrémenter'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Points clés** :
- `StatefulWidget` = Widget qui peut changer
- `setState()` = Met à jour l'interface quand on change une variable
- `$compteur` = Affiche la valeur de la variable

---

## 🎯 Exemple 3 : Liste de produits

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductListPage(),
    );
  }
}

class ProductListPage extends StatelessWidget {
  // Liste de produits (simulée)
  final List<String> produits = [
    'Produit 1',
    'Produit 2',
    'Produit 3',
    'Produit 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des Produits')),
      body: ListView.builder(
        itemCount: produits.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text(produits[index]),
              subtitle: Text('Prix: 1000 FCFA'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                print('Clic sur ${produits[index]}');
              },
            ),
          );
        },
      ),
    );
  }
}
```

**Explication** :
- `ListView.builder` = Crée une liste dynamique
- `itemCount` = Nombre d'éléments
- `itemBuilder` = Fonction qui crée chaque élément
- `Card` = Carte avec ombre
- `ListTile` = Ligne de liste avec icône, titre, sous-titre

---

## 🎯 Exemple 4 : Formulaire de connexion

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nom d\'utilisateur',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,  // Cache le mot de passe
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text;
                final password = _passwordController.text;
                print('Username: $username, Password: $password');
                // Ici, vous appelleriez votre service d'authentification
              },
              child: Text('Se connecter'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Points importants** :
- `TextEditingController` = Contrôle un champ de texte
- `obscureText: true` = Cache le texte (pour mot de passe)
- `onPressed` = Action quand on clique sur le bouton

---

## 🎯 Exemple 5 : Navigation entre pages

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page d\'accueil')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Naviguer vers une autre page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailPage()),
            );
          },
          child: Text('Aller à la page de détails'),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de détails'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Retour en arrière
          },
        ),
      ),
      body: Center(
        child: Text('Vous êtes sur la page de détails'),
      ),
    );
  }
}
```

**Navigation** :
- `Navigator.push()` = Aller vers une nouvelle page
- `Navigator.pop()` = Retourner en arrière

---

## 🎯 Exemple 6 : Appel API (HTTP)

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ApiPage(),
    );
  }
}

class ApiPage extends StatefulWidget {
  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  String? data;
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          data = jsonData['title'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        data = 'Erreur: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exemple API')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator()
            else
              Text(data ?? 'Cliquez pour charger'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Charger les données'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Points clés** :
- `async` / `await` = Programmation asynchrone
- `http.get()` = Faire une requête GET
- `json.decode()` = Convertir JSON en objet Dart
- `CircularProgressIndicator` = Indicateur de chargement

---

## 🎯 Exemple 7 : Utiliser Provider (State Management)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}

// Provider = Gère l'état
class CounterProvider extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();  // Notifie les widgets qui écoutent
  }
}

// Page qui utilise le Provider
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Consumer = Écoute les changements du Provider
            Consumer<CounterProvider>(
              builder: (context, provider, child) {
                return Text(
                  'Compteur: ${provider.count}',
                  style: TextStyle(fontSize: 30),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Accéder au Provider et appeler une méthode
                Provider.of<CounterProvider>(context, listen: false)
                    .increment();
              },
              child: Text('Incrémenter'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Provider** :
- Partage l'état entre plusieurs widgets
- `ChangeNotifier` = Classe qui peut notifier les changements
- `Consumer` = Widget qui écoute les changements
- `notifyListeners()` = Signale que quelque chose a changé

---

## 🎨 Widgets courants à connaître

### Layout Widgets

```dart
// Colonne (vertical)
Column(
  children: [
    Text('Élément 1'),
    Text('Élément 2'),
  ],
)

// Ligne (horizontal)
Row(
  children: [
    Text('Élément 1'),
    Text('Élément 2'),
  ],
)

// Conteneur avec style
Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  color: Colors.blue,
  child: Text('Contenu'),
)
```

### Widgets interactifs

```dart
// Bouton
ElevatedButton(
  onPressed: () { print('Clic'); },
  child: Text('Cliquez-moi'),
)

// Champ de texte
TextField(
  decoration: InputDecoration(labelText: 'Nom'),
)

// Image
Image.network('https://example.com/image.jpg')
```

---

## 💡 Conseils pour débuter

1. **Commencez simple** : Modifiez le code existant petit à petit
2. **Utilisez Hot Reload** : Appuyez sur `r` après chaque modification
3. **Lisez les erreurs** : Flutter donne de bons messages d'erreur
4. **Expérimentez** : Changez les couleurs, les tailles, etc.
5. **Copiez et modifiez** : Utilisez ces exemples comme base

---

## 🚀 Prochaines étapes

Une fois que vous maîtrisez ces exemples :

1. Modifiez `lib/main.dart` de votre projet
2. Regardez le code de `lib/screens/login_screen.dart`
3. Comprenez comment les Providers fonctionnent
4. Explorez les services API dans `lib/services/`

**Bon apprentissage ! 🎓**

