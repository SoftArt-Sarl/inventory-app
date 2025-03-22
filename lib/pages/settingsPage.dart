import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/updatePassWord.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  int selectedTab = 0; // 0 = Edit Profile, 1 = Change Password, 2 = Create User

  void onTabSelected(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Sidebar
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      _buildSidebarItem(
                        FontAwesomeIcons.user,
                        "Edit profile",
                        isActive: selectedTab == 0,
                        onTap: () => onTabSelected(0),
                      ),
                      _buildSidebarItem(
                        FontAwesomeIcons.lock,
                        "My Password",
                        isActive: selectedTab == 1,
                        onTap: () => onTabSelected(1),
                      ),
                      _buildSidebarItem(
                        FontAwesomeIcons.userPlus,
                        "Add new User",
                        isActive: selectedTab == 2,
                        onTap: () => onTabSelected(2),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                // Main Content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedTab == 0
                              ? "Edit Profile"
                              : selectedTab == 1
                                  ? "Change Password"
                                  : "Créer un utilisateur",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        selectedTab == 0
                            ? Center(child: Text("Edit Profile Page (to be implemented)"))
                            : selectedTab == 1
                                ? UpdatePasswordPage()
                                : CreateUserPage(),
                      ],
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

  Widget _buildSidebarItem(IconData icon, String title, {bool isActive = false, required VoidCallback onTap}) {
    return ListTile(
      leading: FaIcon(icon, color: isActive ? Colors.orange : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.orange : Colors.grey[700],
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}

// 🆕 Page de création d'utilisateur
class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            label: "Name",
            icon: FontAwesomeIcons.user,
            controller: nameController,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            label: "Email",
            icon: FontAwesomeIcons.envelope,
            controller: emailController,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            label: "Password",
            icon: FontAwesomeIcons.lock,
            controller: passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Action pour créer un utilisateur
                print("Nom: ${nameController.text}");
                print("Email: ${emailController.text}");
                print("Mot de passe: ${passwordController.text}");
              }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Submit", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Ce champ est requis";
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
}
