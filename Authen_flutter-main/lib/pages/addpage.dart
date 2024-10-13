import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/product_service.dart';
import 'package:flutter_lab1/models/product_model.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String? productName;
  String? productType;
  int? price;
  String? unit;

  void addProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ProductModel newProduct = ProductModel(
        id: '', // จะได้จาก API ถ้าจำเป็น
        productName: productName!,
        productType: productType!,
        price: price!,
        unit: unit!,
      );

      final response = await ProductService().addProduct(context, newProduct);
      if (response) {
        Navigator.pop(context, true); // ส่งค่ากลับว่าการเพิ่มสำเร็จ
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
        Navigator.pop(context, false); // ส่งค่ากลับว่าการเพิ่มล้มเหลว
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: const Color(0xff821131), // เปลี่ยนสี AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a New Product',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a product name' : null,
                  onSaved: (value) => productName = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Type',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a product type' : null,
                  onSaved: (value) => productType = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                  onSaved: (value) => price = int.tryParse(value!),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Unit',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a unit' : null,
                  onSaved: (value) => unit = value,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: addProduct,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      backgroundColor: Colors.blue, // เปลี่ยนสีปุ่มที่นี่
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Add Product',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}