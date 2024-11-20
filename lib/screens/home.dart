import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'weatherscreen.dart';
import '/services/firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, String>> _favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        final cities = await _firestoreService.getUserPreferences(userId);
        setState(() {
          _favoriteCities = cities;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load favorite cities: $e")),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to the Home Screen!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (_favoriteCities.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _favoriteCities.map((fav) {
                        return Chip(
                          label: Text(
                            "${fav['city']} - ${fav['weather']}",
                            style: TextStyle(fontSize: 14),
                          ),
                          backgroundColor: Colors.blue.shade100,
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WeatherScreen(),
                        ),
                      );
                    },
                    child: Text("View Weather Updates"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: Text("Logout"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
