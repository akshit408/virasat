import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/marketplace_service.dart';
import '../buttons/primary_button.dart';
import '../chips/filter_chip.dart';

class FilterBottomSheet extends StatefulWidget {
  final MarketplaceFilterOptions currentOptions;
  final ValueChanged<MarketplaceFilterOptions> onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentOptions,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _priceRange;
  late String _selectedCategory;
  late String _selectedState;
  late bool _isGiTagged;
  late bool _isWomenArtisan;
  late bool _isEcoFriendly;
  late String _sortBy;

  final categories = ['All', 'Textiles', 'Pottery', 'Jewellery', 'Paintings', 'Wood Craft', 'Metal Craft', 'Handloom', 'Bamboo'];
  final states = ['All', 'Rajasthan', 'Jammu & Kashmir', 'Bihar', 'Tamil Nadu', 'Assam'];

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(widget.currentOptions.minPrice, widget.currentOptions.maxPrice);
    _selectedCategory = widget.currentOptions.category ?? 'All';
    _selectedState = widget.currentOptions.state ?? 'All';
    _isGiTagged = widget.currentOptions.isGiTagged ?? false;
    _isWomenArtisan = widget.currentOptions.isWomenArtisan ?? false;
    _isEcoFriendly = widget.currentOptions.isEcoFriendly ?? false;
    _sortBy = widget.currentOptions.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Marketplace',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _priceRange = const RangeValues(0, 50000);
                      _selectedCategory = 'All';
                      _selectedState = 'All';
                      _isGiTagged = false;
                      _isWomenArtisan = false;
                      _isEcoFriendly = false;
                      _sortBy = 'popular';
                    });
                  },
                  child: const Text('Reset', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Price Range (₹)', style: TextStyle(fontWeight: FontWeight.bold)),
            RangeSlider(
              values: () {
                final start = _priceRange.start.clamp(0.0, 50000.0);
                final end = _priceRange.end.clamp(0.0, 50000.0);
                return RangeValues(start <= end ? start : end, start <= end ? end : start);
              }(),
              min: 0,
              max: 50000,
              divisions: 50,
              activeColor: AppColors.primary,
              labels: RangeLabels(
                '₹${_priceRange.start.clamp(0.0, 50000.0).round()}',
                '₹${_priceRange.end.clamp(0.0, 50000.0).round()}',
              ),
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            const SizedBox(height: 12),
            const Text('Craft Category', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: categories.map((cat) => VirasatFilterChip(
                label: cat,
                isSelected: _selectedCategory == cat,
                onSelected: (val) => setState(() => _selectedCategory = cat),
              )).toList(),
            ),
            const SizedBox(height: 12),
            const Text('State of Origin', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: states.map((st) => VirasatFilterChip(
                label: st,
                isSelected: _selectedState == st,
                onSelected: (val) => setState(() => _selectedState = st),
              )).toList(),
            ),
            const SizedBox(height: 12),
            const Text('Heritage & Craft Tags', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: [
                VirasatFilterChip(
                  label: 'GI Tagged Authentic',
                  isSelected: _isGiTagged,
                  onSelected: (val) => setState(() => _isGiTagged = val),
                ),
                VirasatFilterChip(
                  label: 'Women Artisan Spotlight',
                  isSelected: _isWomenArtisan,
                  onSelected: (val) => setState(() => _isWomenArtisan = val),
                ),
                VirasatFilterChip(
                  label: 'Eco-Friendly & Natural',
                  isSelected: _isEcoFriendly,
                  onSelected: (val) => setState(() => _isEcoFriendly = val),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Apply Filters',
              onPressed: () {
                widget.onApply(MarketplaceFilterOptions(
                  minPrice: _priceRange.start,
                  maxPrice: _priceRange.end,
                  category: _selectedCategory,
                  state: _selectedState,
                  isGiTagged: _isGiTagged,
                  isWomenArtisan: _isWomenArtisan,
                  isEcoFriendly: _isEcoFriendly,
                  sortBy: _sortBy,
                ));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
