import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/login.dart';
import '/screens/home.dart';
import '/screens/register.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCS4yRzfrzbv97E60Z77_lsCZOmKY8ijzQ",
        authDomain: "fir-integration-d62d2.firebaseapp.com",
        projectId: "fir-integration-d62d2",
        storageBucket: "fir-integration-d62d2.firebasestorage.app",
        messagingSenderId: "955911309357",
        appId: "1:955911309357:web:94808d4ba78bce780090a4",
        measurementId: "G-XZJ098J0CV"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: LoginScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
