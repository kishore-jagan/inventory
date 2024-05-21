// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:admin_dashboard/helpers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

class MyPopup extends StatefulWidget {
  final Function(String) onConfirmed;
  String name;
  String modelNo;
  String category;
  String location;
  String type;
  String qty;
  String value;
  String status;
  String date;
  String stock_in_out;
  String decsription;
  String vendor;

  MyPopup(
      {Key? key,
      required this.name,
      required this.onConfirmed,
      required this.modelNo,
      required this.category,
      required this.location,
      required this.type,
      required this.qty,
      required this.value,
      required this.status,
      required this.date,
      required this.stock_in_out,
      required this.decsription,
      required this.vendor})
      : super(key: key);

  @override
  State<MyPopup> createState() => _MyPopupState();
}

class _MyPopupState extends State<MyPopup> {
  bool E1 = false;
  bool E2 = false;
  bool E3 = false;
  String selectedUnit = "meters"; // Default unit
  late final bool isIntegerInput;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _vendorController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _StockController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _valueController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  // TextEditingController _StockController = TextEditingController();
  String SelectedStock = "Stock In";
  List<String> Categories4 = ["Stock In", "Stock Out"];

  @override
  initState() {
    super.initState();
    setState(() {
      _modelController.text = widget.modelNo;
      _qtyController.text = widget.qty;
      SelectedStock = widget.stock_in_out;
      selectedUnit = widget.value;
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      // getDate();
      print(
          '{mode: ${_modelController.text}, qty: ${_qtyController.text}, stock: $SelectedStock, unit: $selectedUnit, date: $date}');
    });
  }

  // void getDate() async {
  //   var now = new DateTime.now();
  //   var formatter = new DateFormat('yyyy-MM-dd');
  //   String formattedDate = formatter.format(now);
  //   print('dateee : $formattedDate');
  // }

  Future<void> PressC(
      bool cont, TextEditingController controller, String data) async {
    setState(() {
      cont = !cont;

      if (cont) {
        controller.text = data;
      }

      print(controller.text);
    });
  }

  void onNameEditPressed() {
    setState(() {
      E1 = !E1;
    });
    if (E1) {
      _modelController.text = widget.name;
    }
  }

  void onModelNoEditPressed() {
    setState(() {
      E1 = !E1;
    });
    if (E1) {
      _modelController.text = widget.modelNo;
    }
  }

  void onqtyEditPressed() {
    setState(() {
      E2 = !E2;
    });
    if (E2) {
      _qtyController.text = '0';
    }
  }

  Future<void> SUbmit() async {
    const String url = 'http://192.168.0.112/api/edit_pro.php';

    var response = await http.post(Uri.parse(url), headers: {
      'content-type': 'application/x-www-form-urlencoded'
    }, body: {
      'model_no': _modelController.text,
      'qty': _qtyController.text,
      'Stock_in_out': SelectedStock,
      'name': widget.name,
      'category': widget.category,
      'vendor_name': widget.vendor,
      'date': ''
    });
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
    }
  }

