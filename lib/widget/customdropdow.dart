import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class ReusableSearchDropdown extends StatelessWidget {
  final List<String> items;
  final void Function(String?) onPressed;
  final String hintText;

  const ReusableSearchDropdown({
    Key? key,
    required this.items,
    required this.onPressed,
    this.hintText = 'Search options',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      decoration: CustomDropdownDecoration(
          searchFieldDecoration: const SearchFieldDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.orange)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.orange))),
          listItemStyle: const TextStyle(fontSize: 15),
          closedFillColor: Colors.grey[200],
          hintStyle: TextStyle(color: Colors.grey[250]),
          listItemDecoration:
              const ListItemDecoration(highlightColor: Colors.blue)),
      hintText: hintText,
      closedHeaderPadding:
          const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
      items: items,
      onChanged: onPressed,
    );
  }
}
