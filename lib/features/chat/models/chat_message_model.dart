enum MessageSender { user, artisan, system }

class ChatMessageModel {
  final String id;
  final String senderId;
  final String recipientId;
  final String text;
  final DateTime timestamp;
  final MessageSender sender;
  final bool isRead;

  const ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.text,
    required this.timestamp,
    required this.sender,
    this.isRead = true,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      recipientId: json['recipientId'] as String? ?? '',
      text: json['text'] as String? ?? json['message'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      sender: json['sender'] == 'user'
          ? MessageSender.user
          : json['sender'] == 'system'
              ? MessageSender.system
              : MessageSender.artisan,
      isRead: json['isRead'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'recipientId': recipientId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender == MessageSender.user
          ? 'user'
          : sender == MessageSender.system
              ? 'system'
              : 'artisan',
      'isRead': isRead,
    };
  }
}

class ArtisanChatArgs {
  final String artisanId;
  final String name;
  final String avatar;
  final String craft;
  final String location;
  final String? initialMessage;

  const ArtisanChatArgs({
    required this.artisanId,
    required this.name,
    required this.avatar,
    required this.craft,
    required this.location,
    this.initialMessage,
  });

  factory ArtisanChatArgs.fromMap(Map<String, dynamic> map) {
    return ArtisanChatArgs(
      artisanId: map['artisanId'] as String? ?? map['id'] as String? ?? 'artisan_default',
      name: map['name'] as String? ?? map['artisanName'] as String? ?? 'Master Artisan',
      avatar: map['avatar'] as String? ?? map['profileImage'] as String? ?? 'assets/images/crafts/bandhani_01.jpg',
      craft: map['craft'] as String? ?? map['craftSpecialization'] as String? ?? 'Handicrafts',
      location: map['location'] as String? ?? map['village'] as String? ?? 'Gujarat, India',
      initialMessage: map['initialMessage'] as String?,
    );
  }

  Map<String, String> toMap() {
    return {
      'artisanId': artisanId,
      'name': name,
      'avatar': avatar,
      'craft': craft,
      'location': location,
      if (initialMessage != null) 'initialMessage': initialMessage!,
    };
  }
}
