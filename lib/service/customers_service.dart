import 'dart:convert';

import 'package:get/get.dart';
import '../constants/constants.dart';
import '../models/customer.dart';
import 'package:http/http.dart' as http;

class CustomerService extends GetConnect {
  Future<List<Customer>> fetchCustomers() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.112/api/user_data2.php'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> customers = json.decode(response.body);
      final List data = customers['users'];
      print('data: $customers');
      return data.map((data) => Customer.fromJson(data)).toList();
    } else {
      return Future.error(response.statusCode.toString());
    }
  }
}

// Model
  

// Se