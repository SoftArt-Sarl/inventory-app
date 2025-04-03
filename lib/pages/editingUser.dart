import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controller/appController.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false; // Indicateur de chargement

  Future<void> updateUser(String newName) async {
    final Dio _dio = Dio(
      BaseOptions(baseUrl: 'https://inventory-app-five-ebon.vercel.app'),
    );

    setState(() {
      isLoading = true; // Activer le chargement
    });

    try {
      final response = await _dio.put(
        '/user/update',
        data: {
          "name": newName,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
          },
        ),
      );

      Get.snackbar(
        "Succès",
        "Profil mis à jour avec succès !",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Échec de la mise à jour du profil.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(
              label: "Nom",
              icon: FontAwesomeIcons.user,
              controller: nameController,
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(color: Colors.orange) // Loader
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUser(nameController.text);
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Update",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Ce champ est requis";
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: InputBorder.none,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }
}
