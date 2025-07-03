import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_nodejs/config.dart';
import 'package:todo_nodejs/provider/auth_provider.dart';
import 'package:todo_nodejs/screen/home.dart';
import 'package:todo_nodejs/screen/signup.dart';
import 'package:todo_nodejs/widgets/signinForm.dart';
// TODO: add flutter_svg package

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
   final _formKey = GlobalKey<FormState>();

  

 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {

      final authProvider=Provider.of<AuthProvider>(context,listen: false);

     final success = await  authProvider.LoginUser(emailController.text.trim(), passwordController.text, context);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Sign In"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Sign in with your email and password  \nor continue with social media",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  // const SizedBox(height: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFieldWidget(
                          controller: emailController,
                          hint: "Enter your email",
                          lableText: "Email",
                          icon: mailIcon,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFieldWidget(
                          controller: passwordController,
                          hint: "Enter your password",
                          lableText: "password",
                          icon: lockIcon,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Consumer<AuthProvider>(

                   builder: (context, value, child) {
                     return ElevatedButton(
                      onPressed:value.isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFFF7643),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      child:value.isLoading
                            ? CircularProgressIndicator(color: Colors.white) : const Text("Continue"),
                    );
                   },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: SvgPicture.string(googleIcon),
                        press: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SocalCard(
                          icon: SvgPicture.string(facebookIcon),
                          press: () {},
                        ),
                      ),
                      SocalCard(
                        icon: SvgPicture.string(twitterIcon),
                        press: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  NoAccountText(
                    text: 'Signup here',
                    press: () => Get.to(() => SignInScreen()),
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
