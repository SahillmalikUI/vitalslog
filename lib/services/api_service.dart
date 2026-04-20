import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // 🧒 This is your server address
  // When testing on Android emulator, use 10.0.2.2 instead of localhost
  // 10.0.2.2 is how Android emulator reaches your computer's localhost!
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // ═══════════════════════════════════════
  // 🔑 TOKEN MANAGEMENT
  // Save and get JWT token from phone storage
  // ═══════════════════════════════════════

  // 🧒 Save token to phone (like writing on sticky note)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // 🧒 Get token from phone (like reading the sticky note)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 🧒 Delete token (like throwing away the sticky note = logout)
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // 🧒 Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // ═══════════════════════════════════════
  // 📝 REGISTER
  // ═══════════════════════════════════════
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 🧒 This sends a POST request to your server
      // Like sending a letter to: server/api/auth/register
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json', // Tell server we're sending JSON
        },
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      // 🧒 jsonDecode converts the server's reply from text to a Map
      // Like translating a letter from another language
      final data = jsonDecode(response.body);

      // If registration successful, save the token
      if (response.statusCode == 201) {
        await saveToken(data['token']);
      }

      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection failed! Make sure server is running.',
      };
    }
  }

  // ═══════════════════════════════════════
  // 🔐 LOGIN
  // ═══════════════════════════════════════
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      // Save token if login successful
      if (response.statusCode == 200) {
        await saveToken(data['token']);
      }

      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection failed! Make sure server is running.',
      };
    }
  }

  // ═══════════════════════════════════════
  // 👤 GET USER PROFILE
  // ═══════════════════════════════════════
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection failed!'};
    }
  }

  // ═══════════════════════════════════════
  // 💾 SAVE VITALS
  // ═══════════════════════════════════════
  static Future<Map<String, dynamic>> saveVitals({
    required double heartRate,
    required double spo2,
    required double systolic,
    required double diastolic,
    required double temperature,
    String notes = '',
  }) async {
    try {
      // 🧒 Get token from phone storage
      final token = await getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/vitals'),
        headers: {
          'Content-Type': 'application/json',
          // 🧒 Send token in header — like showing wristband at door!
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'heartRate': heartRate,
          'spo2': spo2,
          'systolic': systolic,
          'diastolic': diastolic,
          'temperature': temperature,
          'notes': notes,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection failed! Make sure server is running.',
      };
    }
  }

  // ═══════════════════════════════════════
  // 📋 GET ALL VITALS
  // ═══════════════════════════════════════
  static Future<Map<String, dynamic>> getVitals() async {
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/vitals'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection failed! Make sure server is running.',
      };
    }
  }

  // ═══════════════════════════════════════
  // 🗑️ DELETE VITAL
  // ═══════════════════════════════════════
  static Future<Map<String, dynamic>> deleteVital(String id) async {
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('$baseUrl/vitals/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection failed! Make sure server is running.',
      };
    }
  }
}
