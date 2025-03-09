import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/apiController.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/controller/historiqueController.dart';
import 'package:flutter_application_1/controller/userInfo.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/pages/ValiderVente.dart';
import 'package:flutter_application_1/pages/coursierPage.dart';
import 'package:flutter_application_1/pages/customdrawer.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:flutter_application_1/pages/gestionProduit.dart';
import 'package:flutter_application_1/pages/loginPage.dart';
import 'package:flutter_application_1/pages/responsiveGrid.dart';
import 'package:flutter_application_1/widget/categoryWidget.dart';
import 'package:flutter_application_1/widget/reusableTable.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:flutter_application_1/widget/tablePage.dart';
import 'package:get/get.dart';

void main() {
  Get.put(Userinfo());
  Get.put(ApiController());
  Get.put(ActionHistoryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Gestion de stock',
            style: TextStyle(fontSize: 18, color: Colors.orange),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(pages: [
      DashboardScreen(),
      const PurchaseValidationPage(),
      TablePage(
        searchBar: const SearchBarWithProfile(),
        header: const Header(
          isCategory: false,
          title: 'Produits',
          buttonText: 'Ajouter un produit',
        ),
        productList: Obx(()=>ReusableTable(
  data: apiController.items.map((element) => element.toJson1(),).toList(),
  onEdit: (context, row) {
    print('Édition : $row');
  },
  onDelete: (context, row) {
    print('Suppression : $row');
  },
)),
        // pagination: Pagination(),
      ),
      TablePageWidget(),
      // CategoryPage(),
      // const Center(child: Text("Stock")),
      const Center(child: Text("Paramètres")),
      const Center(child: Text("Déconnexion")),
    ]);
  }
}

class TablePageWidget extends StatelessWidget {
  final ApiController apiController = Get.find<ApiController>();

  @override
  Widget build(BuildContext context) {
    void getCategories(Category categorie) {
      apiController.categorySelected.value = categorie;
    }

    return Obx(
      () => TablePage(
        searchBar: const SearchBarWithProfile(),
        header: apiController.isCategorySelected.value
            ? const Header1()
            : const Header(
                isCategory: true,
                title: 'Catégories',
                buttonText: 'Ajouter une catégorie',
              ),
        productList: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: ResponsiveGrid(
                  columnsMobile: 1,
                  columnsTablet: 2,
                  runSpacing: 5,
                  columnsDesktop:
                      apiController.isCategorySelected.value ? 1 : 4,
                  spacing: 5,
                  children: apiController.categories
                      .map(
                        (categorie) => InkWell(
                          onTap: () {
                            getCategories(categorie);
                            apiController.isCategorySelected.value = true;
                          },
                          child: CategoryWidget(
                            category: categorie,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const VerticalDivider(),
            if (apiController.isCategorySelected.value)
              Expanded(
                flex: 4,
                child: ReusableTable(
                    data: apiController.items
                        .where((element) =>
                            element.categoryId ==
                            apiController.categorySelected.value.id)
                        .toList().map((e) => e.toJson2(),).toList()),
              )
          ],
        ),
      ),
    );
  }
}
