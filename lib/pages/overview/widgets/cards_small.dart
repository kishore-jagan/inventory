import 'dart:convert';
// import 'dart:html';

import 'package:admin_dashboard/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/customers_controller.dart';
import '../../../controllers/products_controller.dart';
import '../../../models/product.dart';
import 'info_card_small.dart';
import 'package:http/http.dart' as http;

class OverviewCardsSmallScreen extends StatefulWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  State<OverviewCardsSmallScreen> createState() =>
      _OverviewCardsSmallScreenState();
}

class _OverviewCardsSmallScreenState extends State<OverviewCardsSmallScreen> {
  final CustomersController customersController =
      Get.put(CustomersController());
  String? totalCount;

  final ProductsController productsController = Get.put(ProductsController());

  @override
  void initState() async {
    super.initState();
    productsController.fetchProducts();
    customersController.fetchCustomers();
    await GetValueProduct();
  }

  Future<void> GetValueProduct() async {
    final url = "http://192.168.0.112/api/total_product.php";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      final String no1 = data['table1_total_rows'];
      final String no2 = data['table2_total_rows'];
      setState(() {
        totalCount = (int.parse(no1) + int.parse(no2)).toString();
      });
      print("get Started");
      print(totalCount);
      print("end");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // int calculateTotalStock(List<Product> stock) {
    //   int totalStock = 0;
    //   for (int i = 0; i < productsController.products.length; i++) {
    //     totalStock += productsController.products[i].qty!;
    //   }
    //   return totalStock;
    // }

    // int calculateTotalValue(List<Product> stock) {
    //   int totalValue = 0;
    //   for (int i = 0; i < productsController.products.length; i++) {
    //     totalValue += productsController.products[i].stock! *
    //         productsController.products[i].price!;
    //   }
    //   return totalValue;
    // }

    return SizedBox(
      height: 400,
      child: Obx(
        () => Column(
          children: [
            InfoCardSmall(
              title: Constants.totalStock,
              value: totalCount ?? '0',
              onTap: () {},
              isActive: true,
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.valueOfStock,
              value: totalCount ?? '0',
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.productsCount,
              value: totalCount ?? '0',
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.customerCount,
              value: totalCount ?? '0',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
