import 'dart:convert';
import 'package:admin_dashboard/helpers/authentication.dart';
import 'package:admin_dashboard/pages/products/widgets/edit_product.dart';
import 'package:admin_dashboard/pages/products/widgets/search.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
import '../../../controllers/products_controller.dart';
import '../../../widgets/custom_text.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key});

  @override
  State<ProductsTable> createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  // final ProductsController productsController = Get.put(ProductsController());
  List<dynamic> DataPro = [];
  int COUNT = 1;
  String selectedCategory = 'All';
  String selectedType = 'All';
  String selectedStatus = 'All';
  String searchData = 'All';
  List<String> suggetion = [];
  List<String> suggetion2 = [];
  bool isLoading = false;

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // productsController.fetchProducts();
    FetchData();
    // searchFunction().searchSuggestions('hj', suggetion);
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

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text("ID")),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Model No')),
      DataColumn(label: Text('Category')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Quantity')),
      DataColumn(label: Text('Actions')),
    ];

    final DataTableSource data = MyData(
      DataPro,
      COUNT,
      selectedCategory,
      selectedType,
      searchData,
      searchData,
      (value) {
        FetchData();
      },
      (product) {
        // Open the popup when edit button is pressed
        _showEditPopup(
            context,
            product['name'],
            product['model_no'],
            product['category'],
            product['location'],
            product['type'],
            product['qty'],
            product['value'],
            product['status'],
            product['date'],
            product['Stock_in_out'],
            product['Decs'],
            product['vendor_name'], (newName) {
          print('name: ${product['name']}');
          // Handle the new name here
          print('New Name: $newName');
          // You can update the data or perform other actions here
        });
      },
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              buildFilterDropdown(
                'Category',
                ['electrical', 'mechanical'],
                selectedCategory,
                (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(width: 10),
              buildFilterDropdown(
                'Type',
                ['Rental', 'Assets'],
                selectedType,
                (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              const SizedBox(width: 10),
              Spacer(),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchData = value;
                      // searchFunction().searchSuggestions(searchData, suggetion);
                    });
                  },
                  decoration: InputDecoration(
                      label: Text(
                          'Search here...  eg., Customer name, model no, scan barcode'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              )
              // search bar here...........
            ],
          ),
          SizedBox(
            height: 10,
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : PaginatedDataTable(
                  columns: columns,
                  source: data,
                  //header: const Text('All Products'),
                  columnSpacing: MediaQuery.of(context).size.width / 14,
                  horizontalMargin: 30,
                  rowsPerPage: 10,
                ),
        ],
      ),
    );
  }

  void _showEditPopup(
    BuildContext context,
    String Name1,
    String modelNo,
    String category,
    String location,
    String type,
    String qty,
    String value,
    String status,
    String date,
    String stock_in_out,
    String decsription,
    String vendorName,
    Function(String) onConfirmed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyPopup(
          onConfirmed: onConfirmed,
          name: Name1,
          modelNo: modelNo,
          category: category,
          qty: qty,
          status: status,
          decsription: decsription,
          stock_in_out: stock_in_out,
          date: date,
          value: value,
          location: location,
          type: type,
          vendor: vendorName,
        );
      },
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

class MyData extends DataTableSource {
  // final ProductsController productsController = Get.put(ProductsController());
  // late Function(Map<String, dynamic>) onEditPressed;
  List<Map<String, dynamic>> data = [];

  MyData(
    List<dynamic> products,
    int count,
    String selectedCategory,
    String selectedType,
    String SearchData,
    String suggetion2,
    Function(int) load,
    Function(Map<String, dynamic>) onEditPressed,
  ) {
    Future<void> delete(String id, String cat) async {
      final String url = 'http://192.168.0.112/api/pro_delete.php';

      var response = await http.get(Uri.parse('$url?id=$id&category=$cat'));
      if (response.statusCode == 200) {
        load(1);
        final data = json.decode(response.body);

        print(data);
      }
    }

    for (var i = 0; i < products.length; i++) {
      // Check if the product matches the selected category, type, and status filters
      if ((selectedCategory == 'All' ||
              products[i]['category'] == selectedCategory) &&
          (selectedType == 'All' || products[i]['type'] == selectedType) &&
          ((SearchData == 'All' ||
                  products[i]['model_no']
                      .toLowerCase()
                      .contains(SearchData.toLowerCase())) ||
              (SearchData == 'All' ||
                  products[i]['vendor_name']
                      .toLowerCase()
                      .contains(SearchData.toLowerCase())) ||
              (SearchData == 'All' ||
                  products[i]['barcode']
                      .toLowerCase()
                      .contains(SearchData.toLowerCase())))) {
        data.add({
          'id': count++,
          'Name': products[i]['name'],
          'Model No': products[i]['model_no'],
          'Category': products[i]['category'],
          'Status': products[i]['status'],
          'Quantity': products[i]['qty'],
          'actions': {
            'edit': () {
              onEditPressed(products[i]); // Pass the entire product map
              print('Edit');
            },
            'delete': () {
              delete(products[i]['id'].toString(), products[i]["category"]);
            },
          },
        });
      }
    }
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(
        data[index]['id'].toString(),
      )),
      DataCell(CustomText(text: data[index]['Name'])),
      DataCell(CustomText(text: data[index]['Model No'])),
      DataCell(CustomText(text: data[index]['Category'])),
      DataCell(CustomText(text: data[index]['Status'])),
      DataCell(Row(
        children: [
          // const Icon(Icons.star, color: Colors.orangeAccent),
          const SizedBox(width: 5),
          CustomText(text: data[index]['Quantity']),
        ],
      )),
      DataCell(Row(
        children: [
          IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.indigo,
              onPressed: data[index]['actions']['edit']),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.redAccent,
            onPressed: data[index]['actions']['delete'],
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class productCls {
  final String name;
  final String model_no;
  final String category;
  final String status;
  final String qty;

  productCls({
    required this.name,
    required this.model_no,
    required this.category,
    required this.status,
    required this.qty,
  });
  factory productCls.fromJson(Map<String, dynamic> json) {
    return productCls(
      name: json['name'],
      model_no: json['model_no'],
      category: json['category'],
      status: json['status'],
      qty: json['qty'].toString(),
    );
  }
  @override
  String toString() {
    return 'Product{name: $name, modelNo: $model_no, category: $category, status: $status, quantity: $qty}';
  }
}
