import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/customdropdow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool _isLoading = false; // Indicateur de chargement
  String? discount;
  bool isDiscountSelected = false;

  // Contrôleurs de texte
  TextEditingController customerName = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController discountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductList(),
                const VerticalDivider(),
                Obx(
                  () => Expanded(
                    flex: 3,
                    child: invoiceController.selectedInvoice.value != null
                        ? Card(
                            shape: const RoundedRectangleBorder(),
                            child: InvoicePagee(
                              isDeliveryPage: false,
                              invoice: invoiceController.selectedInvoice.value!,
                            ),
                          )
                        : _buildInformation(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // **Méthodes de construction des widgets**

  Widget _buildProductList() {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(),
            const SizedBox(height: 2),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: Column(
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

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCell(child: _buildHeaderCell('Product', FontAwesomeIcons.cogs)),
          _buildCell(
              child: _buildHeaderCell('Unit price', FontAwesomeIcons.tag)),
          _buildCell(
              child: _buildHeaderCell(
                  'Quantity', FontAwesomeIcons.sortAmountUpAlt)),
          _buildCell(
              child: _buildHeaderCell('Total', FontAwesomeIcons.calculator)),
          _buildCell(
              child: _buildHeaderCell('Action', FontAwesomeIcons.trashAlt)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(icon, color: Colors.black, size: 13),
        const SizedBox(width: 3),
        Text(title, style: const TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildProductRow(int index, dynamic product) {
    int total = (product.unitPrice ?? 0) * (product.quantity ?? 0);
    return Card(
      elevation: 0,
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCell(
              child: Text(product.name ?? 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.normal))),
          _buildCell(
              child: Text('${(product.unitPrice ?? 0).toStringAsFixed(0)}')),
          _buildCell(child: _buildQuantityControls(index, product)),
          _buildCell(child: Text(total.toStringAsFixed(0))),
          _buildCell(child: _buildRemoveButton(index, product)),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(int index, dynamic product) {
    return Row(
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
    );
  }

  Widget _buildRemoveButton(int index, dynamic product) {
    return IconButton(
      style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
      icon: const Icon(Icons.close),
      onPressed: () => _updateQuantity(index, -(product.quantity ?? 0)),
    );
  }

  Widget _buildCell({required Widget child}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: child,
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
          sellerController.addToCar(items);
        },
      ),
    );
  }

  Widget _buildInformation() {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 5,
            children: [
              _buildInformationHeader(),
              _buildTextField(
                hintext: 'exp: Issa Traoré',
                label: 'Custumer name',
                icon: Icons.title_outlined,
                controller: customerName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Custumer name is required";
                  }
                  return null;
                },
              ),
              _buildTextField(
                hintext: 'exp: Niamey, Francophonie',
                label: 'Custumer address',
                icon: Icons.home_outlined,
                controller: customerAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Address is required";
                  }
                  return null;
                },
              ),
              _buildDiscountCheckbox(),
              if (isDiscountSelected) _buildDiscountField(),
              const Divider(),
              _buildOrderSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInformationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.cogs, color: Colors.black, size: 13),
          SizedBox(width: 10),
          Text(
            'Information de vente',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCheckbox() {
    return Row(
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
          'Discount ?',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDiscountField() {
    return _buildTextField(
      onChanged: (value) {
        sellerController.setDiscount(double.parse(value));
      },
      hintext: 'exp: 3500',
      label: 'Discount amount',
      icon: Icons.discount_outlined,
      onlyNumbers: true,
      controller: discountController,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (int.tryParse(value) == null) {
            return "Enter a valid input";
          }
        }
        return null;
      },
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      var item = sellerController.itemsList[index];
      item.quantity = (item.quantity ?? 0) + change;

      if (item.quantity! <= 0) {
        sellerController.itemsList.removeAt(index);
      }
    });
  }

  void createAndFetchInvoices() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      String? saleId = await createSale(
        customerName: customerName.text.trim(),
        customerAddress: customerAddress.text.trim(),
        discount: isDiscountSelected && discountController.text.isNotEmpty
            ? int.parse(discountController.text)
            : null,
        items: sellerController.itemsList
            .map((element) => element.toJson3())
            .toList(),
      );

      if (saleId != null) {
        Get.snackbar(
          backgroundColor: Colors.green,
          colorText: Colors.white,
          'Success',
          'Purchase successful',
        );

        await getInvoicesForSale(saleId);

        // Vider les champs et le tableau après succès // Assurez-vous que cela est appelé ici
      } else {
        print('erreur');
      }
    } catch (e) {
      Get.snackbar(
        colorText: Colors.white,
        backgroundColor: Colors.red,
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> clearFormFields() async {
    customerName.clear();
    customerAddress.clear();
    discountController.clear();
    sellerController.itemsList
        .clear(); // Assurez-vous que cette méthode vide la liste des articles
    isDiscountSelected = false;
    setState(() {});
  }

  Future<String?> createSale({
    String? customerName,
    String? customerAddress,
    int? discount,
    List<Map<String, dynamic>>? items,
  }) async {
    final Dio _dio = Dio();
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> data = {
        'custumerName': customerName,
        'custumerAddress': customerAddress,
        'discount': sellerController.discount.value.toInt(),
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
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['sale']['id'];
      }
      return null;
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        colorText: Colors.white,
        backgroundColor: Colors.red,
        "Erreur",
        e.response?.data['message'] ?? "Une erreur est survenue",
      );
      return null;
    }
  }

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
      invoiceController.selectedInvoice.value = invoice;
      clearFormFields();
      await apiController.refreshData();
      print('voici la facture :${response.data}');
    } on DioException catch (e) {
      Get.snackbar(
        colorText: Colors.white,
        backgroundColor: Colors.red,
        'Erreur',
        '${e.response?.data['message']}',
      );
      throw Exception('${e.response?.data['message']}');
    }
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow(
                  'Total Items', '${sellerController.totalItems} items'),
              _buildSummaryRow('Sub-total',
                  '${sellerController.subtotal.toStringAsFixed(0)} FCFA'),
              if (isDiscountSelected)
                _buildSummaryRow('Réduction',
                    '${sellerController.discount.value.toStringAsFixed(0)} FCFA'),
              const Divider(),
              _buildSummaryRow(
                  'Total', '${sellerController.total.toStringAsFixed(0)} FCFA',
                  isBold: true),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : createAndFetchInvoices,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Checkout'),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
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
    bool onlyNumbers = false,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
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
          borderRadius: BorderRadius.circular(5),
          child: TextFormField(
            onChanged: onChanged,
            controller: controller,
            validator: validator,
            keyboardType:
                onlyNumbers ? TextInputType.number : TextInputType.text,
            inputFormatters:
                onlyNumbers ? [FilteringTextInputFormatter.digitsOnly] : [],
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              hintText: hintext,
              fillColor: Colors.grey[200],
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
}
