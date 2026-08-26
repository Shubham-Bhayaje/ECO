/// Represents the state of a virtual/masked call session.
enum CallStatus { ringing, connected, ended }

class CallSession {
  final String callId;
  final String rideId;
  final String callerId;
  final String receiverId;
  final CallStatus status;
  final bool isMuted;
  final bool isSpeaker;

  const CallSession({
    required this.callId,
    required this.rideId,
    required this.callerId,
    required this.receiverId,
    required this.status,
    this.isMuted = false,
    this.isSpeaker = false,
  });

  CallSession copyWith({
    String? callId,
    String? rideId,
    String? callerId,
    String? receiverId,
    CallStatus? status,
    bool? isMuted,
    bool? isSpeaker,
  }) {
    return CallSession(
      callId: callId ?? this.callId,
      rideId: rideId ?? this.rideId,
      callerId: callerId ?? this.callerId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      isMuted: isMuted ?? this.isMuted,
      isSpeaker: isSpeaker ?? this.isSpeaker,
    );
  }
}

/// Abstract contract for masked calling services.
abstract class CallingContract {
  Future<CallSession> initiateCall({
    required String callerId,
    required String receiverId,
    required String rideId,
  });
  
  Future<void> endCall(String callId);
  
  Future<void> toggleMute({required String callId, required bool isMuted});
  
  Future<void> toggleSpeaker({required String callId, required bool isSpeaker});
  
  Stream<CallSession> onCallStateChanged(String callId);
}
