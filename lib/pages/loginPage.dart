import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models.dart/authmodel.dart';
import 'package:flutter_application_1/pages/registerPage.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await _apiService.loginUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // Vérifier si la connexion est réussie
        print(response.data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.data);
          AuthModel authModel = AuthModel.formjson(response.data);
          userinfo.authmodel.value = authModel;
          userinfo.saveAuthModel('authmodel', jsonEncode(response.data),);
          Get.snackbar("Success", "Login successful",
              backgroundColor: Colors.green, colorText: Colors.white,
              );
              
          // Rediriger vers la page d'accueil ou une autre page
          Get.offAll(() => const HomePage());
        } else {
          // print(e.toString);
          print(response.statusCode);
          Get.snackbar("Erreur", "Email or password incorrect",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (e) {
        print(e);
        Get.snackbar("Erreur", "Une erreur s\"est produite",
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator, // Ajout du paramètre validator
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        suffixIcon: suffixIcon,
        border: InputBorder.none,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    ),
  );
}

bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: IrregularShapePainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Login',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildTextField(
                          label: "Email",
                          icon: Icons.email,
                          controller: _emailController),
                      const SizedBox(height: 16),
                      _buildTextField(
                         suffixIcon: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  ),
                          label: "Password",
                          icon: Icons.lock,
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
                              return "least one lowercase letter, one uppercase letter, and one number";
                            }
                            return null;
                          },),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[600],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Login'),
                                ],
                              ),
                            ),
                      const SizedBox(height: 16),
                      // TextButton(
                      //   onPressed: () => Get.to(() => SignupPage()),
                      //   child: Text('Créer un compte',
                      //       style: TextStyle(color: Colors.orange[500])),
                      // ),
                      /* TextButton(
                        onPressed: () {},
                        child: Text('Mot de passe oublié ?',
                            style: TextStyle(color: Colors.grey[400])),
                      ), */
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
