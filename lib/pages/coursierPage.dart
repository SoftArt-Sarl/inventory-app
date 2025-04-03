import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/models.dart/historiqueModel.dart';
import 'package:flutter_application_1/pages/Saledistrubution.dart';
import 'package:flutter_application_1/pages/deliveryPage.dart';
import 'package:flutter_application_1/pages/gestionProduit.dart';
import 'package:flutter_application_1/pages/responsiveGrid.dart';
import 'package:flutter_application_1/pages/ventesChart.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/buttonlist.dart';
import 'package:flutter_application_1/widget/categoryWidget.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:flutter_application_1/widget/reusableTable.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:flutter_application_1/widget/shopincarDialog.dart';
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.all(appTypeController.isDesktop.value ? 5 : 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appTypeController.isDesktop.value) const _HeaderSection(),
            // const SizedBox(height: 10),
            const _DashboardGrid(),
            // const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  const Expanded(flex: 3, child: HistoriqueSection()),
                  if (appTypeController.isDesktop.value &&
                      userinfo.authmodel.value.user!.role != 'SELLER')
                    const Expanded(flex: 1, child: _Sidebar()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (!appTypeController.isDesktop.value &&
        userinfo.authmodel.value.user!.role == 'ADMIN') {
      return FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showButtonListBottomSheet(context),
      );
    }
    return const SizedBox
        .shrink(); // Ne rien afficher si ce n'est pas un mobile
  }

  void _showButtonListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.grey[200],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => const Padding(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 50),
        child: ButtonList(),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Ajoutez ici les widgets pour l'en-tête
        const Text('Dashbord', style: TextStyle(fontSize: 20)),
        const SizedBox(
          width: 20,
        ),
        IconButton(
            onPressed: () async {
              await apiController.refreshData();
            },
            icon: const Icon(Icons.refresh, color: Colors.orange)),
        const Spacer(), const UserProfile()
      ],
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ResponsiveGrid(
        columnsMobile: 2,
        columnsTablet: 4,
        columnsDesktop: 4,
        runSpacing: 0,
        spacing: 0,
        children: [
          Obx(() => _DashboardCard(
                icon: Icons.inventory,
                title: 'Items',
                value:
                    '${Item.calculateTotalQuantity(apiController.items)} products',
                color: Colors.green,
                onTap: () {},
              )),
          Obx(() => _DashboardCard(
                icon: Icons.category,
                title: 'Categories',
                value: '${apiController.categories.length} Categories',
                color: Colors.blue,
                onTap: () => homeController.changeIndex(2),
              )),
          Obx(() => _DashboardCard(
                icon: Icons.warning,
                title: 'Almost out of stock',
                value:
                    '${Item.getOutOfStockItems(apiController.itemsRupture).length} Products',
                color: Colors.red,
                onTap: () => homeController.changeIndex(1),
              )),
          Obx(() => _DashboardCard(
                icon: Icons.euro,
                title:
                    '${DateFormat('dd/MM/yyyy').format(salesController.selectedRange.value!.start)} -${DateFormat('dd/MM/yyyy').format(salesController.selectedRange.value!.end)}',
                value: salesController.totalSales.value,
                color: Colors.purple,
                onTap: () => salesController.pickDateRange(context),
                // extra: salesController.selectedRange.value != null
                //     ? Text(
                //         '${DateFormat('dd/MM/yyyy').format(salesController.selectedRange.value!.start)} - '
                //         '${DateFormat('dd/MM/yyyy').format(salesController.selectedRange.value!.end)}',
                //       )
                //     : const Text('Sélectionnez une période'),
              )),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;
  final Widget? extra;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = appTypeController.isDesktop.value;

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: isDesktop ? 16 : 10,
          ),
          child: Row(
            mainAxisAlignment:
                isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(icon, size: isDesktop ? 25 : 20, color: color),
              SizedBox(width: isDesktop ? 10 : 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: isDesktop ? 15 : 10),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    if (extra != null) extra!,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      // color: Colors.transparent,
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonList(),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoriqueSection extends StatefulWidget {
  const HistoriqueSection({super.key});

  @override
  State<HistoriqueSection> createState() => _HistoriqueSectionState();
}

class _HistoriqueSectionState extends State<HistoriqueSection> {
  final buttonKey1 = GlobalKey();
  bool showAll = false; // Variable pour gérer l'affichage
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<DateTimeRange?> selectedRange = Rx<DateTimeRange?>(null);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      color: !showAll ? Colors.transparent : Colors.white,
      child: Column(
        children: [
          if (showAll) _buildHeader(),
          Expanded(
            child: Obx(() {
              if (apiController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (apiController.historiques.isEmpty) {
                return const Center(child: Text("Données non récupérées"));
              }
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (!showAll) _buildCharts(),
                    _buildActionHistoryCard(),
                    if (!showAll &&
                        deliveryController.deliveries.isNotEmpty &&
                        userinfo.authmodel.value.user!.role == 'SELLER')
                      _buildDeliveryCard(),
                    if (!showAll &&
                        apiController.itemsRupture.isNotEmpty &&
                        userinfo.authmodel.value.user!.role == 'ADMIN')
                      _buildOutOfStockCard(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Actions history',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Text(showAll ? 'Réduire' : 'Voir plus'),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }

  Widget _buildCharts() {
    return SizedBox(
      width: double.infinity,
      child: ResponsiveGrid(
        runSpacing: 0,
        columnsTablet: 2,
        spacing: 0,
        columnsDesktop: 2,
        columnsMobile: 1,
        children: [
          SizedBox(
            height: 200,
            child: MonthlySalesChart(isFromDashbord: true),
          ),
          SizedBox(
            height: 200,
            child: SalesDistributionChart(isFromDashbord: true),
          ),
        ],
      ),
    );
  }

  Widget _buildActionHistoryCard() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showAll)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Actions history',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAll = !showAll;
                      });
                    },
                    child: Text(showAll ? 'Réduire' : 'Voir plus'),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            ActionHistoryPage(
              itemCount: showAll ? apiController.historiques.length : 3,
              actionItems: apiController.historiques,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DeliveryListView(
              itemlenght: 4,
              invoiceController: invoiceController,
              selectedDate: selectedDate,
              selectedRange: selectedRange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutOfStockCard() {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Out of stock',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Get.defaultDialog(
                          backgroundColor: Colors.grey[200],
                          title: 'Add muptiple',
                          content: AjouterStockFormmultiple(
                            itemNames: apiController.itemsRupture
                                .map(
                                  (element) => element.name!,
                                )
                                .toList(),
                          ));
                    },
                    child: const Text('add stock for all +')),
              ],
            ),
            const Divider(),
            // const SizedBox(height: 10),
            ReusableTable(
              isFromDashbord: true,
              data: apiController.itemsRupture
                  .map((element) => element.toJson1())
                  .toList(),
              onEdit: (context, row) {
                print('Édition : $row');
              },
              onDelete: (context, row) {
                print('Suppression : $row');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ActionHistoryPage extends StatelessWidget {
  final List<ActionItem> actionItems;
  final int? itemCount;

  const ActionHistoryPage(
      {super.key, required this.actionItems, this.itemCount});

  @override
  Widget build(BuildContext context) {
    final int displayCount =
        (itemCount == null || actionItems.length < itemCount!)
            ? actionItems.length
            : itemCount!;

    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Désactiver le scroll interne
      itemCount: displayCount,
      itemBuilder: (context, index) {
        final action = actionItems[index];
        return Column(
          children: [
            TimelineTile(
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
                padding: const EdgeInsets.all(8.0),
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
                    Text(action.details, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(action.user!.name,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
