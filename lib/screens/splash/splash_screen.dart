import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import 'widgets/mandala_background_painter.dart';
import 'widgets/virasat_logo_painter.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;

  // 6-Scene Animations (0.0s to 3.0s = 3000 ms total)
  late Animation<double> _bgGradientAnimation;
  late Animation<double> _mandalaOpacityAnimation;
  late Animation<double> _particleOpacityAnimation;
  late Animation<double> _motifDrawProgressAnimation;

  late Animation<double> _outlineProgressAnimation;
  late Animation<double> _leafProgressAnimation;
  late Animation<double> _artisanProgressAnimation;
  late Animation<double> _glowProgressAnimation;
  late Animation<double> _sunMonumentAnimation;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;

  late Animation<double> _screenExitFadeAnimation;
  late Animation<double> _screenExitScaleAnimation;

  @override
  void initState() {
    super.initState();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _setupAnimationTimeline();

    _mainController.forward();
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToTarget();
      }
    });
  }

  void _setupAnimationTimeline() {
    // Scene 1 (0.0 - 0.5s = 0.0 to 0.166 of timeline)
    _bgGradientAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.166, curve: Curves.easeOut),
    );

    _mandalaOpacityAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.20, curve: Curves.easeIn),
    );

    _particleOpacityAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.05, 0.25, curve: Curves.easeIn),
    );

    // Scene 2 (0.5 - 1.0s = 0.166 to 0.333 of timeline)
    _motifDrawProgressAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.166, 0.333, curve: Curves.easeInOut),
    );

    // Scene 3 (1.0 - 1.6s = 0.333 to 0.533 of timeline)
    _outlineProgressAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.333, 0.533, curve: Curves.easeInOutCubic),
    );

    // Scene 4 (1.6 - 2.2s = 0.533 to 0.733 of timeline)
    _leafProgressAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.533, 0.733, curve: Curves.easeInOutBack),
    );

    _artisanProgressAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.533, 0.733, curve: Curves.easeInOutBack),
    );

    _glowProgressAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.56, 0.76, curve: Curves.easeOutCubic),
    );

    _sunMonumentAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.56, 0.76, curve: Curves.easeOutCubic),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.56, 0.76, curve: Curves.elasticOut),
      ),
    );

    // Scene 5 (2.2 - 2.7s = 0.733 to 0.90 of timeline)
    _textFadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.733, 0.90, curve: Curves.easeOut),
    );

    _textSlideAnimation = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.733, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    // Scene 6 (2.7 - 3.0s = 0.90 to 1.0 of timeline)
    _screenExitFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.90, 1.0, curve: Curves.easeInOut),
      ),
    );

    _screenExitScaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.90, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  Future<void> _navigateToTarget() async {
    if (!mounted) return;
    context.go('/role-selection');
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _particleController]),
        builder: (context, child) {
          final exitOpacity = _screenExitFadeAnimation.value;
          final exitScale = _screenExitScaleAnimation.value;
          final bgProg = _bgGradientAnimation.value;

          return Opacity(
            opacity: exitOpacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: exitScale,
              child: Stack(
                children: [
                  // 1. Scene 1 Surface Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(
                              AppColors.primaryTerracotta.withValues(alpha: 0.10),
                              AppColors.cream,
                              bgProg,
                            )!,
                            AppColors.cream,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // 2. Scene 1 & 2 Background Mandalas & Floating Particles
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MandalaBackgroundPainter(
                        animationValue: _particleController.value,
                        mandalaOpacity: _mandalaOpacityAnimation.value,
                        particleOpacity: _particleOpacityAnimation.value,
                        motifDrawProgress: _motifDrawProgressAnimation.value,
                      ),
                    ),
                  ),

                  // 3. Main Center Content
                  SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),

                            // VIRASAT Animated V-Logo Mark
                            Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: SizedBox(
                                width: 220,
                                height: 220,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomPaint(
                                      size: const Size(220, 220),
                                      painter: VirasatLogoPainter(
                                        outlineProgress: _outlineProgressAnimation.value,
                                        leafProgress: _leafProgressAnimation.value,
                                        artisanProgress: _artisanProgressAnimation.value,
                                        glowProgress: _glowProgressAnimation.value,
                                        sunMonumentProgress: _sunMonumentAnimation.value,
                                      ),
                                    ),
                                    if (_sunMonumentAnimation.value > 0.0)
                                      Opacity(
                                        opacity: _sunMonumentAnimation.value.clamp(0.0, 1.0),
                                        child: Image.asset(
                                          'assets/logos/virasat_v_mark_tight.png',
                                          width: 175,
                                          height: 175,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Scene 5 Typography Sequence
                            Opacity(
                              opacity: _textFadeAnimation.value.clamp(0.0, 1.0),
                              child: Transform.translate(
                                offset: Offset(0, _textSlideAnimation.value),
                                child: Column(
                                  children: [
                                    // Title: VIRASAT
                                    Text(
                                      'VIRASAT',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 8,
                                        color: AppColors.primaryTerracotta,
                                        height: 1.1,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Subtitle Badge: Crafted by India
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.saffronGold.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.saffronGold.withValues(alpha: 0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'Crafted by India',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2.5,
                                          color: AppColors.darkBrown,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Tagline: People • Crafts • Culture
                                    Text(
                                      'People  •  Crafts  •  Culture',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
