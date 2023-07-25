import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  String collection = 'product';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required bool viewWash,
  }) {
    if (viewWash == true) {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('category', isEqualTo: 9)
          .orderBy('category')
          .orderBy('priority', descending: false)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('category', isNotEqualTo: 9)
          .orderBy('category')
          .orderBy('priority', descending: false)
          .snapshots();
    }
  }
}
