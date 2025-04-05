import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/pages/editingUser.dart';
import 'package:flutter_application_1/pages/updatePassWord.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = appTypeController.isDesktop.value;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          if(isDesktop)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
                  children: [
                    // Ajoutez ici les widgets pour l'en-tête
                    Text('Settings', style: TextStyle(fontSize: 20)),
                    Spacer(), UserProfile()
                  ],
                ),
          ),
          // Onglets personnalisés
          if (!isDesktop) _buildCustomTabs(isDesktop),
          const Divider(height: 1, color: Colors.grey),
          // Contenu des onglets
          Expanded(
            child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ),
        ],
      ),
    );
  }

  // Construction des onglets personnalisés
  Widget _buildCustomTabs(bool isDesktop) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem("Edit Profile", FontAwesomeIcons.user, 0),
            _buildTabItem("Update Password", FontAwesomeIcons.lock, 1),
            _buildTabItem("Company Logo", FontAwesomeIcons.image, 2),
            _buildTabItem("Company Name", FontAwesomeIcons.building, 3),
            _buildTabItem("Create Seller", FontAwesomeIcons.userTie, 4),
          ],
        ),
      ),
    );
  }

  // Construction d'un onglet individuel
  Widget _buildTabItem(String title, IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.orange : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: 2,
                width: 60,
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }

  // Disposition pour le bureau (onglets à gauche)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 250,
          color: Colors.grey[200],
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuItem("Edit Profile", FontAwesomeIcons.user, 0),
              _buildMenuItem("Update Password", FontAwesomeIcons.lock, 1),
              _buildMenuItem("Company Logo", FontAwesomeIcons.image, 2),
              _buildMenuItem("Company Name", FontAwesomeIcons.building, 3),
              _buildMenuItem("Create Seller", FontAwesomeIcons.userTie, 4),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: Colors.grey),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                EditProfilePage(), // Page pour modifier le profil
                const UpdatePasswordPage(), // Page pour changer le mot de passe
                UpdateCompanyLogoPage(), // Page pour modifier le logo de l'entreprise
                UpdateCompanyNamePage(), // Page pour modifier le nom de l'entreprise
                CreateSellerPage(), // Page pour créer un Seller
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Disposition pour le mobile (contenu des onglets)
  Widget _buildMobileLayout() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        EditProfilePage(), // Page pour modifier le profil
        const UpdatePasswordPage(), // Page pour changer le mot de passe
        UpdateCompanyLogoPage(), // Page pour modifier le logo de l'entreprise
        UpdateCompanyNamePage(), // Page pour modifier le nom de l'entreprise
        CreateSellerPage(), // Page pour créer un Seller
      ],
    );
  }

  // Construction d'un élément de menu pour le bureau
  Widget _buildMenuItem(String title, IconData icon, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Card(
        elevation: 0,
        // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        color: _selectedIndex == index ? Colors.white : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: _selectedIndex == index ? Colors.orange : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: _selectedIndex == index ? Colors.orange : Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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

// 🆕 Page pour modifier le logo de l'entreprise
class UpdateCompanyLogoPage extends StatefulWidget {
  @override
  _UpdateCompanyLogoPageState createState() => _UpdateCompanyLogoPageState();
}

class _UpdateCompanyLogoPageState extends State<UpdateCompanyLogoPage> {
  final ApiService apiService = ApiService();
  bool isLoading = false;
  File? _selectedImage; // Fichier pour stocker l'image sélectionnée
  String? _webImagePath; // Chemin pour l'image sélectionnée sur le web

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, // Permet de choisir une image depuis la galerie
        maxWidth: 800, // Redimensionne l'image pour réduire la taille
        maxHeight: 800,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // Pour le web, utilisez le chemin temporaire
          setState(() {
            _webImagePath = pickedFile.path;
          });
        } else {
          // Pour mobile/desktop, utilisez File
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error picking image")),
      );
    }
  }

  Future<void> uploadLogo() async {
    if (!kIsWeb && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    if (kIsWeb && _webImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await apiService.updateCompanyLogo(
        kIsWeb ? _webImagePath! : _selectedImage!.path,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logo uploaded successfully")),
        );
        await apiController.fetchCompanyUserInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload logo")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error uploading logo")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Affiche l'image sélectionnée ou un placeholder
                GestureDetector(
                  onTap: pickImage,
                  child: kIsWeb
                      ? (_webImagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                _webImagePath!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ))
                      : (_selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImage!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tap the image to select a new logo",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(
                          Icons.photo_library,
                          size: 20,
                        ),
                        label: const Text(
                          "Select Image",
                          strutStyle: StrutStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : uploadLogo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    "Upload Logo",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// 🆕 Page pour modifier le nom de l'entreprise
class UpdateCompanyNamePage extends StatefulWidget {
  @override
  _UpdateCompanyNamePageState createState() => _UpdateCompanyNamePageState();
}

class _UpdateCompanyNamePageState extends State<UpdateCompanyNamePage> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> updateCompanyName() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await apiService.updateCompanyName(nameController.text);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Company name updated successfully")),
        );
        await apiController.fetchCompanyUserInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update company name")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating company name")),
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
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(
              label: "Company Name",
              icon: FontAwesomeIcons.building,
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Company name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: updateCompanyName,
                    child: const Text("Update Company Name"),
                  ),
          ],
        ),
      ),
    );
  }
}

// 🆕 Page pour créer un Seller
class CreateSellerPage extends StatefulWidget {
  @override
  _CreateSellerPageState createState() => _CreateSellerPageState();
}

class _CreateSellerPageState extends State<CreateSellerPage> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> createSeller() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await apiService.createSeller(
        emailController.text,
        passwordController.text,
        nameController.text,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Seller created successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create seller")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error creating seller")),
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
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(
              label: "Email",
              icon: FontAwesomeIcons.envelope,
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return "Enter a valid email address";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "Password",
              icon: FontAwesomeIcons.lock,
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                    .hasMatch(value)) {
                  return "least one lowercase letter, one uppercase letter, and one number";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "Name",
              icon: FontAwesomeIcons.user,
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: createSeller,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Create Seller"),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
