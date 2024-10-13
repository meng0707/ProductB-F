import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/auth_service.dart';
import 'package:flutter_lab1/controller/product_service.dart';
import 'package:flutter_lab1/pages/addpage.dart';
import 'package:flutter_lab1/pages/editpage.dart';
import 'package:flutter_lab1/providers/user_providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lab1/models/product_model.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Future<List<ProductModel>>? futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().fetchProducts(context);
  }

  void refreshProducts() {
    setState(() {
      futureProducts = ProductService().fetchProducts(context);
    });
  }

  void _logout() async {
    try {
      await AuthService().logout(context);
      // นำผู้ใช้กลับไปยังหน้าล็อกอิน
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // พื้นหลังสีเทาอ่อนเพื่อความนุ่มนวล
      appBar: AppBar(
        title: Text(
          "ADMIN",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff821131), // สีเข้มสำหรับแถบด้านบน
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Products',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPage()),
                      );

                      if (result == true) {
                        refreshProducts();
                      }
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Add Product',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff33a0d0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                FutureBuilder<List<ProductModel>>(
                  future: futureProducts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No products available.'));
                    }

                    final products = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15.0),
                          child: Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${products[index].id}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  SizedBox(height: 5),
                                  Text('ชื่อ: ${products[index].productName}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 5),
                                  Text('ประเภท: ${products[index].productType}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 5),
                                  Text('ราคา: ${products[index].price}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 5),
                                  Text('จำนวน: ${products[index].unit}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditPage(
                                                  product: products[index]),
                                            ),
                                          ).then((value) {
                                            if (value == true) {
                                              refreshProducts(); // รีเฟรชข้อมูลเมื่อกลับมาจากหน้าจอแก้ไข
                                            }
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Confirm Delete"),
                                                content: Text(
                                                    "Are you sure you want to delete this product?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // ปิด dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text("Delete"),
                                                    onPressed: () async {
                                                      final isDeleted =
                                                          await ProductService()
                                                              .deleteProduct(
                                                                  context,
                                                                  products[
                                                                          index]
                                                                      .id);
                                                      if (isDeleted) {
                                                        refreshProducts();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Product deleted successfully')),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Failed to delete product')),
                                                        );
                                                      }
                                                      Navigator.of(context)
                                                          .pop(); // ปิด dialog
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
