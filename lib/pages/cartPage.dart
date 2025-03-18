import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/customdropdow.dart';
import 'package:get/get.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  String _selectedDeliveryMode = 'Livraison standard';
  bool _isLoading = false; // Indicateur de chargement

  void _updateQuantity(int index, int change) {
    setState(() {
      var item = sellerController.itemsList[index];
      item.quantity = (item.quantity ?? 0) + change;

      if (item.quantity! <= 0) {
        sellerController.itemsList.removeAt(index);
      }
    });
  }

  double get _subtotal => sellerController.itemsList.fold(
      0.0, (sum, item) => sum + ((item.unitPrice ?? 0) * (item.quantity ?? 0)));

  double get _discount => _subtotal * 0.1;

  double get _total => _subtotal - _discount + 50.0;

  int get _totalItems => sellerController.itemsList
      .fold(0, (sum, item) => sum + (item.quantity ?? 0));

  bool isDiscountSelected = false;
  TextEditingController customerName = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(),
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductList(),
                  const VerticalDivider(),
                  Expanded(
                      flex: 3,
                      child: invoiceData != null
                          ? InvoicePagee(invoice: invoiceData!)
                          : _buildInformation()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Center(
            child: Text('Shopping Cart',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            }, children: [
              _buildTableHeader()
            ]),
            const SizedBox(height: 2),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                    )),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    children: sellerController.itemsList
                        .asMap()
                        .entries
                        .map(
                            (entry) => _buildProductRow(entry.key, entry.value))
                        .toList(),
                  ),
                ),
              ),
            ),
            _buildAddItemDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemDropdown() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: ReusableMultiSelectSearchDropdown(
          hintText: 'Cliquez ici pour ajouter des items',
          items: apiController.items.map((element) => element.name!).toList(),
          onPressed: (items) {
            sellerController.addTocar(items);
          }),
    );
  }

  Widget _buildInformation() {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 5,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: const Text(
                'Information de vente',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            _buildTextField(
              hintext: 'exp:Ousmane Barke',
              label: 'Nom du client',
              icon: Icons.title_outlined,
              controller: customerName,
            ),
            _buildTextField(
              hintext: 'exp: Niamey,Cité Salou djibo',
              label: 'Adresse du client',
              icon: Icons.home_outlined,
              controller: customerAddress,
            ),
            Row(
              children: [
                Checkbox(
                  value: isDiscountSelected,
                  onChanged: (value) {
                    setState(() {
                      isDiscountSelected = value!;
                    });
                  },
                ),
                const Text(
                  'Avec réduction ?',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (isDiscountSelected)
              _buildTextField(
                hintext: 'exp:3500',
                label: 'Réduction',
                icon: Icons.discount_outlined,
                controller: discountController,
              ),
            const Divider(),
            _buildOrderSummary()
          ],
        ),
      ),
    );
  }

  Future<String?> createSale({
    String? customerName,
    String? customerAddress,
    int? discount,
    List<Map<String, dynamic>>? items,
  }) async {
    final Dio _dio = Dio();
    setState(() {
      _isLoading = true; // Arrêter le chargement
    });
    try {
      final Map<String, dynamic> data = {
        'custumerName': customerName,
        'custumerAddress': customerAddress,
        if (discount != null) 'discount': discount,
        'items': items ?? [],
      };

      final response = await _dio.post(
        'https://inventory-app-five-ebon.vercel.app/sales',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
          },
        ),
      );
      setState(() {
        _isLoading = false; // Arrêter le chargement
      });

      // Vérifie si la réponse contient l'id de la vente dans 'sale'
      if (response.statusCode == 200 || response.statusCode == 201) {
        final saleId = response.data['sale']['id']; // Récupère l'id de la vente
        return saleId;
      }
      return null;
      // Si la réponse n'est pas un succès
    } on DioException catch (e) {
      setState(() {
        _isLoading = false; // Arrêter le chargement
      });
      throw Exception(' ${e.response?.data['message']}');
    }
  }

  Invoice? invoiceData;
  Future<void> getInvoicesForSale(String saleId) async {
    final Dio _dio = Dio();

    try {
      final response = await _dio.get(
        'https://inventory-app-five-ebon.vercel.app/sales/$saleId/invoices',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
          },
        ),
      );
      Invoice invoice = Invoice.fromMap(response.data);
      setState(() {
        invoiceData = invoice;
      });
     await apiController.refreshData();
      // Affiche la réponse (les factures) dans la console ou traite-la comme nécessaire
      print('voici la facture :${response.data}');
    } on DioException catch (e) {
      throw Exception(' ${e.response?.data['message']}');
    }
  }

  void createAndFetchInvoices() async {
    String? saleId = await createSale(
      customerName: customerName.text.trim(),
      customerAddress: customerAddress.text.trim(),
      discount: isDiscountSelected ? int.parse(discountController.text) : null,
      items: sellerController.itemsList
          .map(
            (element) => element.toJson3(),
          )
          .toList(),
    );

    if (saleId != null) {
      print("Vente créée avec succès ! Sale ID: $saleId");
      // Maintenant, récupère les factures pour cette vente
      await getInvoicesForSale(saleId);
    } else {
      print("Échec de la création de la vente");
    }
  }

  Widget _buildOrderSummary() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Total Items', '$_totalItems items'),
          _buildSummaryRow(
              'Sous-total', '${_subtotal.toStringAsFixed(0)} FCFA'),
          if (isDiscountSelected)
            _buildSummaryRow(
                'Réduction (10%)', '-${_discount.toStringAsFixed(0)} FCFA'),
          const Divider(),
          _buildSummaryRow('Total', '${_total.toStringAsFixed(0)} FCFA',
              isBold: true),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isLoading ? null : createAndFetchInvoices,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16)),
          Text(value,
              style: TextStyle(
                  color: isBold ? Colors.red : Colors.black,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hintext,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Ce champ est requis";
              }
              return null;
            },
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              hintText: hintext,
              fillColor: Colors.grey[250],
              prefixIcon: Icon(icon, color: Colors.orange),
              border: InputBorder.none,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      children: [
        Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Text('Nom du produit', style: TextStyle(color: Colors.white))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text('Prix unitaire',
                    style: TextStyle(color: Colors.white)))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child:
                    Text('Quantité', style: TextStyle(color: Colors.white)))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text('Total', style: TextStyle(color: Colors.white)))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text('Action', style: TextStyle(color: Colors.white)))),
      ],
    );
  }

  TableRow _buildProductRow(int index, dynamic product) {
    int total = (product.unitPrice ?? 0) * (product.quantity ?? 0);
    return TableRow(
      decoration: BoxDecoration(
          color: Colors.grey[230],
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(product.name ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.normal)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text('${(product.unitPrice ?? 0).toStringAsFixed(0)}')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _updateQuantity(index, -1),
                  icon: const Icon(Icons.remove),
                ),
                Text('${product.quantity ?? 0}'),
                IconButton(
                  onPressed: () => _updateQuantity(index, 1),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(total.toStringAsFixed(0))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: IconButton(
              style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
              icon: const Icon(
                Icons.close,
              ),
              onPressed: () => _updateQuantity(index, -(product.quantity ?? 0)),
            ),
          ),
        ),
      ],
    );
  }
}
