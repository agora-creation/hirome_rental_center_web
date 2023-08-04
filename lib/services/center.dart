import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_center_web/models/center.dart';

class CenterService {
  String collection = 'center';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<CenterModel?> select(String? id) async {
    CenterModel? ret;
    await firestore.collection(collection).doc(id).get().then((value) {
      ret = CenterModel.fromSnapshot(value);
    });
    return ret;
  }
}
