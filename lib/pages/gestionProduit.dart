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
                    AbsorbPointer(absorbing: userinfo.authmodel.value.user!.role == "SELLER"?true:false,
                      child: ElevatedButton(
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
  final buttonKey2 = GlobalKey();
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);

    if (!appTypeController.isDesktop.value) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 5),
            const Text(
              'Listes des catégories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Produits de la catégorie ${apiController.categorySelected.value.title}',
                  //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.orange),
                      const SizedBox(width: 5),
                      Text(
                        'Valeur totale : ${apiController.categorySelected.value.total} FCFA',
                        style: const TextStyle(fontSize: 14, ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.production_quantity_limits, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text(
                        'Type de produits : ${apiController.categorySelected.value.items!.length}',
                        style: const TextStyle(fontSize: 14,),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
              key: buttonKey2,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                PopupHelper.showPopup(
                  context: context,
                  buttonKey: buttonKey2,
                  width: 300,
                  popupContent: AddProduitForm(isHistoriquePage: false),
                );
              },
              child: const Text(
                'Ajouter un produit',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                apiController.isCategorySelected.value = false;
              },
              icon: const Icon(Icons.close_outlined),
            )
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
  bool? isHistoriquePage;
  bool? isdektop;
  AddProduitForm({
    super.key,
    this.isHistoriquePage=false,
    this.isdektop
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
      !widget.isdektop!? Get.back():null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté avec succès!',),),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Arrêter le chargement en cas d'erreur
      });
      !widget.isdektop!? Get.back():null;
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
                hintText: 'Quantity',
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
                hintText: 'Unit price',
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
                              Text('Enter a valid category.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirm',
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
              'Ensure that the category related to this product is already created',
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

class RetirerStockForm extends StatefulWidget {
  const RetirerStockForm({Key? key}) : super(key: key);

  @override
  State<RetirerStockForm> createState() => _RetirerStockFormState();
}

class _RetirerStockFormState extends State<RetirerStockForm> {
  bool isLoading = false;
  final TextEditingController nametext = TextEditingController();
  final TextEditingController quantitytext = TextEditingController();

  Future<void> retirerStock() async {
  if (isLoading) return; // Éviter les doubles soumissions

  setState(() {
    isLoading = true; // Lancer le chargement
  });

  try {
    ApiService apiService = ApiService();

    // Vérification que le champ nom est rempli
    String itemName = nametext.text.trim();
    if (itemName.isEmpty) {
      throw Exception("Enter item name.");
    }

    // Vérification que l'article existe
    Item? item;
    try {
      item = apiController.items.firstWhere(
        (element) => element.name == itemName,
      );
    } catch (e) {
      throw Exception("This product doesn't exist.");
    }

    // Vérification de la quantité
    int? quantity = int.tryParse(quantitytext.text.trim());
    if (quantity == null || quantity <= 0) {
      throw Exception('Enter a valid input.');
    }

    // Exécuter le retrait du stock
    await apiService.retirerStok(item, quantity);

    // Rafraîchir les données
    await apiController.refreshData();

    setState(() {
      isLoading = false; // Arrêter le chargement
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product removed successfully!')),
    );
  } catch (e) {
    setState(() {
      isLoading = false; // Arrêter le chargement en cas d'erreur
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
     const  SnackBar(
        content: Text('Something went wrong'), // Afficher le message d'erreur précis
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
            'Remove a product',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          if (!apiController.isCategorySelected.value) const SizedBox(height: 15),
          if (!apiController.isCategorySelected.value)
            ReusableSearchDropdown(
              items: apiController.items.map((e) => e.name!).toList(),
              onPressed: (produit) {
                setState(() {
                  nametext.text = produit!;
                });
              },
            ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: quantitytext,
              keyboardType: TextInputType.number, // Assure que seul un nombre est entré
              decoration: InputDecoration(
                hintText: 'Quantity',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
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
                    if (quantitytext.text.isNotEmpty) {
                      await retirerStock();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter a valid input.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirm',
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
class AjouterStockForm extends StatefulWidget {
  const AjouterStockForm({Key? key}) : super(key: key);

  @override
  State<AjouterStockForm> createState() => _AjouterStockFormState();
}

class _AjouterStockFormState extends State<AjouterStockForm> {
  bool isLoading = false;
  final TextEditingController nametext = TextEditingController();
  final TextEditingController quantitytext = TextEditingController();

  Future<void> ajouterStock() async {
  if (isLoading) return; // Éviter les doubles soumissions

  setState(() {
    isLoading = true; // Début du chargement
  });

  try {
    ApiService apiService = ApiService();

    // Vérification que le champ nom est rempli
    String itemName = nametext.text.trim();
    if (itemName.isEmpty) {
      throw Exception("Product name.");
    }

    // Vérification que l'article existe
    Item? item;
    try {
      item = apiController.items.firstWhere(
        (element) => element.name == itemName,
      );
    } catch (e) {
      throw Exception("Product doesn't exist.");
    }

    // Vérification de la quantité
    int? quantity = int.tryParse(quantitytext.text.trim());
    if (quantity == null || quantity <= 0) {
      throw Exception('Enter a valid input.');
    }

    // Exécuter l’ajout de stock
    await apiService.ajouterStock(item, quantity);

    // Rafraîchir les données
    await apiController.refreshData();

    setState(() {
      isLoading = false; // Fin du chargement
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stock added to this item!')),
    );
  } catch (e) {
    setState(() {
      isLoading = false; // Arrêter le chargement en cas d'erreur
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong'), // Afficher le message d'erreur précis
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
            'Add stock to an item',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          if (!apiController.isCategorySelected.value) const SizedBox(height: 15),
          if (!apiController.isCategorySelected.value)
            ReusableSearchDropdown(
              items: apiController.items.map((e) => e.name!).toList(),
              onPressed: (produit) {
                setState(() {
                  nametext.text = produit!;
                });
              },
            ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: quantitytext,
              keyboardType: TextInputType.number, // Clavier numérique
              decoration: InputDecoration(
                hintText: 'Quantity',
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Vert pour l'ajout
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (quantitytext.text.isNotEmpty) {
                      await ajouterStock();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter a valid input.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: (){
                  Get.defaultDialog(content: const AjouterStockFormmultiple());
                }, child: const Text('text'),)
        ],
      ),
    );
  }
}


class AjouterStockFormmultiple extends StatefulWidget {
  const AjouterStockFormmultiple({Key? key}) : super(key: key);

  @override
  State<AjouterStockFormmultiple> createState() => _AjouterStockFormmultipleState();
}

class _AjouterStockFormmultipleState extends State<AjouterStockFormmultiple> {
  bool isLoading = false;
  final List<TextEditingController> nameControllers = [];
  final List<TextEditingController> quantityControllers = [];

  @override
  void initState() {
    super.initState();
    // Ajout d'une ligne initiale
    addNewRow();
  }

  void addNewRow() {
    nameControllers.add(TextEditingController());
    quantityControllers.add(TextEditingController());
    setState(() {});
  }

  Future<void> ajouterStock() async {
    if (isLoading) return; // Éviter les doubles soumissions

    setState(() {
      isLoading = true; // Début du chargement
    });

    try {
      ApiService apiService = ApiService();
      List<Item> itemsToAdd = [];

      for (int i = 0; i < nameControllers.length; i++) {
        String itemName = nameControllers[i].text.trim();
        if (itemName.isEmpty) {
          throw Exception("Enter product name.");
        }

        // Vérification que l'article existe
        Item? item;
        try {
          item = apiController.items.firstWhere(
            (element) => element.name == itemName,
          );
        } catch (e) {
          throw Exception("Product '$itemName' doesn't exist.");
        }

        // Vérification de la quantité
        int? quantity = int.tryParse(quantityControllers[i].text.trim());
        if (quantity == null || quantity <= 0) {
          throw Exception('Enter a valid input for "$itemName".');
        }

        itemsToAdd.add(item);
        await apiService.ajouterStock(item, quantity);
      }

      // Rafraîchir les données
      await apiController.refreshData();

      setState(() {
        isLoading = false; // Fin du chargement
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock added to this item!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Arrêter le chargement en cas d'erreur
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()), // Afficher le message d'erreur précis
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
            'Add stock to an item',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: nameControllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: ReusableSearchDropdown(
                        items: apiController.items.map((e) => e.name!).toList(),
                        onPressed: (produit) {
                          setState(() {
                            nameControllers[index].text = produit!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          controller: quantityControllers[index],
                          keyboardType: TextInputType.number, // Clavier numérique
                          decoration: InputDecoration(
                            hintText: 'Quantity',
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Couleur pour l'ajout
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8 ),
                  ),
                  
                  
                ), onPressed: () async{await ajouterStock();  }, child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add stock to items',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              addNewRow(); // Ajouter une nouvelle ligne
            },
            child: const Text('Add new row'),
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

      // if (!widget.isHistoriquePage!) {
      //   PopupHelper.removePopup(context);
      // }

      await apiController.refreshData();
      setState(() {
        isLoading = false; // Arrêter le chargement après l'ajout
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added successfully!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Arrêter le chargement en cas d'erreur
      });
      // Affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Something went wrong.'),backgroundColor: Colors.red,),
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
            'Add a category',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextFormField(
              controller: categorieText,
              decoration: InputDecoration(
                // labelText: 'Nom de la catégorie',
                hintText: 'Category name',
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
                  onPressed: (){},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirm',
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
