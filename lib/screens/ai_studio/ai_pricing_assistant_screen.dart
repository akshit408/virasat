import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/ai_result_model.dart';
import '../../providers/ai_studio_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/virasat_input.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class AiPricingAssistantScreen extends ConsumerStatefulWidget {
  const AiPricingAssistantScreen({super.key});

  @override
  ConsumerState<AiPricingAssistantScreen> createState() => _AiPricingAssistantScreenState();
}

class _AiPricingAssistantScreenState extends ConsumerState<AiPricingAssistantScreen> {
  final TextEditingController _materialCostController = TextEditingController(text: '450');
  final TextEditingController _hoursController = TextEditingController(text: '8.5');
  final TextEditingController _stateController = TextEditingController(text: 'Rajasthan');
  final TextEditingController _categoryController = TextEditingController(text: 'Blue Pottery');

  bool _isCalculating = false;
  AiPricingResult? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'AI Pricing Intelligence'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fair Wage & Price Recommendation Engine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display')),
            const SizedBox(height: 6),
            const Text('Virasat AI ensures artisans receive fair labor compensation based on local wage standards and national marketplace demand trends.'),
            const SizedBox(height: 20),

            VirasatTextField(label: 'Raw Material Cost (₹)', controller: _materialCostController, keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            VirasatTextField(label: 'Labor Hours Invested', controller: _hoursController, keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: VirasatTextField(label: 'State', controller: _stateController)),
                const SizedBox(width: 12),
                Expanded(child: VirasatTextField(label: 'Category', controller: _categoryController)),
              ],
            ),

            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Calculate Fair Listing Price',
              isLoading: _isCalculating,
              onPressed: () async {
                setState(() => _isCalculating = true);
                final res = await ref.read(aiServiceProvider).calculateRecommendedPrice(
                  category: _categoryController.text,
                  materialCost: _materialCostController.text,
                  laborHours: double.tryParse(_hoursController.text) ?? 8.0,
                  state: _stateController.text,
                );
                setState(() {
                  _result = res;
                  _isCalculating = false;
                });
              },
            ),

            if (_result != null) ...[
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondary, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI PRICE RECOMMENDATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recommended Price:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(Formatters.currency(_result!.recommendedPrice), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Suggested Price Range:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Text('${Formatters.currency(_result!.minPrice)} - ${Formatters.currency(_result!.maxPrice)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Net Artisan Profit:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Text(Formatters.currency(_result!.estimatedProfit), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_result!.reasoning, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
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
