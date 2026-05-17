import 'package:flutter/foundation.dart';
import '../data/repositories/subscription_repository.dart';
import '../models/subscription_model.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepository _repo = SubscriptionRepository();

  List<Subscription> _subscriptions = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUid;
  String _selectedCategory = 'all';

  List<Subscription> get subscriptions => _filtered;
  List<Subscription> get all => _subscriptions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  List<Subscription> get _filtered => _selectedCategory == 'all'
      ? _subscriptions
      : _subscriptions
          .where((s) => s.category == _selectedCategory)
          .toList();

  double get monthlyTotal => _subscriptions
      .where((s) => s.isActive)
      .fold(0.0, (sum, s) => sum + s.monthlyPrice);

  List<Subscription> get upcomingRenewals => _subscriptions
      .where((s) =>
          s.isActive &&
          s.daysUntilRenewal >= 0 &&
          s.daysUntilRenewal <= 7)
      .toList()
    ..sort((a, b) => a.daysUntilRenewal.compareTo(b.daysUntilRenewal));

  int get activeCount => _subscriptions.where((s) => s.isActive).length;

  Future<void> onAuthChanged(String? uid) async {
    if (_currentUid == uid) return;
    _currentUid = uid;
    if (uid != null) {
      await loadAll();
    } else {
      _subscriptions = [];
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadAll() async {
    if (_currentUid == null) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _subscriptions = await _repo.loadAll(_currentUid!);
    } catch (e) {
      _errorMessage = 'Failed to load subscriptions.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(Subscription sub) async {
    if (_currentUid == null) return;
    try {
      await _repo.add(_currentUid!, sub);
      _subscriptions.add(sub);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add subscription.';
      notifyListeners();
    }
  }

  Future<void> update(Subscription sub) async {
    if (_currentUid == null) return;
    try {
      await _repo.update(_currentUid!, sub);
      final index = _subscriptions.indexWhere((s) => s.id == sub.id);
      if (index != -1) {
        _subscriptions[index] = sub;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update subscription.';
      notifyListeners();
    }
  }

  Future<void> delete(String subId) async {
    if (_currentUid == null) return;
    try {
      await _repo.delete(_currentUid!, subId);
      _subscriptions.removeWhere((s) => s.id == subId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete subscription.';
      notifyListeners();
    }
  }

  Subscription? findById(String id) {
    try {
      return _subscriptions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
