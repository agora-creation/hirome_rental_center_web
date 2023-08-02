import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_center_web/models/product.dart';

class ProductService {
  String collection = 'product';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList() {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('category', isNotEqualTo: 9)
        .orderBy('category')
        .orderBy('priority', descending: false)
        .snapshots();
  }

  Future<List<ProductModel>> selectList({int? category}) async {
    List<ProductModel> ret = [];
    await firestore
        .collection(collection)
        .where('category', isEqualTo: category)
        .orderBy('priority', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(ProductModel.fromSnapshot(map));
      }
    });
    return ret;
  }
}
