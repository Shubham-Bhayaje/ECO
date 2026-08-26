class SubscriptionModel {
  final String id;
  final String userId;
  final String plan;
  final DateTime startDate;
  final DateTime expiryDate;
  final String? paymentId;
  final String status;
  final DateTime createdAt;

  const SubscriptionModel({
    required this.id,
    required this.userId,
    required this.plan,
    required this.startDate,
    required this.expiryDate,
    this.paymentId,
    required this.status,
    required this.createdAt,
  });

  bool get isActive => status == 'active' && DateTime.now().isBefore(expiryDate);

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? plan,
    DateTime? startDate,
    DateTime? expiryDate,
    String? paymentId,
    String? status,
    DateTime? createdAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      paymentId: paymentId ?? this.paymentId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      plan: json['plan'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      paymentId: json['paymentId'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plan': plan,
      'startDate': startDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'paymentId': paymentId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, userId: $userId, plan: $plan, status: $status)';
  }
}
