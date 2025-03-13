import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  final RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isValidPassword(String password) {
    final RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$');
    return regex.hasMatch(password);
  }

  void updatePassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await ApiService().updatePassword(passwordController.text.trim());
      Get.snackbar(
        'Success', 
        'Your password has been updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      passwordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Sorry, something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final UpdatePasswordController controller = Get.put(UpdatePasswordController());
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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
            return "This field is requierd";
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

  @override
  Widget build(BuildContext context) {
    return Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'New password',
                icon: Icons.lock,
                controller: controller.passwordController,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                
                label: 'Confirm password',
                icon: Icons.lock,
                controller: controller.confirmPasswordController,
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[600],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                      onPressed: controller.isLoading.value ? null : controller.updatePassword,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Update'),
                    ),
                  )),
            ],
          ),
        );
  }
}

