import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;

final connect = GetConnect();

Future<void> userSignup(String name, String username, String email,
    String phone, String password, String role) async {
  try {
    var result = await http.post(
      Uri.parse('${Constants.localhost}/reg.php'),
      headers: {'content-type': 'application/x-www-form-urlencoded'},
      body: {
        'name': name,
        'user_name': username,
        'email_id': email,
        'phone_number': phone,
        'password': password,
        'role': role
      },
    );
    if (result.statusCode == 200) {
      final data = json.decode(result.body);
      if (data['status'] == 'success') {
        final msg = data['message'];
        print('sucess : ${data['message']}');
        _showtoast(msg, Colors.green);
      } else {
        final msg = data['message'];
        _showtoast(msg, Colors.red);
      }
      print(data);
    } else {
      final data = json.decode(result.body);
      final msg = data['message'];
      print('object');
      _showtoast(msg, Colors.red);
    }
  } catch (e) {
    print('error: $e');
  }
}

void _showtoast(String message, Color color) {
  showToast(
    message,
    position: ToastPosition.bottom,
    backgroundColor: color,
    radius: 13.0,
    textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
    // animationBuilder: const Miui10AnimBuilder().call,
  );
}

Future userLogin(String email, String password) async {
  try {
    var result = await connect.post(
      '${Constants.localhost}/login',
      {
        'email': email,
        'password': password,
      },
    );
    return result.body;
  } catch (e) {
    return e.toString();
  }
}
