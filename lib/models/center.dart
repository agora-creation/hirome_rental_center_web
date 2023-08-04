import 'package:cloud_firestore/cloud_firestore.dart';

class CenterModel {
  String _id = '';
  String _token = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  CenterModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _token = map['token'] ?? '';
    _createdAt = map['createdAt'].toDate() ?? DateTime.now();
  }
}
