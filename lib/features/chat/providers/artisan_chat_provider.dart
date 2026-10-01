import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message_model.dart';

class ArtisanChatState {
  final List<ChatMessageModel> messages;
  final bool isTyping;
  final bool isConnected;
  final String artisanId;

  const ArtisanChatState({
    required this.messages,
    this.isTyping = false,
    this.isConnected = true,
    required this.artisanId,
  });

  ArtisanChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isTyping,
    bool? isConnected,
    String? artisanId,
  }) {
    return ArtisanChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      isConnected: isConnected ?? this.isConnected,
      artisanId: artisanId ?? this.artisanId,
    );
  }
}

class ArtisanChatNotifier extends StateNotifier<ArtisanChatState> {
  final ArtisanChatArgs args;

  ArtisanChatNotifier(this.args)
      : super(
          ArtisanChatState(
            artisanId: args.artisanId,
            messages: _getInitialMockMessages(args),
          ),
        );

  static List<ChatMessageModel> _getInitialMockMessages(ArtisanChatArgs args) {
    final now = DateTime.now();
    return [
      ChatMessageModel(
        id: 'msg_1',
        senderId: args.artisanId,
        recipientId: 'user_current',
        text: 'Namaste! 🙏 Welcome to my VIRASAT studio. I am ${args.name}, master artisan of ${args.craft} in ${args.location}. How can I assist you today?',
        timestamp: now.subtract(const Duration(minutes: 15)),
        sender: MessageSender.artisan,
      ),
      ChatMessageModel(
        id: 'msg_2',
        senderId: 'user_current',
        recipientId: args.artisanId,
        text: 'Hello ${args.name.split(' ').first}! I love your ${args.craft} collection. Are these 100% handcrafted with GI Tag verification?',
        timestamp: now.subtract(const Duration(minutes: 10)),
        sender: MessageSender.user,
      ),
      ChatMessageModel(
        id: 'msg_3',
        senderId: args.artisanId,
        recipientId: 'user_current',
        text: 'Yes, 100%! Every piece is hand-crafted in our village workshop using traditional natural techniques. Each product comes with a unique QR GI authentication code.',
        timestamp: now.subtract(const Duration(minutes: 5)),
        sender: MessageSender.artisan,
      ),
    ];
  }

  /// Sends a message and simulates an automated artisan response (ready for Firebase/MongoDB backend integration).
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user_current',
      recipientId: args.artisanId,
      text: text.trim(),
      timestamp: DateTime.now(),
      sender: MessageSender.user,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    // Simulate artisan typing delay
    await Future.delayed(const Duration(milliseconds: 1400));

    final replyText = _generateArtisanReply(text, args);
    final artisanReply = ChatMessageModel(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      senderId: args.artisanId,
      recipientId: 'user_current',
      text: replyText,
      timestamp: DateTime.now(),
      sender: MessageSender.artisan,
    );

    state = state.copyWith(
      messages: [...state.messages, artisanReply],
      isTyping: false,
    );
  }

  String _generateArtisanReply(String text, ArtisanChatArgs args) {
    final lower = text.toLowerCase();

    if (lower.contains('custom') || lower.contains('size') || lower.contains('color')) {
      return 'Yes! We offer custom sizing and natural color customization. Please share your required dimensions or color preferences, and I will craft it for you.';
    }
    if (lower.contains('price') || lower.contains('cost') || lower.contains('discount')) {
      return 'All our products follow Direct Fair-Trade pricing. 100% of your payment directly supports our artisan family without any middleman cuts.';
    }
    if (lower.contains('time') || lower.contains('deliver') || lower.contains('ship')) {
      return 'Since each piece is hand-crafted with care, crafting and quality checks take about 5-7 days, followed by 3-4 days dispatch across India.';
    }
    if (lower.contains('gi') || lower.contains('certificate') || lower.contains('authentic')) {
      return 'Every item includes an official Geographical Indication (GI) authentication card with a physical QR code linking directly to Ministry of Textiles registry.';
    }

    return 'Thank you for your message! I am currently working at my loom in ${args.location}. I will share photos of your craft creation shortly!';
  }
}

final artisanChatProvider = StateNotifierProvider.family<ArtisanChatNotifier, ArtisanChatState, ArtisanChatArgs>(
  (ref, args) => ArtisanChatNotifier(args),
);
