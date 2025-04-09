class PaymentDetail {
  final String id;
  final String paymentType;
  final String paymentMode;
  final String ledgerId;
  final String paymentLedger;

  PaymentDetail({
    required this.id,
    required this.paymentType,
    required this.paymentMode,
    required this.ledgerId,
    required this.paymentLedger,
  });

  // Factory constructor to create an instance from JSON
  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      id: json['id'] ?? '',
      paymentType: json['paymenttype'] ?? '',
      paymentMode: json['paymentmode'] ?? '',
      ledgerId: json['ledgerid'] ?? '',
      paymentLedger: json['paymentledger'] ?? '',
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymenttype': paymentType,
      'paymentmode': paymentMode,
      'ledgerid': ledgerId,
      'paymentledger': paymentLedger,
    };
  }
}
