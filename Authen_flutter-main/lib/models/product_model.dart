// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String productName;
  String productType;
  int price;
  String unit;
  //int v;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productType,
    required this.price,
    required this.unit,
    //required this.v,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        productName: json["product_name"],
        productType: json["product_type"],
        price: json["price"],
        unit: json["unit"],
        //v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit,
        //"__v": v,
      };
}
