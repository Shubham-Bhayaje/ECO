/// Model representing a driver's verification document (DL or RC).
class DriverDocumentModel {
  final String id;
  final String userId;
  final String docType; // 'DL' or 'RC'
  final String frontUrl; // S3 URL
  final String? backUrl; // S3 URL (for DL back)
  final String status; // pending, verified, rejected
  final DateTime? reviewedAt;
  final DateTime createdAt;

  const DriverDocumentModel({
    required this.id,
    required this.userId,
    required this.docType,
    required this.frontUrl,
    this.backUrl,
    this.status = 'pending',
    this.reviewedAt,
    required this.createdAt,
  });

  /// Whether this document has been verified.
  bool get isVerified => status == 'verified';

  /// Whether this document is pending review.
  bool get isPending => status == 'pending';

  /// Whether this document was rejected.
  bool get isRejected => status == 'rejected';

  factory DriverDocumentModel.fromJson(Map<String, dynamic> json) {
    return DriverDocumentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      docType: json['doc_type'] as String,
      frontUrl: json['front_url'] as String,
      backUrl: json['back_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'doc_type': docType,
      'front_url': frontUrl,
      'back_url': backUrl,
      'status': status,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  DriverDocumentModel copyWith({
    String? id,
    String? userId,
    String? docType,
    String? frontUrl,
    String? backUrl,
    String? status,
    DateTime? reviewedAt,
    DateTime? createdAt,
  }) {
    return DriverDocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      docType: docType ?? this.docType,
      frontUrl: frontUrl ?? this.frontUrl,
      backUrl: backUrl ?? this.backUrl,
      status: status ?? this.status,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'DriverDocumentModel(id: $id, userId: $userId, docType: $docType, status: $status)';
  }
}
