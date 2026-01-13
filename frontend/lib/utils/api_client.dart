import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // For Flutter web, use localhost or 127.0.0.1
  // For Android emulator, use 10.0.2.2:8080
  // For iOS simulator, use localhost:8080
  // For physical device, use your computer's IP address
  static const String baseUrl = 'https://rentease-cnt1.onrender.com';
  
  // Alternative: Use 127.0.0.1 if localhost doesn't work
  // static const String baseUrl = 'http://127.0.0.1:8080';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    return headers;
  }

  static Future<Map<String, String>> _getHeadersWithAuth() async {
    final headers = _getHeaders();
    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _getHeadersWithAuth();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout: Backend server is not responding');
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Request failed with status ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to backend. Make sure the server is running on $baseUrl');
    } on FormatException catch (e) {
      throw Exception('Invalid response format from server');
    } catch (e) {
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('Failed to fetch')) {
        throw Exception('Cannot connect to backend server at $baseUrl. Please ensure:\n1. Backend is running on port 8080\n2. CORS is properly configured');
      }
      rethrow;
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = endpoint.startsWith('/api/auth')
          ? _getHeaders(includeAuth: false)
          : await _getHeadersWithAuth();
      
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout: Backend server is not responding');
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          return {};
        }
        return json.decode(responseBody);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? 'Request failed with status ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to backend. Make sure the server is running on $baseUrl');
    } on FormatException catch (e) {
      throw Exception('Invalid response format from server');
    } catch (e) {
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('Failed to fetch')) {
        throw Exception('Cannot connect to backend server at $baseUrl. Please ensure:\n1. Backend is running on port 8080\n2. CORS is properly configured');
      }
      rethrow;
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeadersWithAuth();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = response.body;
      if (responseBody.isEmpty) {
        return {};
      }
      return json.decode(responseBody);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['error'] ?? 'Request failed with status ${response.statusCode}');
    }
  }

  static Future<void> delete(String endpoint) async {
    final headers = await _getHeadersWithAuth();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['error'] ?? 'Request failed with status ${response.statusCode}');
    }
  }
}
