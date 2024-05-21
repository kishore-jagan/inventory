import 'package:flutter/material.dart';

class Products {
  List<Products>? products;
  int? total;
  int? skip;
  int? limit;

  Products({this.products, this.total, this.skip, this.limit});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? modelNo;
  String? qty;
  String? category;
  String? type;
  String? status;
  String? location;
  String? VendorName;
  String? Date;
  String? Stock;

  Product(
      {this.id,
      this.title,
      this.modelNo,
      this.qty,
      this.category,
      this.type,
      this.status,
      this.location,
      this.VendorName,
      this.Date,
      this.Stock});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    title = json['name'];
    modelNo = json['model_no'];
    qty = json['qty '];
    category = json['category'];
    type = json['type'];
    status = json['status'];
    location = json['location'];
    VendorName = json['vendor_name'];
    Date = json['date'];
    Stock = json['Stock_in_out'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['name'] = title;

    data['model_no'] = modelNo;
    data['qty'] = qty;
    data['category'] = category;
    data['type'] = type;
    data['status'] = status;
    data['location'] = location;
    data['vendor_name'] = VendorName;
    data['date'] = Date;
    data['Stock_in_out'] = Stock;
    return data;
  }
}
