import 'dart:convert';

import 'package:admin_dashboard/constants/constants.dart';
import 'package:admin_dashboard/service/products_service.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  List<String> Data = [];

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await ProductsService().fetchProducts();
      if (products.isNotEmpty) {
        this.products.assignAll(products);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
