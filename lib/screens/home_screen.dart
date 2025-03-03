import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;
  String? _displayName;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '527609679972-p3v0sbpnr7n788s6u2gu8ma1m6mmev3b.apps.googleusercontent.com',
  );

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("L'utilisateur a annulé la connexion");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Connexion réussie : ${userCredential.user?.displayName}");
      return userCredential.user;
    } catch (e) {
      print("Erreur lors de la connexion avec Google : $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    setState(() {
      _currentUser = null;
      _displayName = null;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
        _displayName = user?.displayName;
      });
    });
  }

  void updateDisplayName(String newDisplayName) {
    print(
        "Mise à jour du nom affiché : $newDisplayName"); // Ajoutez cette ligne
    setState(() {
      _displayName = newDisplayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      drawer: _buildDrawer(),
      body: _buildHomeContent(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_displayName ?? 'Utilisateur'),
            accountEmail: Text(_currentUser?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: _currentUser?.photoURL != null
                  ? NetworkImage(_currentUser!.photoURL!)
                  : null,
              child: _currentUser?.photoURL == null
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Modifier mes informations'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                        userId: _currentUser?.uid,
                        onDisplayNameUpdated: updateDisplayName)),
              );
            },
          ),
          ListTile(
            leading:
                Icon(_currentUser == null ? Icons.login : Icons.exit_to_app),
            title: Text(_currentUser == null ? 'Connexion' : 'Déconnexion'),
            onTap: _currentUser == null ? signInWithGoogle : signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bienvenue, $_displayName',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(Icons.medical_services, color: Colors.blue),
              title: Text('Vos médicaments à prendre aujourd’hui'),
              subtitle: Text('Aucun médicament prévu'),
            ),
          ),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.green),
              title: Text('Prochains rendez-vous'),
              subtitle: Text('Aucun rendez-vous prévu'),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String? userId;
  final Function(String) onDisplayNameUpdated;

  EditProfileScreen({this.userId, required this.onDisplayNameUpdated});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _selectedDepartment;

  final List<String> _departments = [
    'Ain',
    'Aisne',
    'Allier',
    'Alpes-de-Haute-Provence',
    'Hautes-Alpes',
    'Alpes-Maritimes',
    'Ardèche',
    'Ardennes',
    'Ariège',
    'Aube',
    'Aude',
    'Aveyron',
    'Bouches-du-Rhône',
    'Calvados',
    'Cantal',
    'Charente',
    'Charente-Maritime',
    'Cher',
    'Corrèze',
    'Corse-du-Sud',
    'Haute-Corse',
    'Côte-d\'Or',
    'Côtes-d\'Armor',
    'Creuse',
    'Dordogne',
    'Doubs',
    'Drôme',
    'Eure',
    'Eure-et-Loir',
    'Finistère',
    'Gard',
    'Haute-Garonne',
    'Gers',
    'Gironde',
    'Hérault',
    'Ille-et-Vilaine',
    'Indre',
    'Indre-et-Loire',
    'Isère',
    'Jura',
    'Landes',
    'Loir-et-Cher',
    'Loire',
    'Haute-Loire',
    'Loire-Atlantique',
    'Loiret',
    'Lot',
    'Lot-et-Garonne',
    'Lozère',
    'Maine-et-Loire',
    'Manche',
    'Marne',
    'Haute-Marne',
    'Mayenne',
    'Meurthe-et-Moselle',
    'Meuse',
    'Morbihan',
    'Moselle',
    'Nièvre',
    'Nord',
    'Oise',
    'Orne',
    'Pas-de-Calais',
    'Puy-de-Dôme',
    'Pyrénées-Atlantiques',
    'Hautes-Pyrénées',
    'Pyrénées-Orientales',
    'Bas-Rhin',
    'Haut-Rhin',
    'Rhône',
    'Haute-Saône',
    'Saône-et-Loire',
    'Sarthe',
    'Savoie',
    'Haute-Savoie',
    'Paris',
    'Seine-Maritime',
    'Seine-et-Marne',
    'Yvelines',
    'Deux-Sèvres',
    'Somme',
    'Tarn',
    'Tarn-et-Garonne',
    'Var',
    'Vaucluse',
    'Vendée',
    'Vienne',
    'Haute-Vienne',
    'Vosges',
    'Yonne',
    'Territoire de Belfort',
    'Essonne',
    'Hauts-de-Seine',
    'Seine-Saint-Denis',
    'Val-de-Marne',
    'Val-d\'Oise'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _birthdateController.text = data['birthdate'] ?? '';
        _weightController.text = data['weight'] ?? '';
        _heightController.text = data['height'] ?? '';
        _selectedDepartment = data['department'] ?? '';
      }
    }
  }

  Future<void> _updateUserData() async {
    if (widget.userId != null) {
      print(
          "Mise à jour des données utilisateur dans Firestore"); // Ajoutez cette ligne
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'birthdate': _birthdateController.text,
        'weight': _weightController.text,
        'height': _heightController.text,
        'department': _selectedDepartment,
      }, SetOptions(merge: true));

      print("Données mises à jour avec succès"); // Ajoutez cette ligne

      // Update the display name in the drawer
      widget.onDisplayNameUpdated(
          '${_firstNameController.text} ${_lastNameController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier mes informations')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _birthdateController,
              decoration: InputDecoration(labelText: 'Date de naissance'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    _birthdateController.text = formattedDate;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Poids (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Taille (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Département'),
              value: _selectedDepartment,
              items: _departments.map((department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(
                    "Bouton Enregistrer pressé"); // Ajoutez cette ligne pour vérifier
                _updateUserData();
              },
              child: Text('Enregistrer'),
            )
          ],
        ),
      ),
    );
  }
}
