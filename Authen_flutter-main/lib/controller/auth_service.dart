import 'package:flutter/material.dart';
import 'package:flutter_lab1/variables.dart';
import 'package:flutter_lab1/models/user_model.dart';
import 'package:flutter_lab1/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_lab1/providers/user_providers.dart';

import 'package:provider/provider.dart';

class AuthService {
  Future<UserModel> login(String userName, String password) async {
    print(apiURL);

    final response = await http.post(Uri.parse("$apiURL/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_name": userName,
          "password": password,
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(
      String name, String userName, String password, String role) async {
    final response = await http.post(Uri.parse("$apiURL/api/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "user_name": userName,
          "password": password,
          "role": role,
        }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Rsgistration Successful");
    } else {
      print("Rsgistration Failed");
      print("Response body: ${response.body}");
    }
  }

  Future<void> refreshToken(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/refresh"),
      headers: {
        "Content-Type": "application/json",
        //"Authorization": "Bearer ${userProvider.RefreshToken}",
      },
      body: jsonEncode({
        "token": userProvider.RefreshToken, // ใช้ jsonEncode ที่นี่
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final accessToken = data['accessToken'];
      //final refreshToken = data['refreshToken']; // ถ้ามี refresh token ใหม่
      userProvider
          .updadateAccessToken(accessToken); // แก้ไขให้รับแค่ accessToken
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // ลบ accessToken และ refreshToken จาก SharedPreferences
    await prefs.remove('accessToken'); // ปรับให้ตรงกับ key ที่ใช้เก็บ token
    await prefs.remove('refreshToken'); // หากมีการจัดเก็บ refresh token

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await prefs.clear();
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/logout"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userProvider.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      // Logout successful
    } else {
      // Handle error
    }
  }
}
