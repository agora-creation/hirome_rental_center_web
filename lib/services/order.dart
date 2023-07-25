import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_center_web/common/functions.dart';

class OrderService {
  String collection = 'order';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList() {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('status', isEqualTo: 0)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamHistoryList({
    required DateTime searchStart,
    required DateTime searchEnd,
  }) {
    Timestamp startAt = convertTimestamp(searchStart, false);
    Timestamp endAt = convertTimestamp(searchEnd, true);
    return FirebaseFirestore.instance
        .collection(collection)
        .where('status', isNotEqualTo: 0)
        .orderBy('createdAt', descending: true)
        .startAt([endAt]).endAt([startAt]).snapshots();
  }
}
