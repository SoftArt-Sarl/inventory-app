import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/pages/gestionProduit.dart';
import 'package:flutter_application_1/pages/responsiveGrid.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/ActionbuttonRow.dart';
import 'package:flutter_application_1/widget/categoryWidget.dart';
import 'package:flutter_application_1/widget/customdropdow.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:get/get.dart';

class ReusableTable extends StatelessWidget {
  bool? isFromDashbord = false;
  final List<Map<String, dynamic>> data;
  final Function(BuildContext, Map<String, dynamic>)? onEdit;
  final Function(BuildContext, Map<String, dynamic>)? onDelete;

  ReusableTable(
      {Key? key,
      required this.data,
      this.onEdit,
      this.onDelete,
      this.isFromDashbord = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    if (data.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No data found.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    if (appTypeController.isDesktop.value && !isFromDashbord!) {
      return _buildDesktopTable(context);
    } else {
      return _buildMobileList(appTypeController.isDesktop.value, context,
          isFromDashbordd: isFromDashbord);
    }
  }

  Widget _buildDesktopTable(BuildContext context) {
    final headers = data.first.keys
        .where((key) => key != 'id' && key != 'categoryId' && key != 'Status')
        .toList();
    final header1 = data.first.keys
        .where((key) => key != 'id' && key != 'categoryId')
        .toList();

    return Column(
      children: [
        Table(
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Colors.white),
              children: [
                ...header1.map((header) => _buildHeaderCell(header, true)),
                if (userinfo.authmodel.value.user!.role == 'ADMIN')
                  _buildHeaderCell('Actions', true),
              ],
            )
          ],
        ),
        isFromDashbord!
            ? Table(
                border: TableBorder.all(
                    color: Colors.grey.withOpacity(0.3), width: 1),
                children: data
                    .map((rowData) => _buildRow(
                        isFromDashbord: isFromDashbord,
                        rowData,
                        appTypeController.isDesktop.value ? header1 : headers,
                        context))
                    .toList(),
              )
            : Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                    children: data
                        .map((rowData) => _buildRow(
                            isFromDashbord: isFromDashbord,
                            rowData,
                            appTypeController.isDesktop.value
                                ? header1
                                : headers,
                            context))
                        .toList(),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildMobileList(bool isDesktop, BuildContext context,
      {bool? isFromDashbordd}) {
    if (isFromDashbordd!) {
      // Mode tableau de bord : Utiliser ResponsiveGrid
      return ResponsiveGrid(
        spacing:0,
        runSpacing:0,
        columnsMobile: 2,
        columnsTablet: 3,
        columnsDesktop: 4,
        children: data.map((rowData) {
          final quantity = rowData['quantity'];
          final unitPrice = rowData['Unit price'];
          final total = rowData['Total'];

          return Card(
            elevation: 0,
            margin: const EdgeInsets.all(2),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rowData['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Quantity: $quantity'),
                  Text('Unit price: $unitPrice'),
                  Text('Total: $total'),
                  const SizedBox(height: 10),
                  if (userinfo.authmodel.value.user!.role == 'ADMIN')
                    _buildActionButtons(rowData, context, isDesktop,
                        isfrmdashbord: isFromDashbordd),
                  if (userinfo.authmodel.value.user!.role == 'SELLER')
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: () {
                        sellerController.addItemToCar(rowData['name'], context);
                      },
                      child: const Text('Add to cart'),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Mode normal : Utiliser ListView.builder
      return ListView.builder(
        padding: const EdgeInsets.only(top: 5),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final rowData = data[index];
          final quantity = rowData['quantity'];
          final unitPrice = rowData['Unit price'];
          final total = rowData['Total'];

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rowData['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Quantity: $quantity'),
                        Text('Unit price: $unitPrice'),
                        Text('Total: $total'),
                      ],
                    ),
                  ),
                  if (userinfo.authmodel.value.user!.role == 'ADMIN')
                    _buildActionButtons(rowData, context, isDesktop,
                        isfrmdashbord: isFromDashbordd),
                  if (userinfo.authmodel.value.user!.role == 'SELLER')
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: () {
                        sellerController.addItemToCar(rowData['name'], context);
                      },
                      child: const Text('Add to cart'),
                    )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  TableRow _buildRow(
      Map<String, dynamic> rowData, List<String> headers, BuildContext context,
      {bool? isFromDashbord}) {
    ApiService apiService = ApiService();
    return TableRow(
      decoration: BoxDecoration(color: Colors.white),
      children: [
        ...headers.map((header) {
          if (header == 'Catégorie') {
            final categoryId = rowData[header];

            String category = apiController.categories
                .firstWhere(
                  (element) => element.id == categoryId,
                )
                .title!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(category, style: const TextStyle(fontSize: 16)),
              ),
            );
          } else {
            return _buildCell(
                rowData[header], appTypeController.isDesktop.value);
          }
        }),
        if (userinfo.authmodel.value.user!.role == 'ADMIN')
          _buildActionButtons(
              rowData, context, appTypeController.isDesktop.value,
              isfrmdashbord: isFromDashbord),
      ],
    );
  }

  Widget _buildHeaderCell(String text, bool isDesktop) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text,
            style: TextStyle(
                fontSize: isDesktop ? 16 : 14, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCell(dynamic value, bool isDesktop) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: value is bool
            ? Icon(
                !value
                    ? Icons.check_circle_outline
                    : Icons.remove_shopping_cart_outlined,
                color: !value ? Colors.green : Colors.red)
            : Text(value != null ? value.toString() : 'Aucune donnée'),
      ),
    );
  }

  Widget _buildActionButtons(
      Map<String, dynamic> rowData, BuildContext context, bool isdektop,
      {bool? isfrmdashbord}) {
    final buttonKey1 = GlobalKey();
    final buttonKey2 = GlobalKey();
    final buttonKey3 = GlobalKey();


    final String? id = rowData['id'];
    final String? name = rowData['name'];
    final String? unitPrice = rowData['Unit price'];
    final String? categoryId = rowData['categoryId'];
    final String? quantity = rowData['quantity'].toString();

    if (id == null) {
      return const SizedBox.shrink(); // Si pas d'ID, ne rien afficher
    }

    void updateItem(BuildContext context) {
      PopupHelper.showPopup(
        context: context,
        buttonKey: buttonKey1,
        width: 300,
        popupContent: UpdateItemForm(
          isHistoriquePage: false,
          categoryId: categoryId,
          id: id,
          name: name,
          unitPrice: unitPrice,
          quantity: quantity,
        ),
      );
    }
    void addstok(BuildContext context) {
      PopupHelper.showPopup(
        context: context,
        buttonKey: buttonKey3,
        width: 300,
        popupContent: AjouterStockForm(itemName: name,),
      );
    }

    void deletedItem(BuildContext context) {
      PopupHelper.showPopup(
        context: context,
        buttonKey: buttonKey2,
        width: 300,
        popupContent: DeleteItemForm(
          // categoryId: categoryId!,
          itemId: id,
          isHistoriquePage: false,
        ),
      );
    }

    return Center(
      child: Padding(
        padding: isdektop
            ? const EdgeInsets.symmetric(vertical: 10, horizontal: 8)
            : const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: AbsorbPointer(
            absorbing:
                userinfo.authmodel.value.user!.role == "SELLER" ? true : false,
            child: isfrmdashbord!
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {
                      addstok(context);
                    },
                    child: const Text('New stock',style: TextStyle(fontSize: 13),),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        key: buttonKey1,
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(
                              side: BorderSide(color: Colors.orange)),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(36, 36),
                        ),
                        onPressed: () {
                          updateItem(context);
                        },
                        child: const Icon(Icons.edit_outlined,
                            size: 18, color: Colors.orange),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        key: buttonKey2,
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(
                              side: BorderSide(color: Colors.red)),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(36, 36),
                        ),
                        onPressed: () {
                          deletedItem(context);
                        },
                        child: const Icon(Icons.delete_outline,
                            size: 18, color: Colors.red),
                      ),
                    ],
                  )),
      ),
    );
  }
}

