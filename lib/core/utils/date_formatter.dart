import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date, {String pattern = 'dd MMM yyyy'}) =>
      DateFormat(pattern).format(date);

  static String formatShort(DateTime date) =>
      DateFormat('dd.MM.yyyy').format(date);

  static String formatWithTime(DateTime date) =>
      DateFormat('dd MMM yyyy, HH:mm').format(date);

  static String formatMonthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  static String formatMonth(DateTime date) => DateFormat('MMM').format(date);

  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff == -1) return 'Tomorrow';
    return format(date);
  }
}
