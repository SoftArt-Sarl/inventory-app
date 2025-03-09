import 'package:flutter/material.dart';

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ajouter une catégorie',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        // Category name i
        Text('Nom de la catégorie',
            style: TextStyle(
                color: Colors.grey[700], fontWeight: FontWeight.bold)),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Nom de la catégorie',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        const SizedBox(height: 16),
        // Category description input
        Text('Description de la catégorie',
            style: TextStyle(
                color: Colors.grey[700], fontWeight: FontWeight.bold)),
        const TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Description de la catégorie',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        const SizedBox(height: 16),
        // Add products section
        // const Text('Ajouter des produits',
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        // const SizedBox(height: 8),
        // Row(
        //   children: [
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text('Nom du produit',
        //               style: TextStyle(
        //                   color: Colors.grey[700],
        //                   fontWeight: FontWeight.bold)),
        //           const TextField(
        //             decoration: InputDecoration(
        //               hintText: 'Nom du produit',
        //               border: OutlineInputBorder(),
        //               contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text('Prix du produit',
        //               style: TextStyle(
        //                   color: Colors.grey[700],
        //                   fontWeight: FontWeight.bold)),
        //           const TextField(
        //             decoration: InputDecoration(
        //               hintText: 'Prix du produit',
        //               border: OutlineInputBorder(),
        //               contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text('Stock du produit',
        //               style: TextStyle(
        //                   color: Colors.grey[700],
        //                   fontWeight: FontWeight.bold)),
        //           const TextField(
        //             decoration: InputDecoration(
        //               hintText: 'Stock du produit',
        //               border: OutlineInputBorder(),
        //               contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 16),
        // Add category button
        ElevatedButton(
          onPressed: () {
            // Action to add category
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text('Ajouter la catégorie'),
        ),
      ],
    );
  }
}
