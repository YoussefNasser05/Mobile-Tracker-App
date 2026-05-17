import 'package:intl/intl.dart';

class AppDateUtils {
  static final _fmt = DateFormat('MMM d, yyyy');

  static String format(DateTime date) => _fmt.format(date);

  static DateTime nextBillingDate(DateTime startDate, String billingCycle) {
    switch (billingCycle) {
      case 'yearly':
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
      case 'weekly':
        return startDate.add(const Duration(days: 7));
      default:
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
    }
  }
}
