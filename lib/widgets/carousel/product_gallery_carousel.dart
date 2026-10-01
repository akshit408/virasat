import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../cards/safe_product_image.dart';

class ProductGalleryCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final String coverImageUrl;
  final String productName;
  final bool isGiTagged;

  const ProductGalleryCarousel({
    super.key,
    required this.imageUrls,
    required this.coverImageUrl,
    required this.productName,
    this.isGiTagged = false,
  });

  @override
  State<ProductGalleryCarousel> createState() => _ProductGalleryCarouselState();
}

class _ProductGalleryCarouselState extends State<ProductGalleryCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<String> get _resolvedGalleryImages {
    final list = <String>[];
    if (widget.coverImageUrl.isNotEmpty) {
      list.add(widget.coverImageUrl);
    }
    for (final url in widget.imageUrls) {
      if (url.isNotEmpty && !list.contains(url)) {
        list.add(url);
      }
    }
    if (list.isEmpty) {
      list.add('');
    }
    return list;
  }

  void _openFullscreenViewer(int initialIndex) {
    final images = _resolvedGalleryImages;
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => FullscreenImageViewerDialog(
        images: images,
        initialIndex: initialIndex,
        productName: widget.productName,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _resolvedGalleryImages;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Swipeable Image PageView
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, idx) {
            return GestureDetector(
              onTap: () => _openFullscreenViewer(idx),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SafeProductImage(
                    imagePath: images[idx],
                    fit: BoxFit.cover,
                    placeholderText: widget.productName,
                  ),

                  // Dark gradient overlay at bottom for readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // 2. GI Tag Chip (Top Left)
        Positioned(
          top: 60,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  widget.isGiTagged ? 'GI CERTIFIED CRAFT' : 'HANDCRAFTED HERITAGE',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. Page Counter Chip (Top Right)
        Positioned(
          top: 60,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_currentIndex + 1} / ${images.length}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // 4. Dot Indicators (Bottom Center)
        if (images.length > 1)
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (idx) {
                final isSelected = _currentIndex == idx;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSelected ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class FullscreenImageViewerDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String productName;

  const FullscreenImageViewerDialog({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.productName,
  });

  @override
  State<FullscreenImageViewerDialog> createState() => _FullscreenImageViewerDialogState();
}

class _FullscreenImageViewerDialogState extends State<FullscreenImageViewerDialog> {
  late PageController _dialogPageController;
  late int _dialogCurrentIndex;

  @override
  void initState() {
    super.initState();
    _dialogCurrentIndex = widget.initialIndex;
    _dialogPageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _dialogPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Interactive Zoomable PageView
          PageView.builder(
            controller: _dialogPageController,
            itemCount: widget.images.length,
            onPageChanged: (idx) {
              setState(() {
                _dialogCurrentIndex = idx;
              });
            },
            itemBuilder: (context, idx) {
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Center(
                  child: SafeProductImage(
                    imagePath: widget.images[idx],
                    fit: BoxFit.contain,
                    placeholderText: widget.productName,
                  ),
                ),
              );
            },
          ),

          // Header with Close Button & Title
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Image ${_dialogCurrentIndex + 1} of ${widget.images.length} (Pinch to zoom)',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
