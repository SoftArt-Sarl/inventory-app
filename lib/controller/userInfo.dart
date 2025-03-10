import 'dart:async'; // Ajouter cette importation pour Timer
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models.dart/authmodel.dart';
import 'package:flutter_application_1/pages/loginPage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userinfo extends GetxController {
  static Userinfo instance = Get.find();
  Rx<AuthModel> authmodel = AuthModel().obs;
  Timer? _tokenExpiryTimer; // Déclare une variable pour le Timer

  // Méthode pour vérifier si l'application est sur Android ou Web
  bool isAndroid() {
    if (kIsWeb) {
      return false;
    } else {
      return defaultTargetPlatform == TargetPlatform.android;
    }
  }

  @override
  void onReady() {
    super.onReady();
    getAuthModel('authmodel');
  }

  // Méthode pour récupérer le modèle d'authentification
  Future<String?> getAuthModel(String authmodelKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedAuthModel = prefs.getString(authmodelKey);
    print(cachedAuthModel.toString());

    // Si le modèle d'authentification n'est pas trouvé
    if (cachedAuthModel == null) {
      isAndroid() ? Get.offAll(() => LoginPage()) : Get.offAll(() => LoginPage());
      print('authmodel not found for key: $authmodelKey');
      return null;
    }

    // Décoder le modèle d'authentification
    var mapp = jsonDecode(cachedAuthModel);
    authmodel.value = AuthModel.formjson(mapp);

    // Vérifier si le token est expiré
    if (await refreshAccessToken()) {
      // Si le token est expiré, rediriger vers la page de connexion
      isAndroid() ? Get.offAll(() => LoginPage()) : Get.offAll(() => LoginPage());
      print('Token expired');
      return null;
    }

    // Si le token est valide, rafraîchir l'API et rediriger vers la page d'accueil
    apiController.refresh();
    Get.offAll(() => HomePage());

    // Lancer la surveillance continue du token
    _startTokenExpiryCheck();

    return cachedAuthModel;
  }

  // Surveillance continue pour vérifier l'expiration du token
  void _startTokenExpiryCheck() {
    _tokenExpiryTimer?.cancel(); // Annuler le précédent timer s'il existe
    _tokenExpiryTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      if (await refreshAccessToken()) {
        // Si le token est expiré, rediriger vers la page de connexion
        isAndroid() ? Get.offAll(() => LoginPage()) : Get.offAll(() => LoginPage());
        print('Token expired (periodic check)');
        _tokenExpiryTimer?.cancel(); // Arrêter le timer une fois que l'utilisateur est redirigé
      }
    });
  }

  // Méthode pour sauvegarder le modèle d'authentification
  Future<void> saveAuthModel(String authmodelKey, String authModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authmodelKey, authModel);
  }

  // Vérifier si le token a expiré
  bool isTokenExpired(dynamic expiresAt) {
    return DateTime.now().millisecondsSinceEpoch / 1000 > expiresAt;
  }

  // Vérifier si le token d'accès est expiré
  Future<bool> refreshAccessToken() async {
    if (isTokenExpired(authmodel.value.expires_at)) {
      print('Le access_token est expiré');
      return true;
    } else {
      return false;
    }
  }

  // Méthode pour se déconnecter
  Future<void> logout() async {
    Get.defaultDialog(content:const  SizedBox(height: 50, width: 50, child: const CircularProgressIndicator(),));
    await Future.delayed(const Duration(seconds: 3));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authmodel');
    isAndroid() ? Get.offAll(() => LoginPage()) : Get.offAll(() => LoginPage());
  }

  // Rafraîchir la page
  void refreshedPage() {
    Get.appUpdate();
  }

  // Arrêter le timer lorsque le contrôleur est supprimé
  @override
  void onClose() {
    _tokenExpiryTimer?.cancel();
    super.onClose();
  }
}
