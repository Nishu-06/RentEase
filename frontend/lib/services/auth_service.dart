import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/api_client.dart';

class AuthService extends ChangeNotifier {
  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    if (token != null) {
      _token = token;
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiClient.post('/api/auth/login', {
        'email': email,
        'password': password,
      });

      if (response['token'] != null) {
        _token = response['token'];
        _user = User(
          id: response['userId'],
          name: response['name'],
          email: response['email'],
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid response from server';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiClient.post('/api/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response['token'] != null) {
        _token = response['token'];
        _user = User(
          id: response['userId'],
          name: response['name'],
          email: response['email'],
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid response from server';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    notifyListeners();
  }
}
