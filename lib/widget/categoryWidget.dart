import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/pages/gestionProduit.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/ActionbuttonRow.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CategoryWidget extends StatelessWidget {
  Category? category;
  CategoryWidget({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    final buttonKey1 = GlobalKey();
    // final buttonKey2 = GlobalKey();
    void updateCategory(BuildContext context) {
      PopupHelper.showPopup(
        context: context,
        buttonKey: buttonKey1,
        width: 300,
        popupContent: UpdateCategoryForm(
          category: category!,
        ),
      );
    }

    void deleteCategory(BuildContext context) {
      PopupHelper.showPopup(
        context: context,
        buttonKey: buttonKey1,
        width: 300,
        popupContent: DeleteCategoryForm(
          category: category!,
        ),
      );
    }

    return Obx(() => Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: apiController.categorySelected.value == category &&
                    apiController.isCategorySelected.value
                ? Border.all(color: Colors.orange, width: 2)
                : apiController.isCategorySelected.value
                    ? null
                    : const Border(
                        left: BorderSide(color: Colors.orange, width: 2)),
            borderRadius: BorderRadius.circular(
                apiController.categorySelected.value == category &&
                        apiController.isCategorySelected.value
                    ? 5
                    : 0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category!.title ?? 'Sans titre',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoItem(Icons.shopping_cart,
                        'Items: ${category!.items?.length ?? 0}'),
                  ),
                  const Spacer(),
                  Expanded(
                    child: _buildInfoItem(
                        Icons.warning_amber_rounded,
                        'Almost Out of stock: ${apiController.itemsRupture.where(
                              (element) => element.categoryId == category!.id!,
                            ).toList().length}',
                        Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoItem(
                        Icons.attach_money,
                        'Total: ${category!.total?.toStringAsFixed(2) ?? "0.00"} FCFA',
                        Colors.green),
                  ),
                  const Spacer(),
                  Expanded(
                    child: _buildInfoItem(Icons.store,
                        'Stock: ${category!.items!.length}', Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                            key: buttonKey1,
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(36, 36),
                            ),
                            onPressed: () {
                              // PopupHelper.removePopup(context);
                              updateCategory(context);
                            },
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 5),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(36, 36),
                            ),
                            onPressed: () {
                              deleteCategory(context);
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              size: 18,
                            ),
                          ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildInfoItem(IconData icon, String text, [Color? color]) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? Colors.grey[700]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color ?? Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

}


class UpdateCategoryForm extends StatefulWidget {
  final Category? category;

  const UpdateCategoryForm({Key? key, this.category}) : super(key: key);

  @override
  State<UpdateCategoryForm> createState() => _UpdateCategoryFormState();
}

class _UpdateCategoryFormState extends State<UpdateCategoryForm> {
  bool isLoading = false;
  late TextEditingController categorieText;

  @override
  void initState() {
    super.initState();
    categorieText = TextEditingController(text: widget.category!.title);
  }

  Future<void> updateCategory() async {
    setState(() {
      isLoading = true;
    });

    ApiService apiService = ApiService();
    try {
      await apiService.updateCategory(
          widget.category!.id!, categorieText.text.trim());
      setState(() {
        isLoading = false;
      });

      PopupHelper.removePopup(context);
      await apiController.refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catégorie mise à jour avec succès!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la mise à jour de la catégorie.'),
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
            'Modifier la catégorie',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              autofocus: true,
              controller: categorieText,
              decoration: InputDecoration(
                hintText: 'Modifier le nom de la catégorie',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ActionButtonsRow(
                  cancelText: "Annuler",
                  confirmText: "Valider",
                  onCancel: () {
                    PopupHelper.removePopup(context);
                  },
                  onConfirm: () async {
                    if (categorieText.text.isNotEmpty) {
                      await updateCategory();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez entrer un nom valide.'),
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

  @override
  void dispose() {
    categorieText.dispose();
    super.dispose();
  }
}

class DeleteCategoryForm extends StatefulWidget {
  final Category? category;

  const DeleteCategoryForm({Key? key, this.category}) : super(key: key);

  @override
  State<DeleteCategoryForm> createState() => _DeleteCategoryFormState();
}

class _DeleteCategoryFormState extends State<DeleteCategoryForm> {
  bool isLoading = false;

  Future<void> deleteCategory() async {
    setState(() {
      isLoading = true;
    });

    ApiService apiService = ApiService();
    try {
      await apiService.deleteCategory(widget.category!.id!);
      setState(() {
        isLoading = false;
      });

      PopupHelper.removePopup(context);
      await apiController.refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catégorie supprimée avec succès!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la suppression de la catégorie.'),
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
            'Supprimer la catégorie',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text(
            'Voulez-vous vraiment supprimer la catégorie "${widget.category!.title}" ? Cette action est irréversible.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.red),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ActionButtonsRow(
                  cancelText: "Annuler",
                  confirmText: "Supprimer",
                  onCancel: () {
                    PopupHelper.removePopup(context);
                  },
                  onConfirm: () async {
                    await deleteCategory();
                  },
                ),
        ],
      ),
    );
  }
}

