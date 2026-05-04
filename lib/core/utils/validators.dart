class Validators {
  static String? required(String? value, {String message = 'This field is required'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) return 'Invalid amount';
    if (parsed <= 0) return 'Amount must be greater than 0';
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.length < 4) return 'PIN must be at least 4 digits';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'PIN must contain only digits';
    return null;
  }
}
