import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';

class ItemDetailsPage extends StatelessWidget {
  final Map<String, dynamic>? item;

  ItemDetailsPage({ this.item});

  final List<Map<String, dynamic>> history = [
    {
      "action": "Ajouté",
      "date": "2025-03-07T23:48:40.225Z",
      "oldValue": {},
      "newValue": {"name": "iu", "quantity": 42, "unitPrice": 44},
      "user": "Admin",
      "icon": Icons.add_circle,
      "color": Colors.green
    },
    {
      "action": "Retiré",
      "date": "2025-03-08T11:53:01.064Z",
      "oldValue": {"quantity": 42},
      "newValue": {"quantity": 13},
      "user": "Admin",
      "icon": Icons.remove_circle,
      "color": Colors.red
    },
    {
      "action": "Modifié",
      "date": "2025-03-08T15:14:23.998Z",
      "oldValue": {"name": "Sardines", "unitPrice": 900},
      "newValue": {"name": "Boites Sardine", "unitPrice": 100},
      "user": "Admin",
      "icon": Icons.edit,
      "color": Colors.orange
    }
  ];

  String formatDate(String date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // title: Text(
        //   // item["name"],
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Détails de l'élément
            // Card(
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //   elevation: 2,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(item["name"], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            //         SizedBox(height: 8),
            //         Text("Quantité: ${item["quantity"]}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            //         Text("Prix unitaire: ${item["unitPrice"]} FCFA", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),

            // Timeline
            Expanded(
              child: Timeline.tileBuilder(
                theme: TimelineThemeData(
                  indicatorTheme: IndicatorThemeData(size: 30),
                  color: Colors.blue,
                ),
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.before,
                  itemCount: history.length,
                  // itemExtentBuilder: (_, __) => 120,
                  indicatorBuilder: (context, index) {
                    final action = history[index];
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: action["color"],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(action["icon"], color: Colors.white, size: 20),
                    );
                  },
                  connectorBuilder: (_, index, ___) => const DashedLineConnector(),
                  contentsBuilder: (context, index) {
                    final action = history[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    action["action"],
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: action["color"]),
                                  ),
                                  Text(
                                    formatDate(action["date"]),
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              Divider(),
                              Text("👤 Utilisateur: ${action["user"]}", style: TextStyle(color: Colors.grey[800])),
                              SizedBox(height: 4),
                              Text("🔵 Ancienne valeur: ${action["oldValue"].isNotEmpty ? action["oldValue"] : 'N/A'}"),
                              Text("🟢 Nouvelle valeur: ${action["newValue"]}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
