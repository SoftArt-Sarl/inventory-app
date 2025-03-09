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
  // var remoteUrl = 'https://parapheur.vercel.app/api/v1';
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

    // print(authmodel.value.departements!.first.isCreditAgricole);
  }

  Future<String?> getAuthModel(String authmodelKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedAuthModel = prefs.getString(authmodelKey);
    print(cachedAuthModel.toString());

    if (cachedAuthModel == null) {
      
      isAndroid()
          ? Get.offAll(() =>  LoginPage())
          : Get.offAll(() =>  LoginPage());
      print('authmodel not found for key: $authmodelKey');
      return null;
    }

    var mapp = jsonDecode(cachedAuthModel);
    authmodel.value = AuthModel.formjson(mapp);
    if (await refreshAccessToken()) {
      isAndroid()
          ? Get.offAll(() =>  LoginPage())
          : Get.offAll(() =>  LoginPage());
      return null;
    }
   apiController. fetchCategories();
   apiController. fetchItems();
   apiController.fechAction();
    Get.offAll(()=>const HomePage());
    // _navigateBasedOnUserRole();
    return cachedAuthModel;
  }

  Future<void> saveAuthModel(String authmodelKey, String authModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authmodelKey, authModel);
  }

  bool isTokenExpired(dynamic expiresAt) {
    return DateTime.now().millisecondsSinceEpoch / 1000 > expiresAt;
  }

// 1723070005
  Future<bool> refreshAccessToken() async {
    if (isTokenExpired(authmodel.value.expires_at)) {
      print('Le access_token est expiré');
      return true;
    } else {
      return false;
    }
  }

  

  Future<void> logout() async {
    Get.defaultDialog(content: SizedBox(height: 50,width: 50,child: const CircularProgressIndicator(),));
    // utility.loader();
    await Future.delayed(const Duration(seconds: 3));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authmodel');
    // authmodel.value=AuthModel();
    isAndroid()
        ? Get.offAll(() =>  LoginPage())
        : Get.offAll(() =>  LoginPage());
  }

  void refreshedPage() {
    Get.appUpdate();
  }
}
