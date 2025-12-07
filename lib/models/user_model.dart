import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? role;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    // Gérer les différents formats de champs (backend vs frontend)
    final id = json['id'] as int?;
    
    // Username peut être 'username' ou 'nomUtilisateur'
    final username = json['username'] as String? ?? json['nomUtilisateur'] as String?;
    
    // Email
    final email = json['email'] as String?;
    
    // FirstName peut être 'firstName' ou 'prenom'
    final firstName = json['firstName'] as String? ?? json['prenom'] as String?;
    
    // LastName peut être 'lastName' ou 'nom'
    final lastName = json['lastName'] as String? ?? json['nom'] as String?;
    
    // Phone peut être 'phone' ou 'numeroTelephone'
    final phone = json['phone'] as String? ?? json['numeroTelephone'] as String?;
    
    // Role peut être dans 'role', 'roleCode', ou 'roleDTO.code'
    String? role;
    if (json['role'] != null) {
      // Si c'est un objet, extraire le code
      if (json['role'] is Map) {
        role = json['role']['code'] as String? ?? json['role']['name'] as String?;
      } else {
        role = json['role'].toString();
      }
    } else if (json['roleCode'] != null) {
      role = json['roleCode'] as String?;
    } else if (json['roleDTO'] != null && json['roleDTO'] is Map) {
      role = json['roleDTO']['code'] as String?;
    }
    
    // Normaliser le rôle en majuscules
    if (role != null) {
      role = role.toUpperCase();
    }
    
    // isActive
    final isActive = json['isActive'] as bool? ?? json['isActive'] as bool?;
    
    // Dates
    DateTime? createdAt;
    if (json['createdAt'] != null) {
      try {
        createdAt = DateTime.parse(json['createdAt'] as String);
      } catch (e) {
        // Ignorer si le format est invalide
      }
    } else if (json['dateDeCreation'] != null) {
      try {
        final dateStr = json['dateDeCreation'] as String;
        createdAt = DateTime.parse(dateStr);
      } catch (e) {
        // Ignorer si le format est invalide
      }
    }
    
    DateTime? updatedAt;
    if (json['updatedAt'] != null) {
      try {
        updatedAt = DateTime.parse(json['updatedAt'] as String);
      } catch (e) {
        // Ignorer si le format est invalide
      }
    }
    
    return User(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        phone,
        role,
        isActive,
      ];
}

