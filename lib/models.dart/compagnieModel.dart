class CompanyUserInfo {
  String companyName;
  String companyLogo;
  String userName;

  CompanyUserInfo({
    required this.companyName,
    required this.companyLogo,
    required this.userName,
  });

  // Factory pour créer une instance à partir d'un JSON
  factory CompanyUserInfo.fromJson(Map<String, dynamic> json) {
    return CompanyUserInfo(
      companyName: json['companyName'] ?? '',
      companyLogo: json['companyLogo'] ?? '',
      userName: json['userName'] ?? '',
    );
  }

  // Méthode pour convertir l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'companyLogo': companyLogo,
      'userName': userName,
    };
  }
}