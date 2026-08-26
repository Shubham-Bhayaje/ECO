import '../models/review_model.dart';

/// Manages the two-way rating system for both drivers and riders.
abstract class RatingService {
  Future<void> submitReview({
    required String reviewerId,
    required String revieweeId,
    required String rideId,
    required double rating,
    String? comment,
    List<String>? compliments,
  });

  Future<List<ReviewModel>> getUserReviews(String userId);
  Future<double> getAverageRating(String userId);
}

class DefaultRatingService implements RatingService {
  final List<ReviewModel> _reviews = [];

  @override
  Future<void> submitReview({
    required String reviewerId,
    required String revieweeId,
    required String rideId,
    required double rating,
    String? comment,
    List<String>? compliments,
  }) async {
    final review = ReviewModel(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      reviewerId: reviewerId,
      revieweeId: revieweeId,
      rideId: rideId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    _reviews.add(review);
  }

  @override
  Future<List<ReviewModel>> getUserReviews(String userId) async {
    return _reviews.where((r) => r.revieweeId == userId).toList();
  }

  @override
  Future<double> getAverageRating(String userId) async {
    final userReviews = await getUserReviews(userId);
    if (userReviews.isEmpty) return 4.9; // Default positive rating
    final total = userReviews.fold<double>(0, (sum, r) => sum + r.rating);
    return total / userReviews.length;
  }
}
