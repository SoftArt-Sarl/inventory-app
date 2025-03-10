import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomNumberInput({
    Key? key,
    required this.controller,
    this.hintText = 'Quantité',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // N'accepte que des chiffres
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.grey[200],
          filled: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}