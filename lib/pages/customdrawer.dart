import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';

class SideMenu extends StatefulWidget {
  final List<Widget> pages; // Liste des pages à afficher
  const SideMenu({super.key, required this.pages});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0; // Index de l'élément sélectionné
  late PageController _pageController; // Contrôleur pour gérer la transition entre les pages
  late bool _isDesktop; // Détection si l'écran est un desktop

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
    // Détection de la taille de l'écran pour ajuster le comportement du Drawer
    _isDesktop = MediaQuery.of(context).size.width >= 500; // Si l'écran est plus large que 1024px, considérer comme desktop

    // Liste des titres des éléments du menu pour utilisation dans l'AppBar
    List<String> menuTitles = [
      "Dashboard",
      "Items",
      "Categories",
      "Sign Out",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: _isDesktop
          ? Row(
              children: [
                // Menu latéral permanent
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  width: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildMenuItem(Icons.dashboard, "Dashboard", 0),
                        _buildMenuItem(Icons.shopping_cart, "Items", 1),
                        _buildMenuItem(Icons.dashboard_outlined, "Categories", 2),
                        _buildMenuItem(Icons.logout, "Sign Out", 3),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Colors.white),
                // Zone principale avec les pages et animation de fondu
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
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  menuTitles[_selectedIndex],
                  style: const TextStyle(color: Colors.black),
                ), // Affiche le titre du menu sélectionné dans l'AppBar
              ),
              drawer: Drawer(
                child: Column(
                  children: [
                    _buildMenuItem(Icons.dashboard, "Dashboard", 0),
                    _buildMenuItem(Icons.sell, "Solder", 1),
                    _buildMenuItem(Icons.shopping_cart, "Items", 2),
                    _buildMenuItem(Icons.dashboard_outlined, "Categories", 3),
                    _buildMenuItem(Icons.settings, "Settings", 4),
                    _buildMenuItem(Icons.logout, "Sign Out", 5),
                  ],
                ),
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.pages[_selectedIndex],
              ),
            ),
    );
  }

  // Widget pour chaque élément du menu
  Widget _buildMenuItem(IconData icon, String title, int index) {
    return InkWell(
      onTap: index == 3
          ? () async {
              await userinfo.logout();
              apiController.isCategorySelected.value = false;
              homeController.selectedIndex(0);
              // Déconnexion ou autre action
            }
          : () async {
              homeController.selectedIndex(0);
              apiController.isCategorySelected.value = false;
              setState(() {
                _selectedIndex = index;
              });

              // Vérifiez si le contrôleur est déjà attaché à la page
              if (_pageController.hasClients) {
                // Utilisez animateToPage avec une durée pour une animation fluide
                await Future.delayed(const Duration(milliseconds: 100)); // Ajout d'un petit délai
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }

              if (!_isDesktop) {
                Navigator.of(context).pop(); // Ferme le Drawer si ce n'est pas un desktop
              }
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut, // Courbe de l'animation pour un effet plus fluide
          decoration: BoxDecoration(
            color: _selectedIndex == index ? Colors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: _selectedIndex == index ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? Colors.white
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
