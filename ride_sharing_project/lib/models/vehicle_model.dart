class VehicleModel {
  final String id;
  final String userId;
  final String make;
  final String model;
  final int? year;
  final String? color;
  final String fuelType;
  final double avgMileage;
  final String? numberPlate;
  final int totalSeats;
  final DateTime createdAt;

  const VehicleModel({
    required this.id,
    required this.userId,
    required this.make,
    required this.model,
    this.year,
    this.color,
    required this.fuelType,
    required this.avgMileage,
    this.numberPlate,
    this.totalSeats = 4,
    required this.createdAt,
  });

  VehicleModel copyWith({
    String? id,
    String? userId,
    String? make,
    String? model,
    int? year,
    String? color,
    String? fuelType,
    double? avgMileage,
    String? numberPlate,
    int? totalSeats,
    DateTime? createdAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      fuelType: fuelType ?? this.fuelType,
      avgMileage: avgMileage ?? this.avgMileage,
      numberPlate: numberPlate ?? this.numberPlate,
      totalSeats: totalSeats ?? this.totalSeats,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int?,
      color: json['color'] as String?,
      fuelType: json['fuelType'] as String,
      avgMileage: (json['avgMileage'] as num).toDouble(),
      numberPlate: json['numberPlate'] as String?,
      totalSeats: json['totalSeats'] as int? ?? 4,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'fuelType': fuelType,
      'avgMileage': avgMileage,
      'numberPlate': numberPlate,
      'totalSeats': totalSeats,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'VehicleModel(id: $id, userId: $userId, make: $make, model: $model, fuelType: $fuelType)';
  }
}

typedef Vehicle = VehicleModel;
