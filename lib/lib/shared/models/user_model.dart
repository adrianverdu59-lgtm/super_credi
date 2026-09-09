enum UserLevel { bronce, plata, oro }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String cedula;
  final int paidInstallmentsCount;
  final double creditLimitUsd;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cedula,
    required this.paidInstallmentsCount,
    required this.creditLimitUsd,
  });

  // Regla de niveles: 0-29 Bronce, 30-69 Plata, 70+ Oro
  UserLevel get level {
    if (paidInstallmentsCount >= 70) {
      return UserLevel.oro;
    } else if (paidInstallmentsCount >= 30) {
      return UserLevel.plata;
    } else {
      return UserLevel.bronce;
    }
  }

  String get levelLabel {
    switch (level) {
      case UserLevel.oro:
        return 'Oro';
      case UserLevel.plata:
        return 'Plata';
      case UserLevel.bronce:
        return 'Bronce';
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      cedula: json['cedula'],
      paidInstallmentsCount: json['paid_installments_count'] ?? 0,
      creditLimitUsd: (json['credit_limit_usd'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'cedula': cedula,
      'paid_installments_count': paidInstallmentsCount,
      'credit_limit_usd': creditLimitUsd,
    };
  }
}
