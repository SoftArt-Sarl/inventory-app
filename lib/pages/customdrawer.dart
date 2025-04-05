import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SideMenu extends StatefulWidget {
  final List<Widget> pages;
  const SideMenu({super.key, required this.pages});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    if (apiController.items.isEmpty) {
      apiController.refreshData();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: appTypeController.isDesktop.value
          ? Row(
              children: [
                Container(
                  width: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Affichage du logo et du nom de la compagnie
                          Center(
                            child: Obx(() {
                              final companyInfo =
                                  apiController.companyUserInfo.value;
                              return Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        companyInfo.companyLogo,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return const CircularProgressIndicator();
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.image,
                                                    size: 80,
                                                    color: Colors.grey),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        companyInfo.companyName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          // const SizedBox(height: 10,),
                          _buildMenuItem(
                              FontAwesomeIcons.chartPie, "Dashboard", 0),
                          if (userinfo.authmodel.value.user!.role == 'SELLER')
                            _buildMenuItem(
                                FontAwesomeIcons.shopify, "Purchase", 1),
                          _buildMenuItem(
                              FontAwesomeIcons.cartShopping, "Items", 2),
                          _buildMenuItem(
                              FontAwesomeIcons.layerGroup, "Categories", 3),
                          _buildMenuItem(
                              FontAwesomeIcons.list, "All Invoices", 4),
                          _buildMenuItem(
                              FontAwesomeIcons.truck, "Deliveries", 5),
                          _buildMenuItem(FontAwesomeIcons.gears, "Settings", 6),
                          const Spacer(),
                          const Divider(),
                          InkWell(
                            onTap: () async {
                              await userinfo.logout();
                              apiController.isCategorySelected.value = false;
                              homeController.selectedIndex(0);
                            },
                            child: AbsorbPointer(
                              child: _buildMenuItem(
                                  FontAwesomeIcons.rightFromBracket,
                                  "Sign Out",
                                  10),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Colors.white),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: widget.pages[_selectedIndex],
                  ),
                ),
              ],
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[200],
                elevation: 0,
                title: Text(
                  [
                    "Dashboard",
                    "Shopping cart",
                    "Items",
                    "Categories",
                    "All invoices",
                    "Deliveries",
                    "Settings",
                    "Update password",
                    "Edit profile",
                    "Add new user"
                  ][_selectedIndex],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              drawer: Drawer(
                backgroundColor: Colors.grey[200],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    children: [
                      // Affichage du logo et du nom de la compagnie
                      Center(
                        child: Obx(() {
                          final companyInfo =
                              apiController.companyUserInfo.value;
                          return Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    companyInfo.companyLogo,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return CircularProgressIndicator();
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.image,
                                                size: 80, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    companyInfo.companyName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),

                      _buildMenuItem(FontAwesomeIcons.chartPie, "Dashboard", 0),
                      if (userinfo.authmodel.value.user!.role == 'SELLER')
                        _buildMenuItem(FontAwesomeIcons.shopify, "Purchase", 1),
                      _buildMenuItem(FontAwesomeIcons.cartShopping, "Items", 2),
                      _buildMenuItem(
                          FontAwesomeIcons.layerGroup, "Categories", 3),
                      _buildMenuItem(FontAwesomeIcons.list, "All Invoices", 4),
                      _buildMenuItem(FontAwesomeIcons.truck, "Deliveries", 5),
                      _buildMenuItem(FontAwesomeIcons.gears, "Settings", 6),
                      const Spacer(),
                      const Divider(),
                      InkWell(
                        onTap: () async {
                          await userinfo.logout();
                          apiController.isCategorySelected.value = false;
                          homeController.selectedIndex(0);
                        },
                        child: AbsorbPointer(
                          child: _buildMenuItem(
                              FontAwesomeIcons.rightFromBracket,
                              "Sign Out",
                              10),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.pages[_selectedIndex],
              ),
            ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    return InkWell(
      onTap: () async {
        homeController.selectedIndex(0);
        apiController.isCategorySelected.value = false;
        setState(() {
          _selectedIndex = index;
        });

        if (_pageController.hasClients) {
          await Future.delayed(const Duration(milliseconds: 100));
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }

        if (!appTypeController.isDesktop.value) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _selectedIndex == index ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: _selectedIndex == index
                      ? Colors.orange
                      : Colors.grey[700],
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? Colors.orange
                        : Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
