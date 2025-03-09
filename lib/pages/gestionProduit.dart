import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:flutter_application_1/widget/customdropdow.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:flutter_application_1/widget/reusableTable.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final String title;
  final String buttonText;
  final bool isCategory;

  const Header(
      {super.key,
      required this.title,
      required this.buttonText,
      require,
      required this.isCategory});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final buttonKey = GlobalKey();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // Détection de la taille de l'écran pour afficher ou non le titre
    bool isDesktop = MediaQuery.of(context).size.width >= 600;

    return !isDesktop
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Affiche le titre seulement si ce n'est pas un desktop

                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await apiController.refreshData();
                        },
                        icon: const Icon(
                          Icons.refresh_outlined,
                          color: Colors.orange,
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      key: buttonKey,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      onPressed: () {
                        widget.isCategory
                            ? PopupHelper.showPopup(
                                context: context,
                                buttonKey: buttonKey,
                                width: 300,
                                popupContent: CategoryForm(),
                              )
                            : PopupHelper.showPopup(
                                context: context,
                                buttonKey: buttonKey,
                                width: 300,
                                popupContent: AddProduitForm(isHistoriquePage:false,),
                              );
                      },
                      child: Text(
                        widget.buttonText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}

class Header1 extends StatefulWidget {
  const Header1({
    super.key,
  });

  @override
  State<Header1> createState() => _Header1State();
}

class _Header1State extends State<Header1> {
  final buttonKey = GlobalKey();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final buttonKey2 = GlobalKey();
    // Détection de la taille de l'écran pour afficher ou non le titre
    bool isDesktop = MediaQuery.of(context).size.width >= 600;

    return !isDesktop
        ? const SizedBox.shrink()
        : Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'Listes des catégories',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Produits de la catégorie ${apiController.categorySelected.value.title}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          key: buttonKey2,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          onPressed: () {
                            PopupHelper.showPopup(
                              context: context,
                              buttonKey: buttonKey2,
                              width: 300,
                              popupContent: AddProduitForm(isHistoriquePage: false,),
                            );
                          },
                          child: const Text(
                            'Ajouer un produit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        apiController.isCategorySelected.value = false;
                      },
                      icon: const Icon(Icons.close_outlined))
                ],
              ),
              const Divider()
            ],
          );
  }
}

class Pagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () {}, child: const Text('Previous')),
          Row(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        index == 2 ? Colors.blue : Colors.grey[200],
                    // onPrimary: index == 2 ? Colors.white : Colors.grey,
                  ),
                  child: Text('${index + 1}'),
                ),
              );
            }),
          ),
          TextButton(onPressed: () {}, child: const Text('Next')),
        ],
      ),
    );
  }
}

class AddProduitForm extends StatefulWidget {
  bool? isHistoriquePage = false;
  AddProduitForm({
    super.key,
    this.isHistoriquePage,
  });

  @override
  State<AddProduitForm> createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  bool isLoading = false;
  final TextEditingController categorieText = TextEditingController();
  final TextEditingController nametext = TextEditingController();
  final TextEditingController prixtext = TextEditingController();
  final TextEditingController quantitytext = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (apiController.isCategorySelected.value) {
      categorieText.text = apiController.categorySelected.value.id!;
    }
  }

  Future<void> addCategory() async {
    setState(() {
      isLoading = true; // Lancer le chargement
    });
    ApiService apiService = ApiService();
    try {
      await apiService.addItem(
        nametext.text.trim(),
        int.parse(quantitytext.text.trim()),
        int.parse(prixtext.text.trim()),
        categorieText.text.trim(),
      );

      // Réinitialiser les champs

      if (!widget.isHistoriquePage!) {
        PopupHelper.removePopup(context);
      }

      await apiController.refreshData();
      setState(() {
        isLoading = false; // Arrêter le chargement après l'ajout
      });
      nametext.clear();
      quantitytext.clear();
      prixtext.clear();
      categorieText.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté avec succès!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Arrêter le chargement en cas d'erreur
      });
      // Affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'ajout du produit.')),
      );
    }
  }
  final buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Ajouter une un produit',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          if (!apiController.isCategorySelected.value)
            const SizedBox(height: 15),
          if (!apiController.isCategorySelected.value)
            ReusableSearchDropdown(
              hintText: 'Selectionné une catégorie',
              items: apiController.categories.map(
                (e) {
                  // int index = apiController.categories.indexOf(e);
                  return e.title!;
                },
              ).toList(),
              onPressed: (categorie) {
                setState(() {
                  categorieText.text = apiController.categories
                      .firstWhere((element) => element.title == categorie!)
                      .id!;
                });
              },
            ),
          if (apiController.isCategorySelected.value)
            const SizedBox(
              height: 10,
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: nametext,
              decoration: InputDecoration(
                // labelText: 'Nom de la catégorie',
                hintText: 'Nom',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                // Gestion dynamique si nécessaire
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: quantitytext,
              decoration: InputDecoration(
                // labelText: 'Nom de la catégorie',
                hintText: 'Quantité',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                // Gestion dynamique si nécessaire
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: prixtext,
              decoration: InputDecoration(
                // labelText: 'Nom de la catégorie',
                hintText: 'Prix unitaire',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                // Gestion dynamique si nécessaire
              },
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // Ajoute une vérification pour la saisie
                    if (categorieText.text.isNotEmpty) {
                      await addCategory();
                    } else {
                      // Affiche un message d'erreur si le champ est vide
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Veuillez entrer une catégorie valide.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Valider',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
          if (widget.isHistoriquePage!)
            Center(
              child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
              'Assurez vous que la catégories du produit est créer d\'abord sinon veillez en créer une',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
            )
        ],
      ),
    );
  }
}

