import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/buttons/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Handcrafted Heritage of India',
      'subtitle': 'EMPOWERING ARTISANS',
      'description': 'Discover thousands of authentic handmade crafts directly from master weavers, tribal artists, potters, and women craft makers across 28 states.',
      'icon': Icons.museum_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'title': 'Discover Cultural Atlas',
      'subtitle': 'GI TAGGED ATLAS',
      'description': 'Discover India\'s rich craft map, regional heritage stories, origin certification, and virtual artisan trails from Kashmir to Kanyakumari.',
      'icon': Icons.explore_rounded,
      'accentColor': AppColors.secondary,
    },
    {
      'title': 'AI Heritage Studio',
      'subtitle': 'NEXT-GEN CRAFT TECH',
      'description': 'Empowering artisans with AI craft pattern authentication, voice cataloguing in regional Indian languages, and fair price algorithms.',
      'icon': Icons.auto_awesome_rounded,
      'accentColor': AppColors.success,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Onboarding PageView Slides
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  final Color accentColor = page['accentColor'];

                  return Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Circle Icon Container
                          Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                              border: Border.all(color: accentColor, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.cardShadow,
                                  blurRadius: 18,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                page['icon'] as IconData,
                                size: 72,
                                color: accentColor,
                              ),
                            ),
                          ).animate().scale(duration: 500.ms, curve: Curves.easeOutCubic),

                          const SizedBox(height: 24),

                          // Subtitle Pill Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              page['subtitle'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ).animate().fadeIn(delay: 200.ms),

                          const SizedBox(height: 12),

                          // Slide Title
                          Text(
                            page['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                          const SizedBox(height: 14),

                          // Slide Description
                          Text(
                            page['description'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Navigation Indicators & Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (idx) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == idx ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == idx ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: _currentPage == _pages.length - 1 ? 'Discover Virasat' : 'Next',
                    icon: _currentPage == _pages.length - 1 ? Icons.arrow_forward_rounded : null,
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