class FutureWidget<T> extends StatelessWidget {
  final Future<T> Function() fetchFunction;
  final Widget Function(T data) builder;

  const FutureWidget(
      {super.key, required this.fetchFunction, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: fetchFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        } else if (snapshot.hasError) {
          return const Center(child: Text(''));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Aucune donnée disponible.'));
        }
        return builder(snapshot.data as T);
      },
    );
  }
}

class UpdateItemForm extends StatefulWidget {
  bool? isHistoriquePage = false;
  final String? id;
  final String? name;
  final String? unitPrice;
  final String? categoryId;
  final String? quantity;

  UpdateItemForm({
    super.key,
    this.id,
    this.name,
    this.unitPrice,
    this.categoryId,
    this.quantity,
    this.isHistoriquePage,
  });

  @override
  State<UpdateItemForm> createState() => _UpdateItemFormState();
}

class _UpdateItemFormState extends State<UpdateItemForm> {
  bool isLoading = false;
  late TextEditingController itemTextController;
  late TextEditingController unitPriceController;
  late TextEditingController quantityController;
  late TextEditingController categoryIdController; // Contrôleur pour categoryId
  String? selectedItemId;
  Item? item;

  @override
  void initState() {
    super.initState();
    // Si isHistoriquePage est vrai, on initialise les champs avec des valeurs vides
    if (widget.isHistoriquePage == true) {
      itemTextController = TextEditingController();
      unitPriceController = TextEditingController();
      quantityController = TextEditingController();
      categoryIdController = TextEditingController();
    } else {
      // Sinon, on les initialise avec les valeurs passées
      itemTextController = TextEditingController(text: widget.name);
      unitPriceController =
          TextEditingController(text: widget.unitPrice?.trim());
      quantityController = TextEditingController(text: widget.quantity!.trim());
      categoryIdController =
          TextEditingController(text: widget.categoryId ?? "");
    }
  }

