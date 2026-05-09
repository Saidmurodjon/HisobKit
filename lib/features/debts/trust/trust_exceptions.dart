class TamperedDebtException implements Exception {
  final String expected;
  final String actual;
  TamperedDebtException({required this.expected, required this.actual});
  @override
  String toString() => 'TamperedDebtException: hash mismatch';
}

class InvalidSignatureException implements Exception {
  final String role;
  final String publicKey;
  InvalidSignatureException({required this.role, required this.publicKey});
  @override
  String toString() => 'InvalidSignatureException: $role signature invalid';
}

class QrTooLargeException implements Exception {
  final int bytes;
  QrTooLargeException(this.bytes);
  @override
  String toString() => 'QrTooLargeException: $bytes bytes > 2800';
}

class ContactNotFoundException implements Exception {
  final String publicKey;
  ContactNotFoundException(this.publicKey);
}

class SyncDeliveryException implements Exception {
  final String method;
  final String reason;
  SyncDeliveryException({required this.method, required this.reason});
}

class DebtExpiredException implements Exception {
  final int debtId;
  final DateTime expiredAt;
  DebtExpiredException({required this.debtId, required this.expiredAt});
}
