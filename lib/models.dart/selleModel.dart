class Seller {
  String id;
  String email;
  String name;
  String password;
  DateTime createdAt;
  String refreshToken;
  String role;
  String companyId;

  Seller({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.createdAt,
    required this.refreshToken,
    required this.role,
    required this.companyId,
  });

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      password: map['password'],
      createdAt: DateTime.parse(map['createdAt']),
      refreshToken: map['refresh_token'],
      role: map['role'],
      companyId: map['companyId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'refresh_token': refreshToken,
      'role': role,
      'companyId': companyId,
    };
  }
}