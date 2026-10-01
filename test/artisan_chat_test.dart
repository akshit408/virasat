import 'package:flutter_test/flutter_test.dart';
import 'package:virasat/features/chat/models/chat_message_model.dart';
import 'package:virasat/features/chat/providers/artisan_chat_provider.dart';

void main() {
  group('Artisan Chat Feature Tests', () {
    const testArgs = ArtisanChatArgs(
      artisanId: 'artisan_01',
      name: 'Ramesh Vankar',
      avatar: 'assets/images/crafts/bandhani_01.jpg',
      craft: 'Bandhani Tie-Dye',
      location: 'Alkapuri, Vadodara',
    );

    test('ArtisanChatArgs constructs and maps correctly', () {
      final map = testArgs.toMap();
      final fromMap = ArtisanChatArgs.fromMap(map);

      expect(fromMap.artisanId, equals('artisan_01'));
      expect(fromMap.name, equals('Ramesh Vankar'));
      expect(fromMap.craft, equals('Bandhani Tie-Dye'));
      expect(fromMap.location, equals('Alkapuri, Vadodara'));
    });

    test('ChatMessageModel serialization and deserialization work', () {
      final msg = ChatMessageModel(
        id: '101',
        senderId: 'user_1',
        recipientId: 'artisan_01',
        text: 'Hello master artisan!',
        timestamp: DateTime(2026, 9, 15, 10, 30),
        sender: MessageSender.user,
      );

      final jsonMap = msg.toJson();
      final fromJson = ChatMessageModel.fromJson(jsonMap);

      expect(fromJson.id, equals('101'));
      expect(fromJson.text, equals('Hello master artisan!'));
      expect(fromJson.sender, equals(MessageSender.user));
    });

    test('ArtisanChatNotifier initializes with mock messages', () {
      final notifier = ArtisanChatNotifier(testArgs);
      expect(notifier.state.messages, isNotEmpty);
      expect(notifier.state.artisanId, equals('artisan_01'));
    });

    test('sendMessage appends user message and receives artisan response', () async {
      final notifier = ArtisanChatNotifier(testArgs);
      final initialCount = notifier.state.messages.length;

      await notifier.sendMessage('Is custom size available?');

      expect(notifier.state.messages.length, equals(initialCount + 2));
      final lastMsg = notifier.state.messages.last;
      expect(lastMsg.sender, equals(MessageSender.artisan));
      expect(lastMsg.text, contains('custom'));
    });
  });
}
