import 'package:firebase_database/firebase_database.dart';
import '../../models/subscription_model.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference _userRef(String uid) =>
      _db.ref('users/$uid/subscriptions');

  Future<List<Subscription>> fetchAll(String uid) async {
    final snapshot = await _userRef(uid).get();
    if (!snapshot.exists) return [];
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.values
        .map((v) =>
            Subscription.fromJson(Map<String, dynamic>.from(v as Map)))
        .toList();
  }

  Future<void> save(String uid, Subscription sub) async {
    await _userRef(uid).child(sub.id).set(sub.toJson());
  }

  Future<void> delete(String uid, String subId) async {
    await _userRef(uid).child(subId).remove();
  }

  Stream<List<Subscription>> stream(String uid) {
    return _userRef(uid).onValue.map((event) {
      if (event.snapshot.value == null) return [];
      final data =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.values
          .map((v) =>
              Subscription.fromJson(Map<String, dynamic>.from(v as Map)))
          .toList();
    });
  }
}
