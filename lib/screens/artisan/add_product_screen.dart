import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/gi_product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/virasat_input.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

import '../../widgets/inputs/virasat_image_picker.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Handcarved Terracotta Flower Pot');
  final TextEditingController _priceController = TextEditingController(text: '1250');
  final TextEditingController _categoryController = TextEditingController(text: 'Terracotta');
  final TextEditingController _stateController = TextEditingController(text: 'Rajasthan');
  final TextEditingController _districtController = TextEditingController(text: 'Jaipur');
  final TextEditingController _materialController = TextEditingController(text: 'Natural Clay, Organic Pigments');
  final TextEditingController _dimensionsController = TextEditingController(text: '10" x 8" x 8"');
  final TextEditingController _weightController = TextEditingController(text: '1.4 kg');
  final TextEditingController _storyController = TextEditingController(text: 'Crafted using ancient wheel-throwing techniques passed down in Jaipur craft clusters.');

  List<String> _selectedImages = ['assets/images/crafts/blue_pottery_01.jpg'];
  bool _isPublishing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Add New Craft Product'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Virasat Camera & Gallery Multi-Image Picker
            VirasatImagePicker(
              initialImages: _selectedImages,
              onImagesChanged: (images) {
                setState(() {
                  _selectedImages = images;
                });
              },
            ),

            const SizedBox(height: 24),
            VirasatTextField(label: 'Product Name', controller: _nameController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: VirasatTextField(label: 'Price (₹)', controller: _priceController, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: VirasatTextField(label: 'Category', controller: _categoryController)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: VirasatTextField(label: 'State', controller: _stateController)),
                const SizedBox(width: 12),
                Expanded(child: VirasatTextField(label: 'District', controller: _districtController)),
              ],
            ),
            const SizedBox(height: 16),
            VirasatTextField(label: 'Materials Used', controller: _materialController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: VirasatTextField(label: 'Dimensions', controller: _dimensionsController)),
                const SizedBox(width: 12),
                Expanded(child: VirasatTextField(label: 'Weight', controller: _weightController)),
              ],
            ),
            const SizedBox(height: 16),
            VirasatTextField(label: 'Craft Story & Narrative', controller: _storyController, maxLines: 3),

            const SizedBox(height: 28),

            PrimaryButton(
              text: 'Publish to Marketplace',
              isLoading: _isPublishing,
              onPressed: () async {
                setState(() => _isPublishing = true);
                final newProduct = GiProductModel(
                  id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
                  name: _nameController.text,
                  category: _categoryController.text,
                  stateId: 'IN-RJ',
                  stateName: _stateController.text,
                  district: _districtController.text,
                  price: double.tryParse(_priceController.text) ?? 1000,
                  imageUrls: _selectedImages.isNotEmpty ? _selectedImages : ['assets/images/crafts/blue_pottery_01.jpg'],
                  imageUrl: _selectedImages.isNotEmpty ? _selectedImages.first : 'assets/images/crafts/blue_pottery_01.jpg',
                  description: _storyController.text,
                  giTagYear: 2020,
                );
                await ref.read(productServiceProvider).addProduct(newProduct);
                setState(() => _isPublishing = false);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product Published Live! 🎉'), backgroundColor: AppColors.success),
                  );
                  context.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
