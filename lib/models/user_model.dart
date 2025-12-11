//simpan nama, email, berat badan

// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String userName;
  final double weight;

  UserModel({
    required this.uid,
    required this.email,
    required this.userName,
    required this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'weight': weight,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      userName: json['userName'] as String,
      weight: (json['weight'] as num).toDouble(),
    );
  }
}