import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/style.dart';
import '../../../controllers/products_controller.dart';
import '../../../widgets/custom_text.dart';
import 'package:http/http.dart' as http;

class AvailableDriversTable extends StatefulWidget {
  const AvailableDriversTable({super.key});

  @override
  State<AvailableDriversTable> createState() => _AvailableDriversTableState();
}

class _AvailableDriversTableState extends State<AvailableDriversTable> {
  final ProductsController productsController = Get.put(ProductsController());
  List<dynamic> dataPro = [];
  bool isLoading = true;
  int count = 1;

  @override
  void initState() {
    super.initState();
    productsController.fetchProducts();
    GetData();
  }

  Future<void> GetData() async {
    final String url = 'http://192.168.0.112/api/stock_out.php';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> product = json.decode(response.body);
      setState(() {
        dataPro = product['product'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Model No')),
      DataColumn(label: Text('Vendor Name')),
      DataColumn(label: Text('In/Out')),
      DataColumn(label: Text('Quantity')),
      // DataColumn(label: Text('Rating')),
      // DataColumn(label: Text('Stock')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: active.withOpacity(.4), width: .5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 6),
                color: lightGray.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: "Top Selling Products",
                  color: lightGray,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            AdaptiveScrollbar(
              underColor: Colors.blueGrey.withOpacity(0.3),
              sliderDefaultColor: active.withOpacity(0.7),
              sliderActiveColor: active,
              controller: verticalScrollController,
              child: AdaptiveScrollbar(
                controller: horizontalScrollController,
                position: ScrollbarPosition.bottom,
                underColor: lightGray.withOpacity(0.3),
                sliderDefaultColor: active.withOpacity(0.7),
                sliderActiveColor: active,
                width: 13.0,
                sliderHeight: 100.0,
                child: SingleChildScrollView(
                  controller: verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    controller: horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : DataTable(
                              columns: columns,
                              rows: List<DataRow>.generate(
                                4,
                                (index) => DataRow(cells: [
                                  DataCell(CustomText(
                                    text: dataPro[index]['id'],
                                  )),
                                  DataCell(CustomText(
                                    text: dataPro[index]['name'],
                                  )),
                                  DataCell(CustomText(
                                    text: dataPro[index]['model_no'],
                                  )),
                                  DataCell(CustomText(
                                    text: dataPro[index]['vendorName'],
                                  )),
                                  DataCell(CustomText(
                                    text: dataPro[index]['stock'],
                                  )),
                                  DataCell(CustomText(
                                    text: dataPro[index]['qty'],
                                  )),
                                  // DataCell(Row(
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   children: [
                                  //     const Icon(
                                  //       Icons.star,
                                  //       color: Colors.deepOrange,
                                  //       size: 18,
                                  //     ),
                                  //     const SizedBox(width: 5,),
                                  //     CustomText(text:
                                  //     productsController.products[index].rating!.toString(),),
                                  //   ],
                                  // )),
                                  // DataCell(CustomText(
                                  //   text: productsController.products[index].stock!.toString(),
                                  // )),
                                ]),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
