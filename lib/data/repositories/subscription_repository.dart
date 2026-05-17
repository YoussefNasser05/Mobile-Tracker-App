import '../local/subscription_dao.dart';
import '../remote/firebase_service.dart';
import '../../models/subscription_model.dart';

class SubscriptionRepository {
  final SubscriptionDao _local = SubscriptionDao();
  final FirebaseService _remote = FirebaseService();

  Future<List<Subscription>> loadAll(String uid) async {
    final local = await _local.getAll();
    try {
      final remote = await _remote.fetchAll(uid);
      if (remote.isNotEmpty) {
        await _local.upsertAll(remote);
        return remote;
      }
    } catch (_) {
      // Offline — return local cache
    }
    return local;
  }

  Future<void> add(String uid, Subscription sub) async {
    await _local.insert(sub);
    await _remote.save(uid, sub);
  }

  Future<void> update(String uid, Subscription sub) async {
    await _local.update(sub);
    await _remote.save(uid, sub);
  }

  Future<void> delete(String uid, String subId) async {
    await _local.delete(subId);
    await _remote.delete(uid, subId);
  }
}
