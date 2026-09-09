class PaymentModel {
  final String id;
  final String loanId;
  final String userId;
  final double amountUsd;
  final double bcvRate;
  final double amountVes;
  final String bankOrigin;
  final String phoneSender;
  final String referenceNumber;
  final String status; // 'under_review', 'verified', 'rejected'
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.loanId,
    required this.userId,
    required this.amountUsd,
    required this.bcvRate,
    required this.amountVes,
    required this.bankOrigin,
    required this.phoneSender,
    required this.referenceNumber,
    required this.status,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      loanId: json['loan_id'] ?? '',
      userId: json['user_id'] ?? '',
      amountUsd: (json['amount_usd'] as num).toDouble(),
      bcvRate: (json['bcv_rate'] as num).toDouble(),
      amountVes: (json['amount_ves'] as num).toDouble(),
      bankOrigin: json['bank_origin'] ?? '',
      phoneSender: json['phone_sender'] ?? '',
      referenceNumber: json['reference_number'] ?? '',
      status: json['status'] ?? 'under_review',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loan_id': loanId,
      'user_id': userId,
      'amount_usd': amountUsd,
      'bcv_rate': bcvRate,
      'amount_ves': amountVes,
      'bank_origin': bankOrigin,
      'phone_sender': phoneSender,
      'reference_number': referenceNumber,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
