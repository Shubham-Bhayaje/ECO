import 'dart:async';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService {
  final Map<String, ChatModel> _chats = {};
  final Map<String, List<MessageModel>> _messages = {};
  final Map<String, StreamController<List<MessageModel>>> _messageControllers = {};

  ChatService() {
    _initMockData();
  }

  void _initMockData() {
    // Mock Chat 1: Andheri -> BKC Ride
    final chat1 = ChatModel(
      id: 'chat_1',
      participant1: 'user_me', // Default test user
      participant2: 'user_rahul', // Rahul Verma
      rideId: 'ride_andheri_bkc',
      lastMessage: 'I am waiting near the station.',
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );
    _chats['chat_1'] = chat1;

    _messages['chat_1'] = [
      MessageModel(
        id: 'msg_1_1',
        chatId: 'chat_1',
        senderId: 'user_rahul',
        content: 'Hi, are we still on for the Andheri to BKC ride?',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      MessageModel(
        id: 'msg_1_2',
        chatId: 'chat_1',
        senderId: 'user_me',
        content: 'Yes! I will be there in 10 mins.',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      MessageModel(
        id: 'msg_1_3',
        chatId: 'chat_1',
        senderId: 'user_rahul',
        content: 'I am waiting near the station.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    // Mock Chat 2: Powai -> Lower Parel
    final chat2 = ChatModel(
      id: 'chat_2',
      participant1: 'user_me',
      participant2: 'user_priya', // Priya Sharma
      rideId: 'ride_powai_lowerparel',
      lastMessage: 'See you tomorrow!',
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );
    _chats['chat_2'] = chat2;

    _messages['chat_2'] = [
      MessageModel(
        id: 'msg_2_1',
        chatId: 'chat_2',
        senderId: 'user_priya',
        content: 'Hey, thanks for accepting my request for the Powai to Lower Parel ride.',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      MessageModel(
        id: 'msg_2_2',
        chatId: 'chat_2',
        senderId: 'user_me',
        content: 'No problem! See you tomorrow!',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    if (!_messageControllers.containsKey(chatId)) {
      _messageControllers[chatId] = StreamController<List<MessageModel>>.broadcast();
    }
    
    // Emit current messages right away to listeners
    Future.microtask(() {
      _messageControllers[chatId]?.add(_messages[chatId] ?? []);
    });
    
    return _messageControllers[chatId]!.stream;
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    final messages = _messages[chatId] ?? [];
    
    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: senderId,
      content: content,
      isRead: false,
      createdAt: DateTime.now(),
    );
    
    messages.add(newMessage);
    _messages[chatId] = messages;
    
    if (_chats.containsKey(chatId)) {
      _chats[chatId] = _chats[chatId]!.copyWith(
        lastMessage: content,
        updatedAt: DateTime.now(),
      );
    }
    
    _messageControllers[chatId]?.add(messages);
  }

  Future<List<ChatModel>> getConversations(String userId) async {
    // Return chats where the user is a participant
    final userChats = _chats.values.where((chat) => 
        chat.participant1 == userId || chat.participant2 == userId).toList();
        
    // If no chats found (e.g. testing with random user ID), return all as fallback 
    if (userChats.isEmpty) {
      return _chats.values.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    
    userChats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return userChats;
  }
}
