import 'package:cloud_firestore/cloud_firestore.dart';

class Myuser {
  static String collectionName = 'users';
  final String email;
  final String password;
  final String id;

  Myuser({
    required this.email,
    required this.password,
    required this.id,
  });

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['id'] = id;
    return data;
  }

  factory Myuser.fromFirestore(Map<String, dynamic> json) {
    return Myuser(
      email: json['email'],
      password: json['password'],
      id: json['id'] as String,
    );
  }
}
