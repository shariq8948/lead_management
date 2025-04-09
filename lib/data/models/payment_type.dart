class PaymentMode {
  int? id;
  String? paymentType;
  String? paymentMode;
  String? ledger;
  int? ledgerId;

  PaymentMode({
    this.id,
    this.paymentType,
    this.paymentMode,
    this.ledger,
    this.ledgerId,
  });

  // Factory method to create a PaymentMode from a JSON object
  factory PaymentMode.fromJson(Map<String, dynamic> json) {
    return PaymentMode(
      id: json['id'],
      paymentType: json['paymenttype'],
      paymentMode: json['paymentmode'],
      ledger: json['ledger'],
      ledgerId: json['ledgerid'],
    );
  }

  // Method to convert the PaymentMode instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymenttype': paymentType,
      'paymentmode': paymentMode,
      'ledger': ledger,
      'ledgerid': ledgerId,
    };
  }
}
