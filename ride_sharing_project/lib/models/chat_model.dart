/// Model representing a chat conversation between two users.
class ChatModel {
  final String id;
  final String participant1;
  final String participant2;
  final String? rideId;
  final String? lastMessage;
  final DateTime updatedAt;
  final DateTime createdAt;

  const ChatModel({
    required this.id,
    required this.participant1,
    required this.participant2,
    this.rideId,
    this.lastMessage,
    required this.updatedAt,
    required this.createdAt,
  });

  /// The other participant's ID given the current user's ID.
  String otherParticipant(String currentUserId) {
    return currentUserId == participant1 ? participant2 : participant1;
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      participant1: json['participant_1'] as String,
      participant2: json['participant_2'] as String,
      rideId: json['ride_id'] as String?,
      lastMessage: json['last_message'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant_1': participant1,
      'participant_2': participant2,
      'ride_id': rideId,
      'last_message': lastMessage,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChatModel copyWith({
    String? id,
    String? participant1,
    String? participant2,
    String? rideId,
    String? lastMessage,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participant1: participant1 ?? this.participant1,
      participant2: participant2 ?? this.participant2,
      rideId: rideId ?? this.rideId,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, participant1: $participant1, participant2: $participant2, rideId: $rideId)';
  }
}
