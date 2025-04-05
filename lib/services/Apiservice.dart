import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/Usermodel.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/models.dart/historiqueModel.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://inventory-app-five-ebon.vercel.app'),
  );

  // Récupération du token d'accès
  String get _accessToken => userinfo.authmodel.value.access_token;

  // ============================
  // 1. Gestion des utilisateurs
  // ============================

  // Inscription d'un utilisateur
  Future<Response> registerUser(User user) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'password': user.password,
        'createdAt': user.createdAt!.toIso8601String(),
        'role': user.role,
      });
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription: $e');
    }
  }

  // Connexion d'un utilisateur
  Future<Response> loginUser(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  // Mise à jour du mot de passe
  Future<Response> updatePassword(String newPassword) async {
    try {
      final response = await _dio.post(
        '/auth/password/update',
        data: {
          'password': newPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du mot de passe: $e');
    }
  }

  // Créer un Seller (accessible uniquement par l'admin)
  Future<Response> createSeller(String email, String password, String name) async {
    try {
      final response = await _dio.post(
        '/auth/register-seller',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la création du Seller: $e');
    }
  }

  // ============================
  // 2. Gestion de l'entreprise
  // ============================

  // Modifier le logo de l'entreprise
  Future<Response> updateCompanyLogo(String filePath) async {
  try {
    FormData formData;

    if (kIsWeb) {
      // Gestion pour le web
      final bytes = await XFile(filePath).readAsBytes(); // Lire les données du fichier
      formData = FormData.fromMap({
        'logo': MultipartFile.fromBytes(
          bytes,
          filename: filePath.split('/').last, // Nom du fichier
        ),
      });
    } else {
      // Gestion pour mobile/desktop
      formData = FormData.fromMap({
        'logo': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last, // Nom du fichier
        ),
      });
    }

    print("Envoi des données au serveur : ${formData.fields}");
    print("URL de l'endpoint : /user/update-logo");

    final response = await _dio.post(
      '/user/update-logo',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_accessToken', // Ajoutez votre token ici
        },
      ),
    );

    return response;
  } catch (e) {
    print("Erreur lors de la mise à jour du logo : $e");
    throw Exception('Erreur lors de la mise à jour du logo de l\'entreprise: $e');
  }
}

  // Modifier le nom de l'entreprise
  Future<Response> updateCompanyName(String name) async {
    try {
      final response = await _dio.put(
        '/user/update/company-name',
        data: {
          'name': name,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      print(response.data);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du nom de l\'entreprise: $e');
    }
  }

  // Récupération des informations de l'utilisateur ou de l'entreprise
  Future<Response> fetchCompanyUserInfo() async {
    try {
      final response = await _dio.get(
        '/user/comp-user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken', // Ajout du token d'accès
          },
        ),
      );
      print(response.data);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des informations de l\'utilisateur ou de l\'entreprise: $e');
    }
  }

  // ============================
  // 3. Gestion des catégories
  // ============================

  // Récupération des catégories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get(
        '/categories',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      List<Category> categories = (response.data as List)
          .map((json) => Category.fromJson(json))
          .toList();
      return categories;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des catégories: $e');
    }
  }

  // Ajout d'une catégorie
  Future<Response> addCategory(String title) async {
    try {
      final response = await _dio.post(
        '/categories',
        data: {
          'title': title,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la catégorie: $e');
    }
  }

  // Mise à jour d'une catégorie
  Future<Response> updateCategory(String categoryId, String title) async {
    try {
      final response = await _dio.put(
        '/categories/$categoryId',
        data: {
          'title': title,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la catégorie: $e');
    }
  }

  Future<Category> fetchCategoryById(String categoryId) async {
    try {
      final response = await _dio.get('/categories/$categoryId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          ));
      return Category.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la catégorie: $e');
    }
  }

  // Suppression d'une catégorie
  Future<Response> deleteCategory(String categoryId) async {
    try {
      final response = await _dio.delete(
        '/categories/$categoryId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la catégorie: $e');
    }
  }

  // ============================
  // 4. Gestion des items
  // ============================

  // Récupération des items
  Future<List<Item>> fetchItems() async {
    try {
      final response = await _dio.get(
        '/items',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      List<Item> items = (response.data as List)
          .map((json) => Item.fromJson(json))
          .toList();
      return items;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des items: $e');
    }
  }

  Future<List<Item>> fechtRuptureItems() async {
    try {
      final response = await _dio.get('/items/low-stock',
          options: Options(
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          ));
      List<Item> items = (response.data as List)
          .map((json) => Item(
                id: json['id'],
                name: json['name'],
                quantity: json['quantity'],
                unitPrice: json['unitPrice'],
                itemsTotal: json['itemsTotal'],
                createdAt: DateTime.parse(json['createdAt']),
                createdById: json['createdById'],
                updatedAt: json['updatedAt'] != null
                    ? DateTime.parse(json['updatedAt'])
                    : null,
                categoryId: json['categoryId'],
              ))
          .toList();
      return items;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des items: $e');
    }
  }

  Future<Response> retirerStok(Item item, int quantity) async {
    try {
      final response = await _dio.patch('/items/${item.id}/remove-stock',
          data: {
            'quantity': quantity,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          ));
      return response;
    } catch (e) {
      print(e);
      throw Exception('Erreur lors de l\'ajout de l\'item: $e');
    }
  }

  Future<Response> ajouterStock(Item item, int quantity) async {
    try {
      final response = await _dio.patch(
        '/items/${item.id}/add-stock',
        data: {
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      print(e);
      throw Exception('Erreur lors de l\'ajout du stock: $e');
    }
  }

  // Ajout d'un item
  Future<Response> addItem(String name, int quantity, int unitPrice, String categoryId) async {
    try {
      final response = await _dio.post(
        '/items/$categoryId',
        data: {
          'name': name,
          'quantity': quantity,
          'unitPrice': unitPrice,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      print(e);
      throw Exception('Erreur lors de l\'ajout de l\'item: $e');
    }
  }

  Future<Item> fetchItemById(String itemId) async {
    try {
      final response = await _dio.get('/items/$itemId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          ));
      return Item.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'item: $e');
    }
  }

  // Mise à jour d'un item
  Future<Response> updateItem(String itemId, String name, int unitPrice, int quantity) async {
    try {
      final response = await _dio.put(
        '/items/$itemId',
        data: {
          'name': name,
          'unitPrice': unitPrice,
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      print(response.data);
      return response;
    } catch (e) {
      print(e);
      throw Exception('Erreur lors de la mise à jour de l\'item: $e');
    }
  }

  // Suppression d'un item
  Future<Response> deleteItem(String itemId) async {
    try {
      final response = await _dio.delete(
        '/items/$itemId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'item: $e');
    }
  }

  Future<List<ActionItem>> fetchActionItems() async {
    try {
      final response = await _dio.get('/items/history');
      List<ActionItem> actionItems = (response.data as List)
          .map((item) => ActionItem.fromJson(item))
          .toList();
      return actionItems;
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      return [];
    }
  }

  Future<Response> addSales(String custumeranme, String custumerAdress,
      int discount, List<Map<String, dynamic>> items) async {
    try {
      // print(items.toString());
      final response = await _dio.post(
        '/sales',
        data: {
          'custumerName': 'Abdoul Latif',
          'custumerAddress': 'Zinder',
          'items': [
            {"itemId": "67cffffb2cac972d70320a4e", "quantity": 1},
            {"itemId": "67d05a5a2cac972d70320a51", "quantity": 3}
          ],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la catégorie: $e');
    }
  }
}
