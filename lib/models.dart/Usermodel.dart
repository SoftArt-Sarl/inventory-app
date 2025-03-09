import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';

class User {
  dynamic id;
  dynamic email;
  dynamic name;
  dynamic password;
  dynamic createdAt;
  dynamic role;
  dynamic items;
  dynamic category;

  User({
    this.id,
    this.email,
    this.name,
    this.password,
    this.createdAt,
    this.role,
    this.items,
    this.category,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      createdAt: json['createdAt'],
      role: json['role'],
      items: json['items'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'createdAt': createdAt,
      'role': role,
      'items': items,
      'category': category,
    };
  }
}
