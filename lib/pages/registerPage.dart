import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/loginPage.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec formes irrégulières et blur
          Positioned.fill(
            child: CustomPaint(
              painter: IrregularShapePainter(),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // Padding pour l'espace sur les côtés
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 16),
                    // Titre
                    const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Champs de saisie
                    _buildTextField(label: "Name", icon: Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField(label: "Email", icon: Icons.email),
                    const SizedBox(height: 16),
                    _buildTextField(label: "Password", icon: Icons.lock, obscureText: true),
                    const SizedBox(height: 16),
                    _buildTextField(label: "Confirm Password", icon: Icons.lock, obscureText: true),
                    const SizedBox(height: 16),
                    // Bouton d'inscription
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 16),
                    // Lien vers la connexion
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => LoginPage());
                      },
                      child: Text(
                        'or Login',
                        style: TextStyle(color: Colors.orange[500]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour simplifier la création des champs de texte
  Widget _buildTextField({required String label, required IconData icon, bool obscureText = false}) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          
          filled: true,
          fillColor: Colors.grey[300],
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: InputBorder.none,
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
        ),
      ),
    );
  }
}

// Peintre pour dessiner plusieurs formes irrégulières avec effet design
class IrregularShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // Forme 1 : Grand fond bleu
    paint.color = Colors.orange.withOpacity(0.3);
    Path path1 = Path();
    path1.moveTo(0, size.height * 0.2);
    path1.quadraticBezierTo(size.width * 0.3, size.height * 0.1, size.width * 0.6, size.height * 0.3);
    path1.quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width, size.height * 0.2);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    // Forme 2 : Une autre forme plus petite et plus foncée
    paint.color = Colors.orange.withOpacity(0.5);
    Path path2 = Path();
    path2.moveTo(size.width * 0.1, size.height * 0.6);
    path2.quadraticBezierTo(size.width * 0.3, size.height * 0.4, size.width * 0.5, size.height * 0.55);
    path2.quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width * 0.9, size.height * 0.4);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint);

    // Forme 3 : Une touche de couleur claire en haut
    paint.color = Colors.orange.withOpacity(0.2);
    Path path3 = Path();
    path3.moveTo(0, size.height * 0.1);
    path3.quadraticBezierTo(size.width * 0.2, 0, size.width * 0.4, size.height * 0.2);
    path3.quadraticBezierTo(size.width * 0.6, size.height * 0.4, size.width * 0.8, size.height * 0.1);
    path3.lineTo(size.width, 0);
    path3.lineTo(0, 0);
    path3.close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
