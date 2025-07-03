import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo_nodejs/config.dart';
import 'package:todo_nodejs/provider/auth_provider.dart';

class ApiServices {
  
  static Future<Map<String, dynamic>> registerUser(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    var resBody = {"name": name, "email": email, "password": password};

    final response = await http
        .post(
          Uri.parse(registerationUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(resBody),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print("Error: ${response.body}");
      return {
        'success': false,
        'message': 'Something went wrong: ${response.statusCode}',
      };
    }
  }
  //Login User

  static Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    var resBody = {"email": email, "password": password};

    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(resBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonReresponse = jsonDecode(response.body);
     
    }
    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
    }
    return jsonDecode(response.body);
  }
  static Future<Map<String, dynamic>> getProfile(
 String token,
    BuildContext context,
  ) async {
    
    final response = await http.get(
      Uri.parse(profileUrl),
      headers: {"Content-Type": "application/json"},
     
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonReresponse = jsonDecode(response.body);
    
    }
    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
    }
    return jsonDecode(response.body);
  }



   static Future<Map<String, dynamic>> addData(
    String title,
    String desc,
   
    BuildContext context,
  ) async {
    final provider=Provider.of<AuthProvider>(context,listen: false);
    var resBody = {"title": title, "desc": desc, "userId": provider.user!.id};
    print(provider.user!.id);

    final response = await http
        .post(
          Uri.parse(addDATAUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(resBody),
        )
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print("Error: ${response.body}");
      return {
        'success': false,
        'message': 'Something went wrong: ${response.statusCode}',
      };
    }
  }
//Get user Todo data

static Future<Map<String, dynamic>> getUserTodoData(
 String userId,
    BuildContext context,
  ) async {
    
    final response = await http.get(
      Uri.parse('$getTODODATAUrl?userId=$userId'),
      headers: {"Content-Type": "application/json"},
     
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonReresponse = jsonDecode(response.body);
    
    }
    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
    }
    return jsonDecode(response.body);
  }


}
