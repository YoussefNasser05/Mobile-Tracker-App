import 'package:uuid/uuid.dart';

class Subscription {
  final String id;
  final String name;
  final String category;
  final double price;
  final String currency;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final String billingCycle;
  final String? notes;
  final bool isActive;

  const Subscription({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.currency,
    required this.startDate,
    required this.nextBillingDate,
    required this.billingCycle,
    this.notes,
    this.isActive = true,
  });

  factory Subscription.create({
    required String name,
    required String category,
    required double price,
    required String currency,
    required DateTime startDate,
    required DateTime nextBillingDate,
    required String billingCycle,
    String? notes,
  }) {
    return Subscription(
      id: const Uuid().v4(),
      name: name,
      category: category,
      price: price,
      currency: currency,
      startDate: startDate,
      nextBillingDate: nextBillingDate,
      billingCycle: billingCycle,
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'currency': currency,
        'startDate': startDate.millisecondsSinceEpoch,
        'nextBillingDate': nextBillingDate.millisecondsSinceEpoch,
        'billingCycle': billingCycle,
        'notes': notes,
        'isActive': isActive ? 1 : 0,
      };

  factory Subscription.fromMap(Map<String, dynamic> map) => Subscription(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        price: (map['price'] as num).toDouble(),
        currency: map['currency'],
        startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
        nextBillingDate:
            DateTime.fromMillisecondsSinceEpoch(map['nextBillingDate']),
        billingCycle: map['billingCycle'],
        notes: map['notes'],
        isActive: map['isActive'] == 1,
      );

  Map<String, dynamic> toJson() => {
        ...toMap(),
        'isActive': isActive,
      };

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        price: (json['price'] as num).toDouble(),
        currency: json['currency'],
        startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
        nextBillingDate:
            DateTime.fromMillisecondsSinceEpoch(json['nextBillingDate']),
        billingCycle: json['billingCycle'],
        notes: json['notes'],
        isActive: json['isActive'] as bool,
      );

  Subscription copyWith({
    String? name,
    String? category,
    double? price,
    String? currency,
    DateTime? startDate,
    DateTime? nextBillingDate,
    String? billingCycle,
    String? notes,
    bool? isActive,
  }) =>
      Subscription(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        startDate: startDate ?? this.startDate,
        nextBillingDate: nextBillingDate ?? this.nextBillingDate,
        billingCycle: billingCycle ?? this.billingCycle,
        notes: notes ?? this.notes,
        isActive: isActive ?? this.isActive,
      );

  int get daysUntilRenewal =>
      nextBillingDate.difference(DateTime.now()).inDays;

  double get monthlyPrice {
    switch (billingCycle) {
      case 'yearly':
        return price / 12;
      case 'weekly':
        return price * 4.33;
      default:
        return price;
    }
  }
}
