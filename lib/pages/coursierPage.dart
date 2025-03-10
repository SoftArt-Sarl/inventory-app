import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/models.dart/historiqueModel.dart';
import 'package:flutter_application_1/pages/gestionProduit.dart';
import 'package:flutter_application_1/pages/responsiveGrid.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/categoryWidget.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:flutter_application_1/widget/reusableTable.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_grid/simple_grid.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(
              height: 5,
            ),
            ResponsiveGrid(
              columnsMobile: 1,
              columnsTablet: 2,
              runSpacing: 5,
              columnsDesktop: 4,
              spacing: 0,
              children: [
                Obx(() => _buildCard(
                    FontAwesomeIcons.box,
                    'Produits',
                    '${Item.calculateTotalQuantity(apiController.items)} Articles',
                    Colors.green, () {
                  
                }),),
                Obx(() => _buildCard(
                    FontAwesomeIcons.layerGroup,
                    'Catégories',
                    '${apiController.categories.length} Catégories',
                    Colors.blue,
                    () {
                      homeController.changeIndex(2);
                    }),),
                Obx(
                  () => _buildCard(
                      FontAwesomeIcons.exclamationTriangle,
                      'Produits en Rupture',
                      '${Item.getOutOfStockItems(apiController.itemsRupture).length} Articles',
                      Colors.red,
                      () {
                        homeController.changeIndex(1);
                      }),
                ),
                _buildCard(
                    FontAwesomeIcons.euroSign,
                    'Valeur Totale du Stock',
                    '${Item.calculateTotalValue(apiController.items).toString()} FCFA',
                    Colors.purple,
                    () {}),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 3, child: HistoriqueSection()),
                  const Expanded(
                      flex: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        color: Colors.white,
                        child: SizedBox(
                          height: double.infinity,
                          child: SingleChildScrollView(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [ButtonList()],
                          )),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String value, Color color,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Construire les lignes du tableau
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            'Tableau de bord',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          // UserProfile(),
        ],
      ),
    );
  }
}

class HistoriqueSection extends StatelessWidget {
  final buttonKey1 = GlobalKey();

  HistoriqueSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Faire un stok',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              isDense: true,
                              hintText: 'Rechercher un produit ou un achat',
                              border: InputBorder.none
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await apiController.refreshData();
                        },
                        icon: const Icon(
                          Icons.refresh_outlined,
                          color: Colors.orange,
                        ))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
                child: Obx(() => ActionHistoryPage(
                      // ignore: invalid_use_of_protected_member
                      actionItems: apiController.historiques.value,
                    )))
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, String count, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return IconButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
      ),
      icon: Icon(icon),
    );
  }
}

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
    return Column(
      children: [
        if (_selectedForm == null) ...[
          _buildDashboardButton(
            context,
            icon: Icons.add_shopping_cart,
            label: "Ajouter un stock",
            color: Colors.green,
            onTap: () => showForm(const AjouterStockForm()),
          ),
          _buildDashboardButton(
            context,
            icon: Icons.remove_shopping_cart,
            label: "Retirer un stock",
            color: Colors.blue,
            onTap: () => showForm(const RetirerStockForm()),
          ),
          _buildDashboardButton(
            context,
            icon: Icons.add_box,
            label: "Ajouter un produit",
            color: Colors.orange,
            onTap: () => showForm(AddProduitForm(
              isHistoriquePage: true,
            )),
          ),
          _buildDashboardButton(
            context,
            icon: Icons.edit,
            label: "Modifier un produit",
            color: Colors.teal,
            onTap: () => showForm(UpdateItemForm(
              isHistoriquePage: true,
            )),
          ),
          // _buildDashboardButton(
          //   context,
          //   icon: Icons.delete,
          //   label: "Supprimer un produit",
          //   color: Colors.red,
          //   onTap: () {},
          // ),
          _buildDashboardButton(
            context,
            icon: Icons.category,
            label: "Ajouter une catégorie",
            color: Colors.purple,
            onTap: () => showForm(CategoryForm(
              isHistoriquePage: true,
            )),
          ),
          // _buildDashboardButton(
          //   context,
          //   icon: Icons.edit_attributes,
          //   label: "Modifier une catégorie",
          //   color: Colors.deepOrange,
          //   onTap: () {},
          // ),
          // _buildDashboardButton(
          //   context,
          //   icon: Icons.delete_forever,
          //   label: "Supprimer une catégorie",
          //   color: Colors.redAccent,
          //   onTap: () {},
          // ),
          // _buildDashboardButton(
          //   context,
          //   icon: Icons.search,
          //   label: "Rechercher un produit/catégorie",
          //   color: Colors.indigo,
          //   onTap: () {},
          // ),
          // _buildDashboardButton(
          //   context,

          //   icon: Icons.list,
          //   label: "Voir la liste des produits",
          //   color: Colors.brown,
          //   onTap: () {},
          // ),
          // _buildDashboardButton(
          //   context,
          //   icon: Icons.history,
          //   label: "Historique des stocks",
          //   color: Colors.grey,
          //   onTap: () {},
          // ),
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
          backgroundColor: Colors.white,
          elevation: 2,
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

class ActionHistoryPage extends StatelessWidget {
  final List<ActionItem> actionItems;

  ActionHistoryPage({super.key, required this.actionItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: actionItems.length,
      itemBuilder: (context, index) {
        final action = actionItems[index];
        return TimelineTile(
          alignment: TimelineAlign.start,
          indicatorStyle: IndicatorStyle(
            width: 30,
            color: action.actionColor,
            iconStyle: IconStyle(
              iconData: action.actionIcon,
              color: Colors.white,
            ),
          ),
          beforeLineStyle: LineStyle(color: action.actionColor),
          endChild: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      action.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm')
                          .format(action.createdAt!),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  action.details,
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider()
              ],
            ),
          ),
        );
      },
    );
  }
}
