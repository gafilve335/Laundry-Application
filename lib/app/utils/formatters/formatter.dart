import 'package:intl/intl.dart';

class TFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy')
        .format(date); 
  }

  static String formatCurrency(double amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'th_TH', symbol: '฿');
    return currencyFormatter.format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 9) {
      return '${digitsOnly.substring(0, 2)}-${digitsOnly.substring(2, 5)}-${digitsOnly.substring(5)}';
    } else if (digitsOnly.length == 10) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    }

    return phoneNumber;
  }
}
