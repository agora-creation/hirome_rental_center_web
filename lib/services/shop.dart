import 'package:cloud_firestore/cloud_firestore.dart';

class ShopService {
  String collection = 'shop';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList() {
    return FirebaseFirestore.instance
        .collection(collection)
        .orderBy('priority', descending: false)
        .snapshots();
  }
}
