import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_center_web/models/shop.dart';

class ShopService {
  String collection = 'shop';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList() {
    return FirebaseFirestore.instance
        .collection(collection)
        .orderBy('priority', descending: false)
        .snapshots();
  }

  Future<List<ShopModel>> selectList() async {
    List<ShopModel> ret = [];
    await firestore
        .collection(collection)
        .orderBy('priority', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(ShopModel.fromSnapshot(map));
      }
    });
    return ret;
  }
}