// Gana
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.name.toUpperCase()),
      content: Container(
        width: 400,
        height: 400,
        child: Column(
          // Example: Display product details in the popup
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 10,
                    child: const Center(child: Text('Product Model No :'))),
                const SizedBox(
                  width: 10,
                ),
                CustomCont2(
                  data: widget.modelNo,
                  enabled: E1,
                  controller: _modelController,
                  onpress: (E1) => onModelNoEditPressed(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 10,
                    child: const Center(child: Text('Product Quantity :'))),
                const SizedBox(
                  width: 10,
                ),
                CustomCont1(
                  data: widget.qty,
                  enabled: E2,
                  controller: _qtyController,
                  unit: selectedUnit,
                  onpress: (E2) => onqtyEditPressed(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 10,
                    child: const Center(child: Text('Product In/Out :'))),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    value: SelectedStock,
                    onChanged: (value) {
                      setState(() {
                        SelectedStock = value!;
                      });
                    },
                    items: Categories4.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'In/Out',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Row(
            //   children: [
            //     Flexible(
            //       child: Row(
            //         children: [
            //           Flexible(
            //               child: CustomField(
            //             controller: _controller,
            //             data: widget.name,
            //             enabled: E1,
            //           )),
            //           IconButton(
            //               onPressed: () {
            //                 setState(() {
            //                   E1 = !E1;

            //                   if (E1) {
            //                     _controller.text = widget.name;
            //                   }
            //                   print(_controller.text);
            //                 });
            //               },
            //               icon: Icon(
            //                 Icons.edit,
            //                 color: Colors.indigo,
            //               ))
            //         ],
            //       ),
            //     ),
            //     Flexible(
            //       child: Row(
            //         children: [
            //           Flexible(
            //               child: CustomField(
            //             controller: _modelController,
            //             data: widget.modelNo,
            //             enabled: E2,
            //           )),
            //           IconButton(
            //               onPressed: () {
            //                 setState(() {
            //                   E2 = !E2;

            //                   if (E2) {
            //                     _modelController.text = widget.modelNo;
            //                   }
            //                   print(_modelController.text);
            //                 });
            //               },
            //               icon: Icon(
            //                 Icons.edit,
            //                 color: Colors.indigo,
            //               ))
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20),
            // Text(
            //   E1 ? 'Editing: ${_controller.text}' : 'Name: ${widget.name}',
            //   style: TextStyle(fontSize: 16),
            // ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Perform actions or update data and call onConfirmed
            // ...
            SUbmit(); // Pass the new name or data as needed
          },
          child: const Text(
            'submit',
            style: TextStyle(color: Colors.green),
          ),
        ),
        // ... other buttons or actions
      ],
    );
  }
}

class CustomField extends StatelessWidget {
  TextEditingController controller;
  bool enabled;
  String data;
  CustomField(
      {Key? key,
      required this.controller,
      required this.enabled,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
          label: Text(data),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
    );
  }
}

class CustomField3 extends StatelessWidget {
  TextEditingController controller;
  bool enabled;
  String data;
  String unit;
  CustomField3({
    Key? key,
    required this.controller,
    required this.enabled,
    required this.data,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: unit == "meters"
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: unit == "meters"
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
          : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          label: Text(data),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
    );
  }
}

class CustomCont1 extends StatelessWidget {
  TextEditingController controller;
  bool enabled;
  String data;
  late Function(bool) onpress;
  String unit;
  CustomCont1(
      {Key? key,
      required this.controller,
      required this.enabled,
      required this.onpress,
      required this.unit,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 4,
              )
            ]),
        child: Container(
          child: Row(
            children: [
              Flexible(
                  child: TextFormField(
                // key: ValueKey(
                //     !enabled), // Use a ValueKey to recreate TextFormField when enabled changes
                controller: controller,
                enabled: enabled,
                keyboardType: unit == "meters"
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.number,
                inputFormatters: unit == "meters"
                    ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                    : [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    hintText: data, border: InputBorder.none
                    // OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
              )),
              IconButton(
                  onPressed: () {
                    onpress(enabled);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.indigo,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCont2 extends StatelessWidget {
  TextEditingController controller;
  bool enabled;
  String data;
  late Function(bool) onpress;
  CustomCont2(
      {Key? key,
      required this.controller,
      required this.enabled,
      required this.onpress,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 4,
              )
            ]),
        child: Container(
          child: Row(
            children: [
              Flexible(
                  child: TextFormField(
                // key: ValueKey(
                //     !enabled), // Use a ValueKey to recreate TextFormField when enabled changes
                controller: controller,
                enabled: enabled,
                decoration: InputDecoration(
                    hintText: data, border: InputBorder.none
                    // OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
              )),
              IconButton(
                  onPressed: () {
                    onpress(enabled);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.indigo,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
