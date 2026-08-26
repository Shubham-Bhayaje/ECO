class UserModel {
  final String id;
  final String? firebaseUid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String? profileImageUrl;
  final bool isVerified;
  final double rating;
  final int totalRides;
  final int cancellationCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    this.firebaseUid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    this.profileImageUrl,
    required this.isVerified,
    required this.rating,
    required this.totalRides,
    required this.cancellationCount,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  UserModel copyWith({
    String? id,
    String? firebaseUid,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? profileImageUrl,
    bool? isVerified,
    double? rating,
    int? totalRides,
    int? cancellationCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      cancellationCount: cancellationCount ?? this.cancellationCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firebaseUid: json['firebaseUid'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      isVerified: json['isVerified'] as bool,
      rating: (json['rating'] as num).toDouble(),
      totalRides: json['totalRides'] as int,
      cancellationCount: json['cancellationCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'isVerified': isVerified,
      'rating': rating,
      'totalRides': totalRides,
      'cancellationCount': cancellationCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone)';
  }
}
