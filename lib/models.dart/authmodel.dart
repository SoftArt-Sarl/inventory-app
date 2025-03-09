import 'dart:convert';
import 'package:flutter_application_1/models.dart/Usermodel.dart';
// import 'package:frontend/models/adminModel.dart';

class AuthModel {
  dynamic access_token;
  User? user;
  dynamic expires_at;
  dynamic refresh_token;
  dynamic isPasswordInit;
  dynamic id;
  AuthModel(
      {this.access_token,
      this.id,
      this.user,
      this.expires_at,
      this.refresh_token,
      this.isPasswordInit});
  factory AuthModel.formjson(Map<String, dynamic> json) {
    return AuthModel(
        user: User.fromJson(json['user']),
        access_token: json['access_token'],
        isPasswordInit: json['isPasswordInit'],
        expires_at: json['exp'],
        refresh_token: json['refresh_token']);
  }
  Map<String, dynamic> tojson() {
    return {
      'user': user!.toJson(),
      'access_token': access_token,
      'exp': expires_at,
      'isPasswordInit': isPasswordInit,
      'refresh_token': refresh_token
    };
  }
}
