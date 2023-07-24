import 'package:cloud_firestore/cloud_firestore.dart';

class ShopLoginModel {
  String _id = '';
  String _shopNumber = '';
  String _shopName = '';
  String _deviceName = '';
  bool _accept = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get shopNumber => _shopNumber;
  String get shopName => _shopName;
  String get deviceName => _deviceName;
  bool get accept => _accept;
  DateTime get createdAt => _createdAt;

  ShopLoginModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _shopNumber = map['shopNumber'] ?? '';
    _shopName = map['shopName'] ?? '';
    _deviceName = map['deviceName'] ?? '';
    _accept = map['accept'] ?? false;
    _createdAt = map['createdAt'].toDate() ?? DateTime.now();
  }
}
