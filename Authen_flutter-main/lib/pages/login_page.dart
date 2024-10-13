import 'package:flutter/material.dart';
import 'package:flutter_lab1/widgets/login_form.dart';
import 'register_page.dart'; // ตรวจสอบให้แน่ใจว่ามีการ import register_page.dart

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 350, // ความกว้างของกรอบ
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 80, 96, 122),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Please log in to continue',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const LoginForm(),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          // ใช้ RegisterPage แทน register_page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text('Create an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
