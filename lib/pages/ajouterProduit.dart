import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/responsiveGrid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class AjouterProduitPage extends StatefulWidget {

  AjouterProduitPage({super.key});

  @override
  State<AjouterProduitPage> createState() => _AjouterProduitPageState();
}

class _AjouterProduitPageState extends State<AjouterProduitPage> {
  final TextEditingController referenceController = TextEditingController();

  final TextEditingController nomController = TextEditingController();

  final TextEditingController quantiteController = TextEditingController();

  final TextEditingController prixController = TextEditingController();

  String? selectedCategorie;

  String? selectedStatut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Card( 
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add new Item',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ResponsiveGrid(runSpacing: 0,spacing: 5,
                    columnsDesktop: 2,
                    children: [
                      _buildTextField(referenceController, 'Référence', 'Référence du produit'),
                      _buildTextField(nomController, 'Item title', 'Item title'),
                      _buildNumberField(quantiteController, 'Quantity', 'Quantity'),
                      _buildNumberField(prixController, 'Unit Price', 'Unit Price', isDecimal: true),
                      _buildDropdownField(
                        'Catégorie',
                        ['Sélectionner une catégorie', 'Électronique', 'Alimentation', 'Vêtements'],
                        (value) {
                          selectedCategorie = value;
                        },
                      ),
                      _buildDropdownField(
                        'Statut',
                        ['Sélectionner un statut', 'Disponible', 'En rupture', 'Réservé'],
                        (value) {
                          selectedStatut = value;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                        backgroundColor: Colors.orange),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Action pour ajouter un produit
                                    },
                                    child: const Text('Ajouter',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Action pour ajouter un produit
                                    },
                                    child: const Text('Annuler',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label, String hint, {bool isDecimal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isDecimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(filled: true,
        fillColor: Colors.white,
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
void showAjouterProduitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Arrondir les coins du dialog
        ),
        child: Container( 
          width: MediaQuery.of(context).size.width * 0.6, // 80% de la largeur de l'écran
          child: AjouterProduitPage(),
        ),
      );
    },
  );
}