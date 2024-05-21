import 'dart:convert';
import 'dart:io';

import 'package:admin_dashboard/constants/constants.dart';
import 'package:admin_dashboard/helpers/responsiveness.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../products/widgets/products_table.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<dynamic> DataPro = [];

  Future<void> generatePDF(List<dynamic> products) async {
    final pdf = pdfWidgets.Document();
    final ByteData fontByteData =
        await rootBundle.load('assets/OpenSans-Regular.ttf');
    final Uint8List fontData = fontByteData.buffer.asUint8List();
    final pdfWidgets.TtfFont font =
        pdfWidgets.TtfFont(fontData.buffer.asByteData());

    pdf.addPage(
      pdfWidgets.Page(
        build: (context) {
          return pdfWidgets.ListView(
            children: [
              for (var product in products)
                pdfWidgets.Container(
                  margin: pdfWidgets.EdgeInsets.symmetric(vertical: 8),
                  child: pdfWidgets.Column(
                    crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                    children: [
                      pdfWidgets.Text('Product Name: ${product['name']}',
                          style: pdfWidgets.TextStyle(font: font)),
                      pdfWidgets.Text('Model No: ${product['model_no']}',
                          style: pdfWidgets.TextStyle(font: font)),
                      pdfWidgets.BarcodeWidget(
                        barcode: pdfWidgets.Barcode.code128(),
                        data: product['barcode'].toString(),
                        width: 200,
                        height: 80,
                        color: PdfColor(0, 0, 0),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );

    final file = File('C:\\Users\\Lap1241\\Downloads\\product_list.pdf');
    await file.writeAsBytes(await pdf.save());
    print('end');
  }

  Future<void> getData() async {
    final String url = 'http://192.168.0.112/api/productData.php';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> product = json.decode(response.body);
      setState(() {
        DataPro = product['products'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await generatePDF(DataPro);
                  setState(() {}); // Trigger a rebuild after PDF generation
                },
                child: Text('Print'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: DataPro.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(DataPro[index]['name']),
                  subtitle: Text('Model No: ${DataPro[index]['model_no']}'),
                  trailing: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: DataPro[index]['barcode'],
                    width: 200,
                    height: 80,
                    color: Colors.black,
                  ),
                  onTap: () async {
                    print('start');
                    await generatePDF(DataPro[index]);
                    setState(() {}); // Trigger a rebuild after PDF generation
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class vendorSelct extends StatefulWidget {
  const vendorSelct({Key? key}) : super(key: key);

  @override
  State<vendorSelct> createState() => _vendorSelctState();
}

class _vendorSelctState extends State<vendorSelct> {
  List<dynamic> DataPro = [];
  bool isLoading = false;
  String selectedCategory = 'All';
  List<String> _options = [];
  List<dynamic> filteredData = [];
  TextEditingController controller = TextEditingController();

  @override
  initState() {
    super.initState();
    FetchData();
    _fetchVendors();
  }

  Future<void> generatePDF(List<dynamic> products) async {
    final pdf = pdfWidgets.Document();
    final ByteData fontByteData =
        await rootBundle.load('assets/OpenSans-Regular.ttf');
    final Uint8List fontData = fontByteData.buffer.asUint8List();
    final pdfWidgets.TtfFont font =
        pdfWidgets.TtfFont(fontData.buffer.asByteData());

    pdf.addPage(
      pdfWidgets.Page(
        build: (context) {
          return pdfWidgets.ListView(
            children: [
              for (var product in products)
                pdfWidgets.Container(
                  margin: pdfWidgets.EdgeInsets.symmetric(vertical: 8),
                  child: pdfWidgets.Column(
                    crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                    children: [
                      pdfWidgets.Text('Product Name: ${product['name']}',
                          style: pdfWidgets.TextStyle(font: font)),
                      pdfWidgets.Text('Model No: ${product['model_no']}',
                          style: pdfWidgets.TextStyle(font: font)),
                      pdfWidgets.BarcodeWidget(
                        barcode: pdfWidgets.Barcode.code128(),
                        data: product['barcode'].toString(),
                        width: 200,
                        height: 80,
                        color: PdfColor(0, 0, 0),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );

    final file = File('C:\\Users\\Lap1241\\Downloads\\product_list.pdf');
    await file.writeAsBytes(await pdf.save());
    print('end');
  }

  Future<void> FetchData() async {
    setState(() {
      isLoading = true;
      DataPro.clear();
      print('data start: $DataPro');
    });
    var response = await http.get(
      Uri.parse(Constants.productsUrl),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> Data = json.decode(response.body);
      List<dynamic> productList = Data['products'];
      List<productCls> products = productList.map((jsonProduct) {
        return productCls.fromJson(jsonProduct);
      }).toList();

      print('data : $productCls');
      setState(() {
        DataPro = productList;
        print("Data end: $DataPro");
        isLoading = false;
      });
    }
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ))
        .toList();
  }

  Future<void> _fetchVendors() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.112/api/vendor_detail.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['vendors'];
      print(data);
      setState(() {
        _options =
            data.map((vendor) => vendor['vendorName'].toString()).toList();
        print(_options);
      });
      print('Controller Text: ${controller.text}');
    } else {
      throw Exception('Failed to load vendors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildFilterDropdown(
                    'Category',
                    _options,
                    selectedCategory,
                    (value) {
                      setState(() {
                        selectedCategory = value!;
                        filteredData = DataPro.where((product) =>
                                product['vendor_name']
                                    .toLowerCase()
                                    .contains(selectedCategory.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await generatePDF(filteredData);
                        setState(() {});
                      },
                      child: Text('Download Pdf')),
                )
              ],
            ),

            // for (int i = 0; i < DataPro.length; i++)
            //   if ((selectedCategory == 'All' ||
            //       DataPro[i]['vendor_name']
            //           .toLowerCase()
            //           .contains(selectedCategory.toLowerCase())))
            // Wrap the conditional part with Column
            Expanded(
              child: ListView.builder(
                itemCount: DataPro
                    .length, // Use DataPro.length instead of filteredData.length
                itemBuilder: (context, index) {
                  if (selectedCategory == 'All' ||
                      DataPro[index]['vendor_name']
                          .toLowerCase()
                          .contains(selectedCategory.toLowerCase())) {
                    return ListTile(
                      title: Text('Name: ${DataPro[index]['name']}'),
                      subtitle: Text(
                        'Model No: ${DataPro[index]['model_no']}',
                      ),
                      trailing: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: DataPro[index]['barcode'],
                        width: 200,
                        height: 80,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        print('start');
                        // Trigger a rebuild after PDF generation
                      },
                    );
                  } else {
                    return Container(); // Return an empty container for non-matching items
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterDropdown(String label, List<String> items, String value,
      Function(String?) onChanged) {
    return DropdownButton<String>(
      value: value,
      items: buildDropdownMenuItems(['All'] + items),
      onChanged: onChanged,
      hint: Text(label),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    );
  }
}
