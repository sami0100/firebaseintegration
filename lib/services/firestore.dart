import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a user's favorite city along with its weather information
  Future<void> saveUserPreference(String userId, String city, String weather) async {
    try {
      await _firestore.collection('users').doc(userId).collection('favorites').add({
        'city': city,
        'weather': weather,
      });
    } catch (e) {
      throw Exception("Failed to save user preference: $e");
    }
  }

  /// Retrieve all favorite cities and their weather information for a user
  Future<List<Map<String, String>>> getUserPreferences(String userId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).collection('favorites').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'city': data['city'] as String? ?? '',
          'weather': data['weather'] as String? ?? '',
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to retrieve user preferences: $e");
    }
  }
}