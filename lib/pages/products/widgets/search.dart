import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class searchFunction {
  Future<void> searchSuggestions(String query, List<String> suggestions) async {
    final apiUrl = 'http://192.168.0.112/api/productData.php';

    final response = await http.get(
      Uri.parse(apiUrl),
    );

    String cleanedResponse = cleanHtmlTags(response.body);

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(cleanedResponse);

        if (responseData['status'] == 'Success') {
          final List<dynamic> data = responseData['products'];

          suggestions =
              data.map((item) => item['model_no'].toString()).toList();

          print('suggetions: $suggestions');
        } else {
          print('API Error: ${responseData['remarks']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }

  String cleanHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
