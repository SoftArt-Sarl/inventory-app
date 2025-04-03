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
  bool? isFromDashbord;
  ShoppingCart({super.key,this.isFromDashbord});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    super.initState();
    invoiceController.selectedInvoice.value=null;
  }
  bool _isLoading = false;
  bool isDiscountSelected = false;

  TextEditingController customerName = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController discountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PageController pageController = PageController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    return !appTypeController.isDesktop.value ||widget.isFromDashbord!
        ? Obx(
            () => Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index; // Met à jour l'index actuel
                        });
                      },
                      children: [
                        _buildProductSection(),
                        invoiceController.selectedInvoice.value != null
                            ? InvoicePagee(
                                invoice:
                                    invoiceController.selectedInvoice.value!,
                                isDeliveryPage: false,
                              )
                            : _buildInformation(),
                      ],
                    ),
                  ),
                  const Divider(),
                  _buildPageIndicator(),
                ],
              ),
            ),
          )
        : Card(
            elevation: 4,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Container(
              color: Colors.grey[200],
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
                                ? InvoicePagee(
                                    invoice:
                                        invoiceController.selectedInvoice.value!,
                                    isDeliveryPage: false,
                                  )
                                : _buildInformation(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildProductSection() {
    return Container(
      height: double.maxFinite,
      color: Colors.grey[200],
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 5),
              child: _buildInformationHeader('Information de vente', const FaIcon(FontAwesomeIcons.list, color: Colors.black, size: 13)),
            ),
                    Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: sellerController.itemsList
                    .asMap()
                    .entries
                    .map((entry) =>
                        _buildProductRowMobile(entry.key, entry.value))
                    .toList(),
              ),
            ),
          ),
          _buildAddItemDropdown()
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index ? Colors.orange : Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      flex: 4,
      child: Container(
        color: Colors.grey[200],
        // padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildTableHeader(),
            // const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 5),
              child: _buildInformationHeader('Information de vente', const FaIcon(FontAwesomeIcons.list, color: Colors.black, size: 13)),
            ),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: sellerController.itemsList
                        .asMap()
                        .entries
                        .map(
                            (entry) => _buildProductRowMobile(entry.key, entry.value))
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
    return _buildHeaderRow([
      _buildHeaderCell('Product', FontAwesomeIcons.cogs),
      _buildHeaderCell('Unit price', FontAwesomeIcons.tag),
      _buildHeaderCell('Quantity', FontAwesomeIcons.sortAmountUpAlt),
      _buildHeaderCell('Total', FontAwesomeIcons.calculator),
      _buildHeaderCell('Action', FontAwesomeIcons.trashAlt),
    ]);
  }

  Widget _buildHeaderRow(List<Widget> cells) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: cells,
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
          _buildCell(Text(product.name ?? 'N/A')),
          _buildCell(Text('${(product.unitPrice ?? 0).toStringAsFixed(0)}')),
          _buildCell(_buildQuantityControls(index, product)),
          _buildCell(Text(total.toStringAsFixed(0))),
          _buildCell(_buildRemoveButton(index, product)),
        ],
      ),
    );
  }

  Widget _buildCell(Widget child) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildProductRowMobile(int index, dynamic product) {
    int total = (product.unitPrice ?? 0) * (product.quantity ?? 0);
    return Card(
      elevation: 0,
      // color: Colors.grey[200],
      margin: const EdgeInsets.only(bottom: 5, top: 5,left: 10,right: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name ?? 'N/A',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Unit price: ${(product.unitPrice ?? 0).toStringAsFixed(0)}'),
                  Text('Total: ${total.toStringAsFixed(0)}'),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _updateQuantity(index, -1),
                  icon: const Icon(Icons.remove),
                ),
                Text('${product.quantity ?? 0}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => _updateQuantity(index, 1),
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () =>
                      _updateQuantity(index, -(product.quantity ?? 0)),
                ),
              ],
            ),
          ],
        ),
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

  Widget _buildAddItemDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // width: MediaQuery.of(context).size.width / 4,
      child: MultiSelectDropdownButton(
        hintText: 'Cliquez ici pour ajouter des items',
        items: apiController.items,
        onPressed: (items) {
          sellerController.addToCar(context,items.map((e) => e.id!,).toList(),);
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
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 5,
            children: [
              _buildInformationHeader('Information de vente',const FaIcon(FontAwesomeIcons.cogs, color: Colors.black, size: 13)),
              _buildTextField(
                hintext: 'exp: Issa Traoré',
                label: 'Custumer name',
                icon: Icons.title_outlined,
                controller: customerName,
                validator: (value) => value == null || value.isEmpty
                    ? "Custumer name is required"
                    : null,
              ),
              _buildTextField(
                hintext: 'exp: Niamey, Francophonie',
                label: 'Custumer address',
                icon: Icons.home_outlined,
                controller: customerAddress,
                validator: (value) => value == null || value.isEmpty
                    ? "Address is required"
                    : null,
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

  Widget _buildInformationHeader(String title,Widget icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            title,
            style:const  TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCheckbox() {
    return Card(
      margin: EdgeInsets.only(top: 5),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
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
        ),
      ),
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

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow(
                  'Total Items', '${sellerController.totalItems} items'),
              _buildSummaryRow('Sub -total',
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
              fillColor: Colors.white,
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
    sellerController.itemsList.clear();
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
}
