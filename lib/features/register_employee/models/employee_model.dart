import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String id;
  String email;
  String phone;
  String name;
  String? documentId;

  EmployeeModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    this.documentId,
  });

  factory EmployeeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EmployeeModel(
      id: doc.id,
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      name: data['name'] ?? '',
      documentId: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'documentId': documentId,
    };
  }
}
