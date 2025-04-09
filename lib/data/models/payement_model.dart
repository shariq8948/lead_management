class PaymentModeModel {
  final String id;
  final String paymentType;
  final String paymentMode;
  final String ledgerId;
  final String paymentLedger;

  PaymentModeModel({
    required this.id,
    required this.paymentType,
    required this.paymentMode,
    required this.ledgerId,
    required this.paymentLedger,
  });

  // Factory constructor to create an instance from JSON
  factory PaymentModeModel.fromJson(Map<String, dynamic> json) {
    return PaymentModeModel(
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
