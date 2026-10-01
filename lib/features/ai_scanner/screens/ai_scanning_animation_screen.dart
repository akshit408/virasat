import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/ai_scanner_provider.dart';

class AiScanningAnimationScreen extends ConsumerStatefulWidget {
  const AiScanningAnimationScreen({super.key});

  @override
  ConsumerState<AiScanningAnimationScreen> createState() => _AiScanningAnimationScreenState();
}

class _AiScanningAnimationScreenState extends ConsumerState<AiScanningAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  int _scanStageIndex = 0;
  int _confidenceScore = 0;
  Timer? _stageTimer;
  Timer? _confidenceTimer;
  String? _errorMessage;
  bool _isAnalyzing = false;

  final List<String> _stages = [
    'Analyzing your craft using VIRASAT AI Vision...',
    'Scanning Product Shape & Weave...',
    'Detecting Craft Category & Pattern...',
    'Analyzing Natural Dye & Fiber Composition...',
    'Searching 50 GI Heritage Databases...',
    'Generating Smart Craft Listing...',
  ];

  final List<String> _detectedChips = [
    'Handmade Craft', 'Natural Fiber', 'Eco Dyes', 'Craft Pattern', 'GI Region', 'Authentic Craft'
  ];

  final List<String> _visibleChips = [];

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _startScanningTimeline();
  }

  void _startScanningTimeline() {
    setState(() {
      _errorMessage = null;
      _isAnalyzing = true;
      _scanStageIndex = 0;
      _confidenceScore = 0;
      _visibleChips.clear();
    });

    _confidenceTimer?.cancel();
    _stageTimer?.cancel();

    // Confidence score counter
    _confidenceTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_confidenceScore < 98) {
        setState(() => _confidenceScore++);
      }
    });

    // Stage timeline switcher (6 steps over 5.5s)
    _stageTimer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (_scanStageIndex < _stages.length - 1) {
        setState(() {
          _scanStageIndex++;
          if (_scanStageIndex < _detectedChips.length) {
            _visibleChips.add(_detectedChips[_scanStageIndex]);
          }
        });
      } else {
        timer.cancel();
        // Run AI analysis & navigate
        ref.read(aiScannerProvider.notifier).runAnalysis().then((_) {
          if (mounted) {
            setState(() => _isAnalyzing = false);
            context.pushReplacement('/ai-analysis-result');
          }
        }).catchError((err) {
          if (mounted) {
            setState(() {
              _isAnalyzing = false;
              _errorMessage = err.toString().replaceAll('Exception: ', '');
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _laserController.dispose();
    _stageTimer?.cancel();
    _confidenceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Dark Heritage Mesh Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E110E), Color(0xFF0F0806)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            Column(
              children: [
                const SizedBox(height: 24),
                // Top Header
                const Text(
                  'VIRASAT AI VISION SCANNER',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _errorMessage != null
                        ? 'Analysis Failed'
                        : _stages[_scanStageIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: _errorMessage != null ? Colors.redAccent : Colors.white70,
                      fontWeight: _errorMessage != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Main Scanner Container with Laser Beam
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: _errorMessage != null ? Colors.redAccent : AppColors.secondary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: (_errorMessage != null ? Colors.redAccent : AppColors.secondary).withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Real Craft Image Preview being scanned
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Opacity(
                                opacity: 0.85,
                                child: () {
                                  final paths = ref.watch(aiScannerProvider).imagePaths;
                                  if (paths.isEmpty) {
                                    return Image.asset(
                                      'assets/images/crafts/bandhani_01.jpg',
                                      fit: BoxFit.cover,
                                    );
                                  }
                                  final path = paths.first;
                                  if (path.startsWith('assets/')) {
                                    return Image.asset(path, fit: BoxFit.cover);
                                  } else {
                                    return Image.file(File(path), fit: BoxFit.cover);
                                  }
                                }(),
                              ),
                            ),
                          ),

                          // Moving Laser Beam (only while scanning)
                          if (_isAnalyzing)
                            AnimatedBuilder(
                              animation: _laserController,
                              builder: (context, child) {
                                return Align(
                                  alignment: Alignment(0, (_laserController.value * 2) - 1),
                                  child: Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyanAccent.withValues(alpha: 0.8),
                                          blurRadius: 16,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          // Floating Detected Chips Overlay
                          Positioned(
                            bottom: 20,
                            left: 16,
                            right: 16,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _visibleChips.map((chip) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle_outline, size: 12, color: AppColors.secondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        chip,
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Error or Progress Area
                if (_errorMessage != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.error_outline_rounded, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'AI Craft Vision Notice',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _errorMessage!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white54),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _startScanningTimeline,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Retry Analysis'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Confidence Circle & Progress Score
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                value: _confidenceScore / 100,
                                strokeWidth: 5,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                              ),
                            ),
                            Text(
                              '$_confidenceScore%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Analyzing your craft with VIRASAT AI...',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Analyzing craft signature & state GI rules',
                              style: TextStyle(fontSize: 11, color: Colors.white54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
