// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Saledistrubution.dart';
import 'package:flutter_application_1/pages/customdrawer.dart';
import 'package:flutter_application_1/pages/gestionProduit.dart';
import 'package:flutter_application_1/pages/responsiveGrid.dart';

// GetX imports
import 'package:get/get.dart';

// Controllers
import 'package:flutter_application_1/controller/apiController.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/controller/apptypeController.dart';
import 'package:flutter_application_1/controller/deliveryController.dart';
import 'package:flutter_application_1/controller/historiqueController.dart';
import 'package:flutter_application_1/controller/homeController.dart';
import 'package:flutter_application_1/controller/invoiceController.dart';
import 'package:flutter_application_1/controller/saleController.dart';
import 'package:flutter_application_1/controller/sellerController.dart';
import 'package:flutter_application_1/controller/statisticController.dart';
import 'package:flutter_application_1/controller/userInfo.dart';

// Models
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';

// Pages
import 'package:flutter_application_1/pages/cartPage.dart';
import 'package:flutter_application_1/pages/coursierPage.dart';
import 'package:flutter_application_1/pages/deliveryPage.dart';
import 'package:flutter_application_1/pages/editingUser.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:flutter_application_1/pages/loginPage.dart';
import 'package:flutter_application_1/pages/settingsPage.dart';
import 'package:flutter_application_1/pages/updatePassWord.dart';
import 'package:flutter_application_1/pages/ventesChart.dart';

// Widgets
import 'package:flutter_application_1/widget/categoryWidget.dart';
import 'package:flutter_application_1/widget/reusableTable.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:flutter_application_1/widget/tablePage.dart';

void main() {
  // Initialisation des contrôleurs avec GetX
  Get.put(Userinfo());
  Get.put(ApiController());
  Get.put(ActionHistoryController());
  Get.put(HomeController());
  Get.put(AppTypeController());
  Get.put(UpdatePasswordController());
  Get.put(Sellercontroller());
  Get.put(InvoiceController());
  Get.put(DeliveryController());
  Get.put(SalesController());
  Get.put(StatisticsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Management',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.orange),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: false,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Stock Management',
            style: TextStyle(fontSize: 18, color: Colors.orange),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);

    return SideMenu(
      pages: [
        Obx(() => IndexedStack(
              index: homeController.selectedIndex.value,
              children: [
                const DashboardScreen(),
                _buildItemsTablePage(),
                TablePageWidget(),
                TablePage(
                searchBar: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                          style: IconButton.styleFrom(),
                          onPressed: () {
                            homeController.changeIndex(0);
                          },
                          icon: const Icon(Icons.arrow_back)),
                    ),
                    Expanded(
                      child: Text(
                        "Sales distribution by product 🏷",
                        style: TextStyle(overflow: TextOverflow.ellipsis,
                            fontSize:appTypeController.isDesktop.value? 18:13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    if(appTypeController.isDesktop.value)
                    const Spacer(),
                    if(appTypeController.isDesktop.value)const UserProfile()
                  ],
                ),
                header: const SizedBox.shrink(),
                productList: SalesDistributionChart(
                  isFromDashbord: false,
                ),
                // pagination: Pagination(),
              ),
              TablePage(
                searchBar: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                          style: IconButton.styleFrom(),
                          onPressed: () {
                            homeController.changeIndex(0);
                          },
                          icon: const Icon(Icons.arrow_back)),
                    ),
                    const Text(
                      "Sales statistics 🏷",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    if(appTypeController.isDesktop.value)
                    const Spacer(),
                    if(appTypeController.isDesktop.value)const UserProfile()
                  ],
                ),
                header: const SizedBox.shrink(),
                productList: MonthlySalesChart(
                isFromDashbord: false,
              ),
              )
              ],
            )),
         ShoppingCart(isFromDashbord: false,),
        _buildItemsManagementPage(),
        TablePageWidget(),
        const InvoicePage(),
        DeliveryPage(),
         PasswordChangeScreen(),
      ],
    );
  }

  Widget _buildItemsTablePage() {
    return TablePage(
      searchBar: SearchBarWithFilter(
        originalList: apiController.itemsRupture,
        filteredList: apiController.itemsRupturefilter,
        filterFunction: (item, query) =>
            item.name!.toLowerCase().contains(query.toLowerCase()),
      ),
      header: const Header(
        isCategory: false,
        title: 'Items',
        buttonText: 'Add new Item',
      ),
      productList: Obx(() => ReusableTable(
            data: apiController.itemsRupturefilter
                .map((element) => element.toJson1())
                .toList(),
            onEdit: (context, row) {
              print('Edition : $row');
            },
            onDelete: (context, row) {
              print('Suppression : $row');
            },
          )),
    );
  }

  

  

  Widget _buildItemsManagementPage() {
    return TablePage(
      searchBar: SearchBarWithFilter(
        originalList: apiController.items,
        filteredList: apiController.filteredItems,
        filterFunction: (item, query) =>
            item.name!.toLowerCase().contains(query.toLowerCase()),
      ),
      header: const Header(
        isCategory: false,
        title: 'Items',
        buttonText: 'Add new Item',
      ),
      productList: Obx(() => ReusableTable(
            data: apiController.filteredItems
                .map((element) => element.toJson1())
                .toList(),
            onEdit: (context, row) {
              print('Edition mode : $row');
            },
            onDelete: (context, row) {
              print('Deletion : $row');
            },
          )),
    );
  }

}

