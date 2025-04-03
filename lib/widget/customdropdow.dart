import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';

import '../models.dart/Item.dart';

class ReusableSearchDropdown extends StatelessWidget {
  final List<String> items;
  final void Function(String?) onPressed;
  final String hintText;

  const ReusableSearchDropdown({
    super.key,
    required this.items,
    required this.onPressed,
    this.hintText = 'Search options',
  });

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
          closedFillColor: Colors.white,
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

class MultiSelectDropdownButton extends StatefulWidget {
  final List<Item> items;
  final void Function(List<Item>) onPressed;
  final String hintText;

  const MultiSelectDropdownButton({
    super.key,
    required this.items,
    required this.onPressed,
    this.hintText = 'Search and select options',
  });

  @override
  State<MultiSelectDropdownButton> createState() =>
      _MultiSelectDropdownButtonState();
}

class _MultiSelectDropdownButtonState extends State<MultiSelectDropdownButton> {
  List<Item> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide.none, backgroundColor: Colors.white),
          onPressed: () {
            _showDropdownMenu(context);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Add product"),
            ],
          ),
        ),
      ],
    );
  }

  void _showDropdownMenu(BuildContext context) async {
  List<Item> tempSelection = List.from(sellerController.itemsList);
  List<Item> filteredItems = List.from(widget.items);
  TextEditingController searchController = TextEditingController();

  final List<Item>? results = await showDialog<List<Item>>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            backgroundColor: Colors.grey[200],
            title: const Text("Select items"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                // Barre de recherche
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "Search...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onChanged: (query) {
                      setDialogState(() {
                        filteredItems = widget.items
                            .where((item) => item.name!
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Liste avec les Checkboxes
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: filteredItems
                          .map((item) => Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(bottom: 4),
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                                  title: Text(item.name!),
                                  subtitle: Text('Quantity : ${item.quantity}'),
                                  value: tempSelection.any((e) => e.id == item.id),
                                  onChanged: (isChecked) {
                                    setDialogState(() {
                                      if (isChecked == true) {
                                        tempSelection.add(item);
                                      } else {
                                        tempSelection.removeWhere((e) => e.id == item.id);
                                      }
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, tempSelection),
                child: const Text("Valider"),
              ),
            ],
          );
        },
      );
    },
  );

  if (results != null) {
    setState(() {
      selectedItems = results;
      widget.onPressed(selectedItems);
    });
  }
}

}

class ReusableMultiSelectSearchDropdown extends StatelessWidget {
  final List<String> items;
  final void Function(List<String>) onPressed;
  final String hintText;

  const ReusableMultiSelectSearchDropdown({
    super.key,
    required this.items,
    required this.onPressed,
    this.hintText = 'Search and select options',
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.multiSelectSearch(
      headerListBuilder: (context, selectedItems, enabled) =>
          const Text('Ajouter des items au panier'),
      closedHeaderPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const CustomDropdownDecoration(
        // prefixIcon: const Icon(Icons.add),
        closedSuffixIcon: Icon(Icons.add),
        expandedSuffixIcon: SizedBox.shrink(),
        // closedBorder: Border.all(color: Colors.orange),
        hintStyle: TextStyle(color: Colors.black),
        closedFillColor: Colors.white,
        // closedBorder: Border.symmetric(horizontal: BorderSide(color: Colors.orange),vertical: BorderSide(color: Colors.orange))
      ),
      hintText: hintText,
      items: items,
      canCloseOutsideBounds: true,
      onListChanged: onPressed,
    );
  }
}
