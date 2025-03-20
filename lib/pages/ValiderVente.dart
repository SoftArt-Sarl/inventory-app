import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/responsiveGrid.dart';


class PurchaseValidationPage extends StatelessWidget {
  const PurchaseValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation de l\'achat'),
        actions: [
          TextButton(
            onPressed: () {
              // Action pour "Nouvelle vente"
            },
            child: const Text(
              'Nouvelle vente',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Informations de l'acheteur
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations de l\'acheteur',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ResponsiveGrid(columnsDesktop: 3,children: [const TextField(
                      decoration: InputDecoration(
                        labelText: 'Nom du client (facultatif)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Téléphone ou Email (optionnel)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Mode de paiement',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Espèces',
                        'Carte bancaire',
                        'Mobile Money',
                        'Virement',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),])
                  ],
                ),
              ),
        
              // Zone de saisie des articles
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Articles',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    DataTable(
                      columns:const  [
                         DataColumn(label: Text('Référence')),
                         DataColumn(label: Text('Produit')),
                         DataColumn(label: Text('Prix unitaire')),
                         DataColumn(label: Text('Quantité')),
                         DataColumn(label: Text('Total')),
                         DataColumn(label: Text('Actions')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('12345')),
                          const DataCell(Text('Sac de riz 25kg')),
                          const DataCell(Text('12 000 FCFA')),
                          DataCell(
                            SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                ),
                                controller: TextEditingController(text: '2'),
                              ),
                            ),
                          ),
                          const DataCell(Text('24 000 FCFA')),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Action pour supprimer l'article
                              },
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('67890')),
                          const DataCell(Text('Bouteille d\'huile 5L')),
                          const DataCell(Text('8 500 FCFA')),
                          DataCell(
                            SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                ),
                                controller: TextEditingController(text: '1'),
                              ),
                            ),
                          ),
                          const DataCell(Text('8 500 FCFA')),
                          DataCell(
                            IconButton(
                              icon: const Icon (Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Action pour supprimer l'article
                              },
                            ),
                          ),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Action pour ajouter un produit
                      },
                      child: const Text('Ajouter un produit'),
                    ),
                  ],
                ),
              ),
        
              // Récapitulatif du paiement
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Récapitulatif du paiement',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total des articles :'),
                            Text('32 500 FCFA'),
                          ],
                        ),
                        const SizedBox(height: 8),
                       const  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text('Remise (optionnelle) :'),
                            SizedBox(
                              width: 80,
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: '-XX FCFA',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Taxes (si applicable) :'),
                            Container(
                              width: 80,
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: '+XX FCFA',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Montant final à payer :', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('32 500 FCFA', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        
              // Boutons d'action
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Action pour valider et encaisser
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Confirm the sale'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action pour enregistrer en attente
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                      child: const Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action pour annuler la vente
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Cancel sale'),
                    ),
                  ],
                ),
              ),
        
              // Option de réception du reçu
              // Cette section peut être implémentée avec un dialogue ou un autre widget selon les besoins
            ],
          ),
        ),
      ),
    );
  }
}