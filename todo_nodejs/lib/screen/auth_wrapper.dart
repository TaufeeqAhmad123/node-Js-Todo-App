import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nodejs/provider/auth_provider.dart';
import 'package:todo_nodejs/screen/home.dart';
import 'package:todo_nodejs/screen/login.dart';


class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      await authProvider.initAuth(); // Check if user is already logged in
    } catch (error) {
      print('Auth check error: $error');
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show a simple loading indicator while checking auth
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Use Consumer to listen to authentication changes
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}