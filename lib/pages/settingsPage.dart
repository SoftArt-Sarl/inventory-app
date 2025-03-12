import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/updatePassWord.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordChangeScreen extends StatelessWidget {
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
            // constraints: BoxConstraints(maxWidth: 800),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Sidebar
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      _buildSidebarItem(FontAwesomeIcons.user, "Edit profile"),
                      _buildSidebarItem(FontAwesomeIcons.lock, "Password", isActive: true),
                    ],
                  ),
                ),
                // Main Content
               const  Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Password",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        UpdatePasswordPage(),
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

  Widget _buildSidebarItem(IconData icon, String title, {bool isActive = false, bool isDanger = false}) {
    return ListTile(
      leading: FaIcon(icon, color: isActive ? Colors.orange : (isDanger ? Colors.red : Colors.grey)),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.orange : Colors.grey[700],
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        // Handle navigation
      },
    );
  }

}