class TablePageWidget extends StatefulWidget {
  @override
  State<TablePageWidget> createState() => _TablePageWidgetState();
}

class _TablePageWidgetState extends State<TablePageWidget> {
  final ApiController apiController = Get.find<ApiController>();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    

    return Obx(
      () => TablePage(
        searchBar: SearchBarWithFilter(
          originalList: apiController.categories,
          filteredList: apiController.filteredCategory,
          filterFunction: (item, query) {
            final result =
                item.title!.toLowerCase().contains(query.toLowerCase());
            Future.delayed(Duration.zero, () {
              _searchFocusNode.requestFocus();
            });
            return result;
          },
        ),
        header: apiController.isCategorySelected.value
            ? const Header1()
            : const Header(
                isCategory: true,
                title: 'Categories',
                buttonText: 'Add new Category',
              ),
        productList: appTypeController.isDesktop.value
            ? _buildDesktopView()
            : _buildMobileView(),
      ),
    );
  }
void getCategories(Category categorie) {
      apiController.categorySelected.value = categorie;
    }
  Widget _buildDesktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (!apiController.isCategorySelected.value)
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Obx(() => ResponsiveGrid(
                    columnsMobile: 1,
                    columnsTablet: 2,
                    runSpacing: 5,
                    columnsDesktop:
                        apiController.isCategorySelected.value ? 1 : 3,
                    spacing: 5,
                    children: apiController.filteredCategory
                        .map(
                          (categorie) => InkWell(
                            onTap: () {
                              getCategories(categorie);
                              apiController.isCategorySelected.value = true;
                            },
                            child: CategoryWidget(category: categorie),
                          ),
                        )
                        .toList(),
                  )),
            ),
          ),
        if (apiController.isCategorySelected.value)
          Expanded(
            flex: 4,
            child: ReusableTable(
              data: apiController.items
                  .where((element) =>
                      element.categoryId ==
                      apiController.categorySelected.value.id)
                  .map((e) => e.toJson2())
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildMobileView() {
    if (!apiController.isCategorySelected.value) {
      // Affiche les catégories
      return SingleChildScrollView(
        child: Obx(() => ResponsiveGrid(
              columnsMobile: 1,
              runSpacing: 5,
              spacing: 5,
              children: apiController.filteredCategory
                  .map(
                    (categorie) => InkWell(
                      onTap: () {
                        apiController.categorySelected.value = categorie;
                        apiController.isCategorySelected.value = true;
                      },
                      child: CategoryWidget(category: categorie),
                    ),
                  )
                  .toList(),
            )),
      );
    } else {
      // Affiche la table des items pour la catégorie sélectionnée
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  apiController.isCategorySelected.value = false;
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  apiController.categorySelected.value.title ?? "Items",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ReusableTable(
              data: apiController.items
                  .where((element) =>
                      element.categoryId ==
                      apiController.categorySelected.value.id)
                  .map((e) => e.toJson2())
                  .toList(),
            ),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }
}
Widget getPage(Widget mobilePage, Widget desktopPage) {
  return !appTypeController.isDesktop.value ? mobilePage : desktopPage;
}
