class ReviewModel {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final String rideId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.rideId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? reviewerId,
    String? revieweeId,
    String? rideId,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      reviewerId: reviewerId ?? this.reviewerId,
      revieweeId: revieweeId ?? this.revieweeId,
      rideId: rideId ?? this.rideId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      reviewerId: json['reviewerId'] as String,
      revieweeId: json['revieweeId'] as String,
      rideId: json['rideId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'rideId': rideId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, rideId: $rideId, rating: $rating)';
  }
}
