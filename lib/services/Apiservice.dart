import 'package:dio/dio.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/Usermodel.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/models.dart/historiqueModel.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: 'https://agricultural-stevana-softart-comp-fab2bc8e.koyeb.app'),
  );

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
    Future<Response> updatePassword(String newPassword) async {
    try {
      final response = await _dio.post(
        '/auth/password/update',
        data: {
          'password': newPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du mot de passe: $e');
    }
  }


  // Récupération des catégories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
      // print(response.data.toString());
      List<Category> categories = (response.data as List)
          .map((json) => Category(
                id: json['id'],
                total: json['total'],
                title: json['title'],
                createdById: json['createdById'],
                updatedAt: json['updatedAt'] != null
                    ? DateTime.parse(json['updatedAt'])
                    : null,
                items:(json['items'] != null && json['items'] is List)
          ? (json['items'] as List)
              .whereType<Map<String, dynamic>>() // Assure que chaque élément est bien un Map
              .map((item) => Item.fromJson(item))
              .toList()
          : [],
              ))
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
            'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
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
      final response = await _dio.put('/categories/$categoryId',
          data: {
            'title': title,
          },
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
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
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
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
      final response = await _dio.delete('/categories/$categoryId',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la catégorie: $e');
    }
  }

  // Récupération des items
  Future<List<Item>> fetchItems() async {
    try {
      final response = await _dio.get('/items',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
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

Future<List<Item>> fechtRuptureItems() async {
    try {
      final response = await _dio.get('/items/low-stock',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
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
Future<Response> retirerStok(Item item,int quantity) async {
    try {
      final response = await _dio.patch('/items/${item.id}/remove-stock/${item.categoryId}',
          data: {
            'quantity': quantity,
          },
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
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
      '/items/${item.id}/add-stock/${item.categoryId}',
      data: {
        'quantity': quantity,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
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
  Future<Response> addItem(String name, int quantity, int unitPrice,
       String categoryId) async {
    try {
      final response = await _dio.post('/items/$categoryId',
          data: {
            'name': name,
            'quantity': quantity,
            'unitPrice': unitPrice,
          },
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
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
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
      return Item.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'item: $e');
    }
  }
  // Mise à jour d'un item
  Future<Response> updateItem(String itemId,String categoryId, String name, int unitPrice,int quantity) async {
    try {
      final response = await _dio.put('/items/$itemId/category/$categoryId',
          data: {
            'name': name,
            'unitPrice': unitPrice,
            'quantity':quantity
          },
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
          print(response.data);
      return response;
    } catch (e) {
      print(e);
      throw Exception('Erreur lors de la mise à jour de l\'item: $e');
    }
  }

  // Suppression d'un item
  Future<Response> deleteItem(String itemId, String categoryId) async {
    try {
      final response = await _dio.delete('/items/$itemId/category/$categoryId',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
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
}
