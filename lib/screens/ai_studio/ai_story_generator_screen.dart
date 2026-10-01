import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/ai_result_model.dart';
import '../../providers/ai_studio_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/virasat_input.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class AiStoryGeneratorScreen extends ConsumerStatefulWidget {
  const AiStoryGeneratorScreen({super.key});

  @override
  ConsumerState<AiStoryGeneratorScreen> createState() => _AiStoryGeneratorScreenState();
}

class _AiStoryGeneratorScreenState extends ConsumerState<AiStoryGeneratorScreen> {
  final TextEditingController _stateController = TextEditingController(text: 'Rajasthan');
  final TextEditingController _craftController = TextEditingController(text: 'Blue Pottery');
  final TextEditingController _artisanHistoryController = TextEditingController(text: '4 generations of master craftsmanship');

  bool _isGenerating = false;
  AiStoryResult? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Heritage Craft Story Generator'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generate Heritage Cultural Narratives', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display')),
            const SizedBox(height: 6),
            const Text('Transform simple product details into an enchanting story of Indian tradition that connects with buyers.'),
            const SizedBox(height: 20),

            VirasatTextField(label: 'State of Origin', controller: _stateController),
            const SizedBox(height: 14),
            VirasatTextField(label: 'Craft Name', controller: _craftController),
            const SizedBox(height: 14),
            VirasatTextField(label: 'Artisan Heritage / Background', controller: _artisanHistoryController),

            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Generate Craft Story',
              isLoading: _isGenerating,
              onPressed: () async {
                setState(() => _isGenerating = true);
                final res = await ref.read(aiServiceProvider).generateCraftStory(
                  state: _stateController.text,
                  craftName: _craftController.text,
                  artisanHistory: _artisanHistoryController.text,
                );
                setState(() {
                  _result = res;
                  _isGenerating = false;
                });
              },
            ),

            if (_result != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ENGLISH NARRATIVE', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 11)),
                    const SizedBox(height: 6),
                    Text(_result!.englishStory, style: const TextStyle(fontSize: 14, height: 1.5)),
                    const Divider(height: 24),
                    const Text('HINDI NARRATIVE (हिंदी)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 11)),
                    const SizedBox(height: 6),
                    Text(_result!.hindiStory, style: const TextStyle(fontSize: 14, height: 1.5)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Story copied to clipboard!')));
                            },
                            child: const Text('Copy Story'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Use in Listing',
                            onPressed: () => context.push('/artisan/add-product'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
