import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  // Controller for text input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController DescController = TextEditingController();
  TextEditingController VendornameController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  final GlobalKey<_MyWidgetState> _myWidgetKey = GlobalKey<_MyWidgetState>();
  String selectedUnit = "meters"; // Default unit
  late final bool isIntegerInput;
  bool _showTextField = false;
  bool isTap = false;
  bool isLoading = false;
  String _selectedValue = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isIntegerInput = selectedUnit == "pieces";
    _myWidgetKey.currentState?._fetchVendors();
  }

  List<String> suggestions = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Elderberry"
  ];

  // Dropdown value and items
  String selectedCategory = "electrical";
  List<String> categories = ["electrical", "mechanical"];

  String SelectedType = "Rental";
  List<String> Categories2 = ["Rental", "Assets"];

  String SelectedLocation = "Inhouse";
  List<String> Categories3 = ["Inhouse", "Warehouse"];

  String SelectedStock = "Stock In";
  List<String> Categories4 = ["Stock In", "Stock Out"];

  List<String> Categories5 = ["meters", "pieces"];

  Future<void> saveData() async {
    final url = "http://192.168.0.112/api/inventory.php";

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/x-www-form-urlencoded",
      },
      body: {
        "name": nameController.text,
        "model_no": modelController.text,
        "qty": qtyController.text,
        "category": selectedCategory,
        "location": SelectedLocation,
        "status": statusController.text,
        "type": SelectedType,
        "vendor_name": VendornameController.text,
        "date": DateController.text,
        "Stock_in_out": 'Stock In',
        "Desc": DescController.text,
        "value": selectedUnit
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print("Response: $data");
      if (data['status'] == 'success') {
        final String remark = data['remark'];

        _showtoast(remark, Colors.green);
        await AddVendor();
        setState(() {
          isLoading = false;
        });
      }
      if (data['status'] == 'Failed') {
        final String message = data['remark'];
        _showtoast(message, Colors.red);
        setState(() {
          isLoading = false;
        });
        // isLoading = false;
      }

      print("success");
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

  Future<void> AddVendor() async {
    final url2 = "http://192.168.0.112/api/vendor_create.php";

    var response = await http.post(
      Uri.parse(url2),
      headers: {
        "content-type": "application/x-www-form-urlencoded",
      },
      body: {"vendorName": VendornameController.text},
    );

    if (response.statusCode == 200) {
      final Data = json.decode(response.body);
      print("vendor added : $Data");
      _myWidgetKey.currentState?._fetchVendors();
      VendornameController.clear();
    } else {
      print("vendor no created");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isTap = !isTap;
                        });
                      },
                      radius: 25,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            color:
                                isTap ? Colors.lightBlueAccent : Colors.green,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        child: const Center(
                            child: Text(
                          'Dispatch',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: Offset(0, 2),
                              blurRadius: 2,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Item Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: CustomeField(
                                    Controller: nameController,
                                    hint: "Enter name",
                                    // lableText: "Enter name",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: CustomeField(
                                    Controller: modelController,
                                    hint: "Enter model number",
                                    // lableText: "Enter model number",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    // color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            // width: 60, height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: Colors.grey
                                              //         .withOpacity(0.2),
                                              //     offset: const Offset(0, 2),
                                              //     blurRadius: 4,
                                              //   )
                                              // ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: TextField(
                                                controller: qtyController,
                                                keyboardType:
                                                    selectedUnit == "meters"
                                                        ? const TextInputType
                                                            .numberWithOptions(
                                                            decimal: true)
                                                        : TextInputType.number,
                                                inputFormatters:
                                                    selectedUnit == "meters"
                                                        ? [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^\d*\.?\d*'))
                                                          ]
                                                        : [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                decoration: const InputDecoration(
                                                    // labelText: "Enter Quantity",
                                                    hintText: "Enter Quantity",
                                                    border: InputBorder.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            color: Colors.grey.withOpacity(0.1),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: Colors.grey
                                            //         .withOpacity(0.2),
                                            //     offset: const Offset(0, 2),
                                            //     blurRadius: 4,
                                            //   )
                                            // ]
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: selectedUnit,
                                              items: Categories5.map(
                                                  (String category) {
                                                return DropdownMenuItem<String>(
                                                  value: category,
                                                  child: Text(category),
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                labelText: 'Value',
                                                border: InputBorder.none,
                                                // enabledBorder: OutlineInputBorder(
                                                //   borderRadius:
                                                //       BorderRadius.circular(20),
                                                //   borderSide: BorderSide(
                                                //       color: Colors.grey),
                                                // ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedUnit = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: Colors.grey.withOpacity(0.1),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withOpacity(0.1),
                                      //     offset: const Offset(0, 2),
                                      //     blurRadius: 4,
                                      //   )
                                      // ]
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedCategory,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCategory = value!;
                                          });
                                        },
                                        items:
                                            categories.map((String category) {
                                          return DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: 'Category',
                                          border: InputBorder.none,
                                          // enabledBorder: OutlineInputBorder(
                                          //   borderRadius:
                                          //       BorderRadius.circular(20),
                                          //   borderSide:
                                          //       BorderSide(color: Colors.grey),
                                          // ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: Colors.grey.withOpacity(0.1),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withOpacity(0.1),
                                      //     offset: const Offset(0, 2),
                                      //     blurRadius: 4,
                                      //   )
                                      // ]
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: DropdownButtonFormField<String>(
                                        value: SelectedType,
                                        onChanged: (value) {
                                          setState(() {
                                            SelectedType = value!;
                                          });
                                        },
                                        items:
                                            Categories2.map((String category) {
                                          return DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: 'Type',
                                          border: InputBorder.none,
                                          // enabledBorder: OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(20),
                                          //   borderSide:
                                          //       BorderSide(color: Colors.grey),
                                          // ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: Colors.grey.withOpacity(0.1),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withOpacity(0.1),
                                      //     offset: const Offset(0, 2),
                                      //     blurRadius: 4,
                                      //   )
                                      // ]
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: DropdownButtonFormField<String>(
                                        value: SelectedLocation,
                                        onChanged: (value) {
                                          setState(() {
                                            SelectedLocation = value!;
                                          });
                                        },
                                        items:
                                            Categories3.map((String category) {
                                          return DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: 'Location',

                                          border: InputBorder.none,
                                          // enabledBorder: OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(20),
                                          //   borderSide:
                                          //       BorderSide(color: Colors.grey),
                                          // ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            CustomeField(
                              Controller: statusController,
                              hint: "Enter Status",
                              // lableText: "Enter Status",
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.1),
                        //     offset: Offset(0, 2),
                        //     blurRadius: 2,
                        //   )
                        // ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Column(
                              children: [
                                Text(
                                  "Vendor Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: MyWidget(
                                  key: _myWidgetKey,
                                  controller: VendornameController,
                                )),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: Colors.grey.withOpacity(0.1),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withOpacity(0.1),
                                      //     offset: const Offset(0, 2),
                                      //     blurRadius: 4,
                                      //   )
                                      //   ]
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextField(
                                        controller: DateController,
                                        decoration: InputDecoration(
                                            labelText: 'date',
                                            hintText: "Date",
                                            suffixIcon: IconButton(
                                              icon: const Icon(
                                                  Icons.calendar_today),
                                              onPressed: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2101),
                                                );

                                                if (pickedDate != null &&
                                                    pickedDate !=
                                                        DateTime.now()) {
                                                  // Format the selected date as needed
                                                  String formattedDate =
                                                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                                  // Update the text field with the selected date
                                                  DateController.text =
                                                      formattedDate;
                                                }
                                              },
                                            ),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 70,
                                    child: CustomeField(
                                      Controller: DescController,
                                      hint: "Enter Description",
                                      // lableText: "Enter Description",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  final vendorName = VendornameController.text;

                                  setState(() {
                                    _myWidgetKey.currentState
                                        ?.setSelectedOption();
                                  });
                                  isLoading = true;
                                  print(
                                      'vendor name: ${VendornameController.text}');
                                  if (nameController.text.isNotEmpty &&
                                      modelController.text.isNotEmpty &&
                                      qtyController.text.isNotEmpty &&
                                      SelectedType.isNotEmpty &&
                                      SelectedLocation.isNotEmpty &&
                                      selectedCategory.isNotEmpty &&
                                      // SelectedStock.isNotEmpty &&
                                      DescController.text.isNotEmpty &&
                                      VendornameController.text.isNotEmpty &&
                                      DateController.text.isNotEmpty &&
                                      statusController.text.isNotEmpty) {
                                    print("Started");

                                    await saveData();

                                    print("End");
                                  } else {
                                    isLoading = false;
                                    print("null value handled");
                                    _showtoast(
                                        'Please fill all fields', Colors.red);
                                  }
                                } catch (e) {
                                  print('error: $e');
                                  isLoading = false;
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CustomeField extends StatelessWidget {
  final String hint;
  // final String lableText;
  final TextEditingController Controller;

  const CustomeField({
    required this.Controller,
    // required this.lableText,
    required this.hint,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.grey.withOpacity(0.1),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     offset: const Offset(0, 2),
        //     blurRadius: 4,
        //   )
        // ]
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
          controller: Controller,
          decoration: InputDecoration(
              // labelText: lableText,
              hintText: hint,
              border: InputBorder.none),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  TextEditingController controller;
  MyWidget({required this.controller, Key? key}) : super(key: key);
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> _options = [];
  String _selectedOption = '';

  Future<void> setSelectedOption() async {
    // widget.controller.text = option; // Set the text controller value directly
    setState(() {
      _selectedOption = widget.controller.text;
    });
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
      print('Controller Text: ${widget.controller.text}');
    } else {
      throw Exception('Failed to load vendors');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _options.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selectedOption) {
        setState(() {
          _selectedOption = selectedOption;
        });
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.grey.withOpacity(0.1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.1),
            //     offset: const Offset(0, 2),
            //     blurRadius: 4,
            //   )
            // ]
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (value) {
                setState(() {
                  widget.controller.text = textEditingController.text;
                  print('Typed: ${widget.controller.text}');
                });
              },
              onFieldSubmitted: (String value) {
                setState(() {
                  widget.controller.text = textEditingController.text;
                  print('Typed: ${widget.controller.text}');
                });
                onFieldSubmitted();
              },
              decoration: const InputDecoration(
                  hintText: 'Enter your suggestion',
                  // hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none),
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            onSelected(option);
                            print(_selectedOption);
                          });
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
                icon: const Icon(Icons.cancel))
          ],
        );
      },
    );
  }
}