  Future<void> updateItem() async {
    setState(() {
      isLoading = true;
    });
    ApiService apiService = ApiService();
    try {
      String itemId =
          widget.isHistoriquePage == true ? selectedItemId! : widget.id!;

      await apiService.updateItem(
        itemId,
        itemTextController.text.trim(),
        int.parse(unitPriceController.text.trim()),
        int.parse(quantityController.text.trim()),
      );
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated!')),
      );
      if (!widget.isHistoriquePage!) {
        PopupHelper.removePopup(context);
      }
      await apiController.refreshData();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error when updating item.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Edit item',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          widget.isHistoriquePage == true
              ? ReusableSearchDropdown(
                  hintText: 'Select an item',
                  items: apiController.items.map(
                    (e) {
                      return e.name!;
                    },
                  ).toList(),
                  onPressed: (itemName) {
                    setState(() {
                      selectedItemId = apiController.items
                          .firstWhere((element) => element.name == itemName!)
                          .id;
                      item = apiController.items
                          .firstWhere((element) => element.name == itemName!);
                      itemTextController.text = item!.name!;
                      unitPriceController.text = item!.unitPrice.toString();
                      quantityController.text = item!.quantity.toString();
                    });
                  },
                )
              : Container(), // Affichage
          const SizedBox(height: 15),
          widget.isHistoriquePage == true
              ? _buildTextField(itemTextController, 'Item name')
              : _buildTextField(itemTextController, 'Edit item name'),
          const SizedBox(height: 15),
          widget.isHistoriquePage == true
              ? _buildTextField(unitPriceController, 'Price', isNumeric: true)
              : _buildTextField(unitPriceController, 'Edit item price',
                  isNumeric: true),
          const SizedBox(height: 15),
          widget.isHistoriquePage == true
              ? _buildTextField(quantityController, 'Quantity', isNumeric: true)
              : _buildTextField(quantityController, 'Edit item quantity',
                  isNumeric: true),
          const SizedBox(height: 15),

          // Dropdown pour sélectionner un item (utilisé pour récupérer l'ID)

          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ActionButtonsRow(
                  cancelText: "Cancel",
                  confirmText: "Confirm",
                  onCancel: () {
                    PopupHelper.removePopup(context);
                  },
                  onConfirm: () async {
                    if (itemTextController.text.isNotEmpty) {
                      await updateItem();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter a valid input.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool isNumeric = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    itemTextController.dispose();
    unitPriceController.dispose();
    quantityController.dispose();
    categoryIdController.dispose();
    super.dispose();
  }
}

class DeleteItemForm extends StatefulWidget {
  final String? itemId;
  // final String? categoryId;
  bool? isHistoriquePage = false;

  DeleteItemForm(
      {super.key,
      required this.itemId,
      // required this.categoryId,
      this.isHistoriquePage});

  @override
  State<DeleteItemForm> createState() => _DeleteItemFormState();
}

class _DeleteItemFormState extends State<DeleteItemForm> {
  bool isLoading = false;

  Future<void> deleteItem() async {
    setState(() {
      isLoading = true;
    });

    ApiService apiService = ApiService();
    try {
      await apiService.deleteItem(
        widget.itemId!,
      );
      setState(() {
        isLoading = false;
      });

      PopupHelper.removePopup(context);
      await apiController.refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Element deleted successfully!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error when deleting element.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Delete element',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          if (!widget.isHistoriquePage!)
            const Text(
              'Do you realy want to delete this element ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.red),
            ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ActionButtonsRow(
                  cancelText: "Cancel",
                  confirmText: "Delete",
                  onCancel: () {
                    PopupHelper.removePopup(context);
                  },
                  onConfirm: () async {
                    await deleteItem();
                  },
                ),
        ],
      ),
    );
  }
}
