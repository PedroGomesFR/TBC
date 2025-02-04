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
      title: 'Patient Registration / Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false; // Pour savoir si l'utilisateur est connecté
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Fonction d'inscription
  Future<void> _registerPatient() async {
    final response = await http.post(
      Uri.parse('http://your-server-address/api/patients'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // Afficher un message de succès
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Success'),
          content: Text('Patient added: ${responseBody['patient']['name']}'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  isLoggedIn = true;
                });
              },
            ),
          ],
        ),
      );
    } else {
      // Gérer l'erreur
      print('Failed to register patient');
    }
  }

  // Fonction de connexion (ici on se contente de vérifier si un patient existe)
  Future<void> _loginPatient() async {
    final response = await http.get(
      Uri.parse('http://your-server-address/api/patients'),
    );

    if (response.statusCode == 200) {
      List patients = jsonDecode(response.body);
      final existingPatient = patients.firstWhere(
        (patient) => patient['name'] == _nameController.text,
        orElse: () => null,
      );

      if (existingPatient != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Success'),
            content: Text('Welcome back, ${existingPatient['name']}'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    isLoggedIn = true;
                  });
                },
              ),
            ],
          ),
        );
      } else {
        print('Patient not found');
      }
    } else {
      print('Failed to fetch patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoggedIn ? 'Home' : 'Patient Registration / Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoggedIn
            ? Center(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home, size: 50, color: Colors.blueAccent),
                        SizedBox(height: 10),
                        Text(
                          'Bienvenue sur MyTuberculose',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerPatient();
                            }
                          },
                          child: Text('Register'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _loginPatient();
                            }
                          },
                          child: Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
