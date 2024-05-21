import 'dart:convert';
// import 'dart:ffi';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_dashboard/pages/overview/widgets/barcode.dart';
import 'package:admin_dashboard/pages/overview/widgets/scan.dart';
import 'package:http/http.dart' as http;
import 'package:admin_dashboard/constants/constants.dart';
import 'package:admin_dashboard/controllers/customers_controller.dart';
import 'package:admin_dashboard/controllers/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/pages/overview/widgets/info_card.dart';
import 'package:get/get.dart';
import '../../../models/product.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  const OverviewCardsLargeScreen({
    super.key,
  });

  @override
  State<OverviewCardsLargeScreen> createState() =>
      _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
  final CustomersController customersController =
      Get.put(CustomersController());
  String? count1;
  String? Count2;
  String? UserCont;
  String? vendorCont;
  final ProductsController productsController = Get.put(ProductsController());

  @override
  void initState() {
    super.initState();
    productsController.fetchProducts();
    customersController.fetchCustomers();
    GetCount();
    userCount();
    vendorCount();
  }

  Future<void> userCount() async {
    final urll = "http://192.168.0.112/api/user_count.php";

    var response = await http.get(Uri.parse(urll));
    if (response.statusCode == 200) {
      Map<String, dynamic> Data = json.decode(response.body);
      final String userC = Data['total_rows'];
      print("usercount : $UserCont");
      setState(() {
        UserCont = userC;
      });
    }
  }

  Future<void> vendorCount() async {
    final urll = "http://192.168.0.112/api/vendor_count.php";

    var response = await http.get(Uri.parse(urll));
    if (response.statusCode == 200) {
      Map<String, dynamic> Data = json.decode(response.body);
      final String vendorC = Data['total_rows'];
      print("vendor: $vendorC");
      setState(() {
        vendorCont = vendorC;
      });
    }
  }

  Future<void> GetCount() async {
    final url = "http://192.168.0.112/api/total_product.php";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> Data = json.decode(response.body);
      final String no1 = Data['table1_total_rows'];
      final String no2 = Data['table2_total_rows'];

      setState(() {
        Count2 = no2;
        count1 = no1;
      });
      print("rsponse: ${Data['table1_total_rows']}");
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

    // int calculateTotalValue(List<Product> stock){
    //   int totalValue=0;
    //   for(int i = 0; i < productsController.products.length; i++){
    //     totalValue +=
    //     productsController.products[i].qty! *
    //     productsController.products[i].price!;
    //   }
    //   return totalValue;
    // }

    return Row(
      children: [
        InfoCard(
          title: Constants.totalStock,
          value: count1.toString(),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => vendorSelct()));
          },
          topColor: Colors.orange,
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: Constants.valueOfStock,
          value: Count2.toString(),
          topColor: Colors.lightGreen,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BarcodeScannerScreen()));
          },
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: Constants.productsCount,
          value: vendorCont.toString(),
          topColor: Colors.redAccent,
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: Constants.customerCount,
          value: UserCont.toString(),
          onTap: () {
            customersController.fetchCustomers();
          },
        ),
      ],
    );
  }
}
