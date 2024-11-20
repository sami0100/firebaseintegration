import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/firestore.dart';

class WeatherScreen extends StatefulWidget {
  final String? prefilledCity;

  const WeatherScreen({Key? key, this.prefilledCity}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? _weatherInfo;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledCity != null) {
      _cityController.text = widget.prefilledCity!;
    }
  }

  Future<void> _fetchWeather() async {
    final apiKey = "a74f69dc0f56df8b0e7eaa2440c8b8b5"; // My OpenWeatherMap API Key
    final city = _cityController.text.trim();

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherInfo =
          "Temperature: ${data['main']['temp']}°C\nCondition: ${data['weather'][0]['description']}";
        });
      } else {
        throw Exception("Failed to fetch weather data");
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _saveFavoriteCity() async {
    final userId = _auth.currentUser?.uid;
    final city = _cityController.text.trim();

    if (userId != null && city.isNotEmpty && _weatherInfo != null) {
      await _firestoreService.saveUserPreference(userId, city, _weatherInfo!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Favorite city saved!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid city name!")),
      );
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather Updates")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Enter City Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text("Fetch Weather"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveFavoriteCity,
              child: Text("Save as Favorite"),
            ),
            SizedBox(height: 20),
            if (_weatherInfo != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _weatherInfo!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
