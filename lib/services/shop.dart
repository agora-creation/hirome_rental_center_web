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

  Future<ShopModel?> selectTenant(String tenantNumber) async {
    ShopModel? ret;
    await firestore
        .collection(collection)
        .where('tenantNumber', isEqualTo: tenantNumber)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = ShopModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
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
