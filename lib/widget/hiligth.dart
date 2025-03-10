import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final Color highlightColor;

  const HighlightedText({
    Key? key,
    required this.text,
    required this.query,
    this.highlightColor = const Color(0xFFFFD54F), // Jaune clair par défaut
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text);

    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int startIndex = lowerText.indexOf(lowerQuery);
    if (startIndex == -1) return Text(text);

    int endIndex = startIndex + lowerQuery.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              color: Colors.black,
              backgroundColor: highlightColor.withOpacity(0.2),
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
