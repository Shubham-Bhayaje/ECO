import 'dart:async';
import 'contracts/calling_contract.dart';

class CallingService implements CallingContract {
  final Map<String, CallSession> _activeCalls = {};
  final Map<String, StreamController<CallSession>> _callControllers = {};

  @override
  Future<CallSession> initiateCall({
    required String callerId,
    required String receiverId,
    required String rideId,
  }) async {
    final callId = 'call_${DateTime.now().millisecondsSinceEpoch}';
    
    final session = CallSession(
      callId: callId,
      rideId: rideId,
      callerId: callerId,
      receiverId: receiverId,
      status: CallStatus.ringing,
    );
    
    _activeCalls[callId] = session;
    
    if (!_callControllers.containsKey(callId)) {
      _callControllers[callId] = StreamController<CallSession>.broadcast();
    }
    
    _callControllers[callId]?.add(session);
    
    // Simulate answering after a short delay for testing purposes
    Future.delayed(const Duration(seconds: 3), () {
      if (_activeCalls.containsKey(callId) && 
          _activeCalls[callId]?.status == CallStatus.ringing) {
        final connectedSession = _activeCalls[callId]!.copyWith(status: CallStatus.connected);
        _activeCalls[callId] = connectedSession;
        _callControllers[callId]?.add(connectedSession);
      }
    });

    return session;
  }
  
  @override
  Future<void> endCall(String callId) async {
    if (_activeCalls.containsKey(callId)) {
      final endedSession = _activeCalls[callId]!.copyWith(status: CallStatus.ended);
      _activeCalls[callId] = endedSession;
      _callControllers[callId]?.add(endedSession);
      
      // Clean up after some delay
      Future.delayed(const Duration(seconds: 2), () {
        _callControllers[callId]?.close();
        _callControllers.remove(callId);
        _activeCalls.remove(callId);
      });
    }
  }
  
  @override
  Future<void> toggleMute({required String callId, required bool isMuted}) async {
    if (_activeCalls.containsKey(callId)) {
      final updatedSession = _activeCalls[callId]!.copyWith(isMuted: isMuted);
      _activeCalls[callId] = updatedSession;
      _callControllers[callId]?.add(updatedSession);
    }
  }
  
  @override
  Future<void> toggleSpeaker({required String callId, required bool isSpeaker}) async {
    if (_activeCalls.containsKey(callId)) {
      final updatedSession = _activeCalls[callId]!.copyWith(isSpeaker: isSpeaker);
      _activeCalls[callId] = updatedSession;
      _callControllers[callId]?.add(updatedSession);
    }
  }
  
  @override
  Stream<CallSession> onCallStateChanged(String callId) {
    if (!_callControllers.containsKey(callId)) {
      _callControllers[callId] = StreamController<CallSession>.broadcast();
    }
    
    // Emit current state if it exists
    if (_activeCalls.containsKey(callId)) {
      Future.microtask(() {
        _callControllers[callId]?.add(_activeCalls[callId]!);
      });
    }
    
    return _callControllers[callId]!.stream;
  }
}
