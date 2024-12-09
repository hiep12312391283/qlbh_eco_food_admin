import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  String accountId;
  String email;
  String password;
  String role;
  String? documentId;

  AccountModel({
    required this.accountId,
    required this.email,
    required this.password,
    required this.role,
    this.documentId,
  });

  factory AccountModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AccountModel(
      accountId: doc.id,
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? 'user', // Default role is 'user'
      documentId: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
