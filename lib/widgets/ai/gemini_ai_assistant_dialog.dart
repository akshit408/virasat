import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GeminiAiAssistantDialog extends StatefulWidget {
  const GeminiAiAssistantDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const GeminiAiAssistantDialog(),
    );
  }

  @override
  State<GeminiAiAssistantDialog> createState() => _GeminiAiAssistantDialogState();
}

class _GeminiAiAssistantDialogState extends State<GeminiAiAssistantDialog> {
  final TextEditingController _inputController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Namaste! 🙏 I am VIRASAT\'s Gemini AI Heritage Assistant. Ask me about GI crafts, gift ideas for festivals, artisan stories, or government MSME schemes.',
    },
  ];
  bool _isThinking = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _sendMessage(String userQuery) {
    if (userQuery.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': userQuery.trim()});
      _inputController.clear();
      _isThinking = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      String aiResponse = 'Authentic GI (Geographical Indication) handicrafts represent centuries of indigenous craft knowledge. ';
      final queryLower = userQuery.toLowerCase();

      if (queryLower.contains('gift') || queryLower.contains('recommend')) {
        aiResponse = '🎁 For a memorable gift, I recommend: \n1. Patola Silk Saree from Patan, Gujarat (GI Tagged)\n2. Jaipur Blue Pottery Mug Set (Eco-Friendly & Lead-Free)\n3. Kutch Mirror Work Dupatta from Women SHGs.';
      } else if (queryLower.contains('gi') || queryLower.contains('tag')) {
        aiResponse = '📜 A Geographical Indication (GI) tag guarantees that a product possesses specific qualities or reputation due to its origin in a specific Indian town/region (e.g., Banarasi Silk, Pashmina Shawl, Channapatna Toys).';
      } else if (queryLower.contains('scheme') || queryLower.contains('grant') || queryLower.contains('govt')) {
        aiResponse = '🏛️ Key Government Schemes for Artisans:\n• PM Vishwakarma Scheme (Up to ₹3 Lakh collateral-free loan at 5% interest)\n• National Handicrafts Development Programme (AHVY)';
      } else {
        aiResponse = '✨ $userQuery is deeply rooted in Indian craft heritage. Every purchase on VIRASAT sends 85%+ direct revenue to verified rural artisan families.';
      }

      setState(() {
        _isThinking = false;
        _messages.add({'sender': 'ai', 'text': aiResponse});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAF6F0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gemini AI Craft Assistant',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Powered by Google Gemini 2.5 Flash',
                        style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isUser = msg['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary : const Color(0xFFFDFBF7),
                      borderRadius: BorderRadius.circular(16),
                      border: isUser ? null : Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: isUser ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isThinking) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary)),
                  SizedBox(width: 8),
                  Text('Gemini is retrieving craft knowledge...', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],

          // Quick Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildQuickChip('🎁 Gift Ideas'),
                _buildQuickChip('📜 What is a GI Tag?'),
                _buildQuickChip('🏛️ Artisan Schemes'),
              ],
            ),
          ),

          // Input Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: 'Ask Gemini about crafts...',
                      hintStyle: const TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFFDFBF7),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(_inputController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return GestureDetector(
      onTap: () => _sendMessage(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
      ),
    );
  }
}
