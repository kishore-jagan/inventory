import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/helpers/custom_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/style.dart';
import '../../../controllers/customers_controller.dart';
import '../../../widgets/custom_text.dart';
import 'package:http/http.dart' as http;

class ClientsTable extends StatefulWidget {
  const ClientsTable({super.key});

  @override
  State<ClientsTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ClientsTable> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final CustomersController customersController =
      Get.put(CustomersController());

  List<String> RoleList = ['Admin', 'User'];
  String SelectedRole = "Admin";

  @override
  void initState() {
    super.initState();
    customersController.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Username')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Phone')),
      DataColumn(label: Text('role')),
      DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() => Container(
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
          child: AdaptiveScrollbar(
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
                    child: customersController.isLoading.value
                        ? const CircularProgressIndicator()
                        : DataTable(
                            columns: columns,
                            columnSpacing:
                                MediaQuery.of(context).size.width / 16,
                            rows: List<DataRow>.generate(
                              customersController.customers.length,
                              (index) => DataRow(cells: [
                                DataCell(CustomText(
                                  text: customersController
                                      .customers[index].name
                                      .toString(),
                                )),
                                DataCell(CustomText(
                                    text: customersController
                                        .customers[index].username
                                        .toString())),
                                DataCell(CustomText(
                                    text: customersController
                                        .customers[index].email
                                        .toString())),
                                DataCell(CustomText(
                                  text: customersController
                                      .customers[index].phone
                                      .toString(),
                                )),
                                DataCell(CustomText(
                                  text: customersController
                                      .customers[index].role
                                      .toString(),
                                )),
                                /*DataCell(CustomText(
                        text: customersController.customers[index].phone
                            .toString())),*/
                                DataCell(InkWell(
                                  onTap: () {
                                    _showDialog();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: light,
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                          Border.all(color: active, width: .5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: CustomText(
                                      text: 'Block Client',
                                      color: active.withOpacity(.7),
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                              ]),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create Employee'),
            content: Container(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  CustomeField(Controller: _name, hint: 'Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomeField(Controller: _userName, hint: 'User Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomeField(Controller: _phone, hint: 'Phone No'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomeField(Controller: _email, hint: 'Email Id'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomeField(Controller: _password, hint: 'Password'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          )
                        ]),
                    child: DropdownButtonFormField<String>(
                      value: SelectedRole,
                      onChanged: (value) {
                        setState(() {
                          print('role = ${SelectedRole}');
                          SelectedRole = value!;
                          print(SelectedRole);
                        });
                      },
                      items: RoleList.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('close')),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        print(
                            'data : ${_name.text} ${_userName.text} ${_email.text} ${_phone.text} ${_password.text}${SelectedRole.toString()}');
                        await userSignup(
                            _name.text,
                            _userName.text,
                            _email.text,
                            _phone.text,
                            _password.text,
                            SelectedRole);

                        // Navigator.pop(context);
                      },
                      child: Text('submit')),
                ],
              )
            ],
          );
        });
  }
}

class CustomeDrop extends StatefulWidget {
  List<String> RoleList;
  String SelectedRole;
  CustomeDrop({Key? key, required this.RoleList, required this.SelectedRole});

  @override
  State<CustomeDrop> createState() => _CustomeDropState();
}

class _CustomeDropState extends State<CustomeDrop> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4,
            )
          ]),
      child: DropdownButtonFormField<String>(
        value: widget.SelectedRole,
        onChanged: (value) {
          setState(() {
            print('role = ${widget.SelectedRole}');
            widget.SelectedRole = value!;
            print(widget.SelectedRole);
          });
        },
        items: widget.RoleList.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Role',
          border: InputBorder.none,
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide:
          //       BorderSide(color: Colors.grey),
          // ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.blue),
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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4,
            )
          ]),
      child: TextField(
        controller: Controller,
        decoration: InputDecoration(
            // labelText: lableText,
            hintText: hint,
            border: InputBorder.none),
      ),
    );
  }
}
