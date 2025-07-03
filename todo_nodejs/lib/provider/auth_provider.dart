import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_nodejs/model/user_model.dart';
import 'package:todo_nodejs/screen/signup.dart';
import 'package:todo_nodejs/services/Api_services.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;

  Future<void> initAuth() async {
    final pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
    final userJson = pref.getString('user');
    if (_token != null && userJson != null) {
      try {
        _user = User.fromJson((jsonDecode(userJson)));
        notifyListeners();
      } catch (e) {
       // await logout(BuildContext context);
      }
    }
  }

  //register uSer
  Future<bool> resgisterUser(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await ApiServices.registerUser(
        name,
        email,
        password,
        context,
      );
      if (response['success'] == true) {
        _user = User.fromJson(response['user']);
        _token = response['token'];
        await _saveData();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Registration failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> LoginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await ApiServices.loginUser(email, password, context);
      if (response['success'] == true) {
        _user = User.fromJson(response['user']);
        _token = response['token'];
        await _saveData();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfile(String token, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await ApiServices.getProfile(token, context);
      _user = User.fromJson(data['user']);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch profile: ${e.toString()}';
      notifyListeners();
    }
  }

  //save data
  Future<void> _saveData() async {
    final pref = SharedPreferences.getInstance();

    if (_token != null && _user != null) {
      await pref.then((prefs) {
        prefs.setString('token', _token!);
        prefs.setString('user', jsonEncode(_user!.toJson()));
      });
    } else {
      await pref.then((prefs) {
        prefs.remove('token');
        prefs.remove('user');
      });
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    _user = null;
    _token = null;
    _error = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
 Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const SignInScreen()),
    (route) => false,
  );
    notifyListeners();
  }
}
