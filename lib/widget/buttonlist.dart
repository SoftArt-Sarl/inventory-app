import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/pages/gestionProduit.dart';
import 'package:flutter_application_1/widget/reusableTable.dart';

class ButtonList extends StatefulWidget {
  const ButtonList({super.key});

  @override
  State<ButtonList> createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
  Widget? _selectedForm;

  void showForm(Widget form) {
    setState(() {
      _selectedForm = form;
    });
  }

  void goBack() {
    setState(() {
      _selectedForm = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SizedBox(
            child: Text(
              'Shortcuts',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ),
          if (_selectedForm == null &&
              userinfo.authmodel.value.user!.role == "ADMIN") ...[
            _buildDashboardButton(
              context,
              icon: Icons.add_shopping_cart,
              label: "Add to an item",
              color: Colors.green,
              onTap: () => showForm(const AjouterStockForm()),
            ),
            _buildDashboardButton(
              context,
              icon: Icons.remove_shopping_cart,
              label: "Remove an item",
              color: Colors.blue,
              onTap: () => showForm(const RetirerStockForm()),
            ),
            _buildDashboardButton(
              context,
              icon: Icons.add_box,
              label: "Add a new item",
              color: Colors.orange,
              onTap: () => showForm(AddProduitForm(
                isdektop: appTypeController.isDesktop.value,
                isHistoriquePage: true,
              )),
            ),
            _buildDashboardButton(
              context,
              icon: Icons.edit,
              label: "Edit an item",
              color: Colors.teal,
              onTap: () => showForm(UpdateItemForm(
                isHistoriquePage: true,
              )),
            ),
            _buildDashboardButton(
              context,
              icon: Icons.category,
              label: "Add a new category",
              color: Colors.purple,
              onTap: () => showForm(CategoryForm(
                isHistoriquePage: true,
              )),
            ),
          ] else ...[
            // Bouton de retour
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: goBack,
              ),
            ),
            // Affichage du formulaire sélectionné
            _selectedForm!,
          ],
        ],
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}