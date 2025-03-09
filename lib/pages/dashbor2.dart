import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.teal[700],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://storage.googleapis.com/a1aa/image/_12pXYzZCDTRxcf_bcwFSrVql4lum41wF0l2MWcQM00.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nirmal Kumar P',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'nirmalcrm100@gmail.com',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildMenuItem(FontAwesomeIcons.tachometerAlt, 'Dashboard'),
                _buildMenuItem(FontAwesomeIcons.boxes, 'Inventory'),
                _buildMenuItem(FontAwesomeIcons.shoppingCart, 'Orders'),
                _buildMenuItem(FontAwesomeIcons.truck, 'Purchase'),
                _buildMenuItem(FontAwesomeIcons.chartLine, 'Reporting'),
                _buildMenuItem(FontAwesomeIcons.headset, 'Support'),
                _buildMenuItem(FontAwesomeIcons.cog, 'Settings'),
                const Spacer(),
                _buildMenuItem(FontAwesomeIcons.signOutAlt, 'Logout'),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Welcome Nirmal!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          _buildIconButton(FontAwesomeIcons.search),
                          _buildIconButton(FontAwesomeIcons.bell),
                          _buildIconButton(FontAwesomeIcons.cog),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Dashboard Cards
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildDashboardCard(
                            FontAwesomeIcons.boxes, '5483', 'Total Products'),
                        _buildDashboardCard(
                            FontAwesomeIcons.shoppingCart, '2859', 'Orders'),
                        _buildDashboardCard(
                            FontAwesomeIcons.cubes, '5483', 'Total Stock'),
                        _buildDashboardCard(
                            FontAwesomeIcons.exclamationTriangle,
                            '38',
                            'Out of Stock',
                            color: Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey[700]),
        onPressed: () {},
      ),
    );
  }

  Widget _buildDashboardCard(IconData icon, String count, String label,
      {Color color = Colors.teal}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(label, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }
}