class RetirerStokForm extends StatefulWidget {
  const RetirerStokForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RetirerStokForm> createState() => _RetirerStokFormState();
}

class _RetirerStokFormState extends State<RetirerStokForm> {
  bool isLoading = false;
  // final TextEditingController categorieText = TextEditingController();
  final TextEditingController nametext = TextEditingController();
  // final TextEditingController prixtext = TextEditingController();
  final TextEditingController quantitytext = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> addCategory() async {
    setState(() {
      isLoading = true; // Lancer le chargement
    });
    ApiService apiService = ApiService();
    Item item = apiController.items.firstWhere(
      (element) => element.name == nametext.text.trim(),
    );
    try {
      await apiService.retirerStok(
        item,
        int.parse(quantitytext.text.trim()),
      );

      PopupHelper.removePopup(context);

      await apiController.refreshData();
      setState(() {
        isLoading = false; // Arrêter le chargement après l'ajout
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajoutée avec succès!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Arrêter le chargement en cas d'erreur
      });
      print(e);
      // Affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'ajout de du produit.')),
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
            'Rétirer un stok',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          if (!apiController.isCategorySelected.value)
            const SizedBox(height: 15),
          if (!apiController.isCategorySelected.value)
            ReusableSearchDropdown(
              items: apiController.items.map(
                (e) {
                  // int index = apiController.categories.indexOf(e);
                  return e.name!;
                },
              ).toList(),
              onPressed: (produit) {
                setState(() {
                  nametext.text = produit!;
                });
              },
            ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: quantitytext,
              decoration: InputDecoration(
                // labelText: 'Nom de la catégorie',
                hintText: 'Quantité',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                // Gestion dynamique si nécessaire
              },
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // Ajoute une vérification pour la saisie
                    if (quantitytext.text.isNotEmpty) {
                      await addCategory();
                    } else {
                      // Affiche un message d'erreur si le champ est vide
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez entrer une quantité valide.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Valider',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class CategoryForm extends StatefulWidget {
  bool? isHistoriquePage = false;
  CategoryForm({Key? key, this.isHistoriquePage}) : super(key: key);

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  bool isLoading = false;
  final TextEditingController categorieText = TextEditingController();
  Future<void> addCategory() async {
    setState(() {
      isLoading = true; // Lancer le chargement
    });
    ApiService apiService = ApiService();
    try {
      await apiService.addCategory(categorieText.text.trim());

      if (!widget.isHistoriquePage!) {
        PopupHelper.removePopup(context);
      }

      await apiController.refreshData();
      setState(() {
        isLoading = false; // Arrêter le chargement après l'ajout
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catégorie ajoutée avec succès!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Arrêter le chargement en cas d'erreur
      });
      // Affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erreur lors de l\'ajout de la catégorie.')),
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
            'Ajouter une catégorie',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: categorieText,
              decoration: InputDecoration(
                // labelText: 'Nom de la catégorie',
                hintText: 'Entrez le nom de la catégorie',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                // Gestion dynamique si nécessaire
              },
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // Ajoute une vérification pour la saisie
                    if (categorieText.text.isNotEmpty) {
                      await addCategory();
                    } else {
                      // Affiche un message d'erreur si le champ est vide
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Veuillez entrer une catégorie valide.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Valider',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
