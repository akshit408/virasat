import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/speech_recognition_service.dart';
import '../../core/theme/app_colors.dart';
import '../../features/ai_scanner/models/ai_product_analysis_model.dart';
import '../../features/ai_scanner/services/ai_product_scanner_service.dart';
import '../../models/gi_product_model.dart';
import '../../models/user_model.dart';
import '../../providers/artisan_hub_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/supabase_service.dart';
import '../../services/gemini_vision_service.dart';
import '../../widgets/sheets/phone_auth_sheet.dart';

class SellMyCraftScreen extends ConsumerStatefulWidget {
  const SellMyCraftScreen({super.key});

  @override
  ConsumerState<SellMyCraftScreen> createState() => _SellMyCraftScreenState();
}

class _SellMyCraftScreenState extends ConsumerState<SellMyCraftScreen> {
  int _currentStep = 1;
  bool _isAiScanning = false;
  bool _isRecordingVoice = false;
  bool _isGeneratingStory = false;
  bool _isPublishing = false;
  bool _showEnhancedImage = true;
  String _selectedLanguage = 'English';
  String _voiceStatusText = '';
  String? _aiScanError;
  String _originalEnglishStory = '';
  AIProductAnalysis? _currentAnalysis;

  // Form Controllers — Initialized empty until real Gemini analysis runs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _materialsController = TextEditingController();
  final TextEditingController _techniqueController = TextEditingController();
  final TextEditingController _giStatusController = TextEditingController();
  final TextEditingController _craftingTimeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();
  final TextEditingController _voiceTranscriptController = TextEditingController();

  double _sellingPrice = 0.0;
  final List<String> _uploadedPhotoSlots = [];

  final List<String> _languages = AIProductScannerService.supportedLanguages22;

  @override
  void dispose() {
    SpeechRecognitionService.stopListening();
    _nameController.dispose();
    _categoryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _materialsController.dispose();
    _techniqueController.dispose();
    _giStatusController.dispose();
    _craftingTimeController.dispose();
    _priceController.dispose();
    _storyController.dispose();
    _voiceTranscriptController.dispose();
    super.dispose();
  }

  Future<void> _triggerAiScan() async {
    if (_uploadedPhotoSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload or take at least 1 photo of your craft.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isAiScanning = true;
      _aiScanError = null;
    });

    try {
      final analysis = await AIProductScannerService.analyzeUploadedImages(
        _uploadedPhotoSlots,
        targetLanguage: _selectedLanguage,
      );

      if (mounted) {
        setState(() {
          _currentAnalysis = analysis;
          _nameController.text = analysis.productName;
          _categoryController.text = analysis.category;
          _stateController.text = analysis.state;
          _cityController.text = analysis.city;
          _materialsController.text = analysis.materials.join(', ');
          _techniqueController.text = analysis.technique;
          _giStatusController.text = analysis.isGICandidate ? 'High (GI Eligible Region)' : 'Standard Craft';
          _craftingTimeController.text = '${(analysis.estimatedHours / 8).round()} Days (${analysis.estimatedHours} Hours)';
          _priceController.text = analysis.suggestedPrice.round().toString();
          _sellingPrice = (analysis.suggestedPrice > 0 ? analysis.suggestedPrice : 2800.0).clamp(500.0, 100000.0);
          _storyController.text = analysis.heritageStory;
          _originalEnglishStory = analysis.heritageStory;

          _isAiScanning = false;
          _aiScanError = null;
          _currentStep = 2;
        });
      }
    } catch (e) {
      debugPrint('[SellMyCraftScreen] Gemini Vision Exception: $e. Generating fresh visual craft analysis...');
      final fallback = GeminiVisionService().analyzeCraftImage(
        _uploadedPhotoSlots.first,
        additionalImages: _uploadedPhotoSlots.skip(1).toList(),
      );
      final analysis = await fallback;
      if (mounted) {
        setState(() {
          _currentAnalysis = analysis;
          _nameController.text = analysis.productName;
          _categoryController.text = analysis.category;
          _stateController.text = analysis.state;
          _cityController.text = analysis.city;
          _materialsController.text = analysis.materials.join(', ');
          _techniqueController.text = analysis.technique;
          _giStatusController.text = analysis.isGICandidate ? 'High (GI Eligible Region)' : 'Standard Craft';
          _craftingTimeController.text = '${(analysis.estimatedHours / 8).round()} Days (${analysis.estimatedHours} Hours)';
          _priceController.text = analysis.suggestedPrice.round().toString();
          _sellingPrice = (analysis.suggestedPrice > 0 ? analysis.suggestedPrice : 2800.0).clamp(500.0, 100000.0);
          _storyController.text = analysis.heritageStory;

          _isAiScanning = false;
          _aiScanError = null;
          _currentStep = 2;
        });
      }
    }
  }

  Future<void> _triggerVoiceRecording() async {
    if (_isRecordingVoice) {
      await SpeechRecognitionService.stopListening();
      setState(() {
        _isRecordingVoice = false;
        _voiceStatusText = 'Speech Captured Successfully.';
      });
      return;
    }

    setState(() {
      _isRecordingVoice = true;
      _voiceStatusText = 'Listening in $_selectedLanguage... Speak now!';
    });

    await SpeechRecognitionService.startListening(
      language: _selectedLanguage,
      onResult: (text) {
        if (!mounted) return;
        debugPrint('[SellMyCraftScreen] Speech transcript received: "$text"');
        setState(() {
          _voiceTranscriptController.text = text;
          _voiceStatusText = 'Listening... Speech recognized!';
          if (_storyController.text.isEmpty) {
            _storyController.text = text;
          }
        });
      },
      onStatusChange: (status) {
        if (!mounted) return;
        setState(() {
          switch (status) {
            case SpeechListenerStatus.listening:
              _voiceStatusText = 'Listening in $_selectedLanguage...';
              _isRecordingVoice = true;
              break;
            case SpeechListenerStatus.processing:
              _voiceStatusText = 'Processing speech with VIRASAT AI...';
              break;
            case SpeechListenerStatus.completed:
              _voiceStatusText = 'Speech Captured Successfully.';
              _isRecordingVoice = false;
              break;
            case SpeechListenerStatus.error:
              _voiceStatusText = 'Speech recognition issue. Tap mic to retry.';
              _isRecordingVoice = false;
              break;
            default:
              _isRecordingVoice = false;
          }
        });
      },
      onError: (err) {
        if (!mounted) return;
        setState(() {
          _isRecordingVoice = false;
          _voiceStatusText = 'Error: $err';
        });
      },
    );
  }

  Future<void> _translateStoryToLanguage(String targetLanguage) async {
    setState(() {
      _selectedLanguage = targetLanguage;
    });

    if (_storyController.text.trim().isEmpty) return;

    if (targetLanguage.toLowerCase() == 'english' && _originalEnglishStory.isNotEmpty) {
      setState(() {
        _storyController.text = _originalEnglishStory;
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Translating heritage story into $targetLanguage...'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );

    try {
      final translated = await AIProductScannerService.translateText(
        _storyController.text,
        targetLanguage,
        contextInfo: 'Heritage story for craft "${_nameController.text}"',
      );
      if (mounted) {
        setState(() {
          _storyController.text = translated;
        });
      }
    } catch (e) {
      debugPrint('[SellMyCraftScreen] Live translation error: $e');
    }
  }

  Future<void> _regenerateStoryWithAi() async {
    setState(() {
      _isGeneratingStory = true;
    });

    final craftTitle = _nameController.text.isNotEmpty ? _nameController.text : 'Handcrafted Heritage Craft';
    final state = _stateController.text.isNotEmpty ? _stateController.text : 'India';
    final materials = _materialsController.text.isNotEmpty ? _materialsController.text : 'natural eco-friendly raw materials';
    final technique = _techniqueController.text.isNotEmpty ? _techniqueController.text : 'ancestral handcrafting techniques';

    try {
      final story = await AIProductScannerService.generateHeritageStory(
        craftName: craftTitle,
        stateName: state,
        materials: materials,
        technique: technique,
      );

      if (mounted) {
        setState(() {
          _storyController.text = story;
          _isGeneratingStory = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI Heritage Story regenerated successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingStory = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not generate story: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _regenerateStoryWithAi,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isGuest || !authState.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('AI Sell My Craft', style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_outline_rounded, size: 56, color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Artisan Sign In Required',
                  style: TextStyle(fontFamily: 'Playfair Display', fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please sign in to list handcrafted products. All published items will sync directly to the live database.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => PhoneAuthSheet.show(context, initialRole: UserRole.artisan),
                    icon: const Icon(Icons.phone_android_rounded),
                    label: const Text('Sign in with Phone Number (OTP)', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                    icon: const Icon(Icons.g_mobiledata_rounded, color: Colors.red, size: 28),
                    label: const Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/login'),
                    icon: const Icon(Icons.mail_outline_rounded, color: AppColors.primary),
                    label: const Text('Sign in with Email', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'AI Sell My Craft',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Step $_currentStep of 7: ${_getStepTitle(_currentStep)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${((_currentStep / 7) * 100).toInt()}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: _currentStep / 7,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 4,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildStepContent(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (_currentStep > 1)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _currentStep--);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Text('Back', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ),
              if (_currentStep > 1) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: (_isPublishing || (_currentStep == 2 && !_isCurrentCraftValid)) ? null : _onNextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isPublishing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                            SizedBox(width: 10),
                            Text('Publishing Live...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        )
                      : Text(
                          _currentStep == 7 ? 'Publish to VIRASAT' : 'Continue to Step ${_currentStep + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return AppLocalizations.tr(context, 'scanner_step_1');
      case 2:
        return AppLocalizations.tr(context, 'scanner_step_2');
      case 3:
        return AppLocalizations.tr(context, 'scanner_step_3');
      case 4:
        return AppLocalizations.tr(context, 'scanner_step_4');
      case 5:
        return AppLocalizations.tr(context, 'scanner_step_5');
      case 6:
        return AppLocalizations.tr(context, 'scanner_step_6');
      case 7:
        return AppLocalizations.tr(context, 'scanner_step_7');
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1UploadPhotos();
      case 2:
        return _buildStep2AiAnalysis();
      case 3:
        return _buildStep3SmartPricing();
      case 4:
        return _buildStep4HeritageStory();
      case 5:
        return _buildStep5VoiceListing();
      case 6:
        return _buildStep6ImageEnhancement();
      case 7:
        return _buildStep7PreviewPublish();
      default:
        return Container();
    }
  }

  // STEP 1: Upload Photos
  Widget _buildStep1UploadPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Upload Product Photos',
          style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Upload 2 to 5 clear photos of your handcrafted masterpiece.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),

        const SizedBox(height: 12),

        // Photos Grid with Actual Images & Success Checkmarks
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: 6,
          itemBuilder: (context, idx) {
            if (idx < _uploadedPhotoSlots.length) {
              final path = _uploadedPhotoSlots[idx];
              final isAsset = path.startsWith('assets/');

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: isAsset
                            ? Image.asset(
                                path,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.primary.withValues(alpha: 0.2)),
                              )
                            : (kIsWeb || path.startsWith('blob:') || path.startsWith('http'))
                                ? Image.network(
                                    path,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: AppColors.primary.withValues(alpha: 0.2),
                                      child: const Icon(Icons.image, color: Colors.white),
                                    ),
                                  )
                                : Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: AppColors.primary.withValues(alpha: 0.2),
                                      child: const Icon(Icons.image, color: Colors.white),
                                    ),
                                  ),
                      ),
                      if (idx == 0)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(6)),
                            child: const Text('COVER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      // Success Checkmark Badge
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          child: const Icon(Icons.check, size: 10, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _uploadedPhotoSlots.removeAt(idx));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () => _showAddPhotoBottomSheet(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 26),
                      SizedBox(height: 4),
                      Text('Add Photo', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                    ],
                  ),
                ),
              );
            }
          },
        ),

        const SizedBox(height: 20),

        // AI Tips Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_rounded, color: AppColors.secondary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'AI Tips for Better Detection',
                    style: TextStyle(fontFamily: 'Playfair Display', fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTipBullet('Natural Studio Light: Avoid dark shadows or heavy glare.'),
              _buildTipBullet('Neutral Backdrop: Place craft on plain white sheet or wooden surface.'),
              _buildTipBullet('Detail View: Include 1 close-up of intricate craft details/texture.'),
            ],
          ),
        ),

        const SizedBox(height: 24),
        if (_isAiScanning)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.secondary),
            ),
            child: const Row(
              children: [
                CircularProgressIndicator(color: AppColors.secondary),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VIRASAT AI Craft Scanner Active...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Analyzing craft texture, materials, and origin via VIRASAT AI Vision...', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _uploadedPhotoSlots.isNotEmpty ? _triggerAiScan : null,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(_uploadedPhotoSlots.isNotEmpty ? 'Analyze Photos with VIRASAT AI' : 'Upload At Least 1 Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTipBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCameraPhoto() async {
    final hasPermission = await PermissionService.requestCameraPermission(context);
    if (!hasPermission) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (photo != null && mounted) {
        setState(() {
          _uploadedPhotoSlots.add(photo.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open camera: $e')),
        );
      }
    }
  }

  Future<void> _pickGalleryPhotos() async {
    final hasPermission = await PermissionService.requestGalleryPermission(context);
    if (!hasPermission) return;

    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> photos = await picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (photos.isNotEmpty && mounted) {
        setState(() {
          for (final photo in photos) {
            _uploadedPhotoSlots.add(photo.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick photos: $e')),
        );
      }
    }
  }

  void _showAddPhotoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                title: const Text('Take Photo with Camera', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickCameraPhoto();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.secondary),
                title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickGalleryPhotos();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // STEP 2: AI Product Analysis
  bool get _isCurrentCraftValid {
    final cat = _categoryController.text.toLowerCase();
    final name = _nameController.text.toLowerCase();
    final tech = _techniqueController.text.toLowerCase();
    final invalidKeywords = ['electronics', 'electronic', 'appliance', 'appliances', 'plastic product', 'plastic', 'mobile accessory', 'factory product', 'gadget', 'charger'];
    for (final kw in invalidKeywords) {
      if (cat.contains(kw) || name.contains(kw) || tech.contains(kw)) {
        return false;
      }
    }
    return true;
  }

  Widget _buildStep2AiAnalysis() {
    final isHandicraft = _isCurrentCraftValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 2: AI Product Analysis', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('AI auto-filled product attributes based on visual recognition. Edit any value.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 16),

        if (!isHandicraft) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This item is not an Indian handicraft or GI-certified craft.',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentStep = 1;
                        _uploadedPhotoSlots.clear();
                      });
                    },
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Upload Another Image'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        if (_aiScanError != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'AI analysis unavailable',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _aiScanError!,
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _triggerAiScan,
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
          ),
          const SizedBox(height: 20),
        ],

        _buildInputField('Product Title', _nameController),
        _buildInputField('Craft Category', _categoryController),
        Row(
          children: [
            Expanded(child: _buildInputField('State', _stateController)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('City / Cluster', _cityController)),
          ],
        ),
        _buildInputField('Raw Materials', _materialsController),
        _buildInputField('Craft Technique', _techniqueController),
        Row(
          children: [
            Expanded(child: _buildInputField('GI Tag Status', _giStatusController)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Crafting Time', _craftingTimeController)),
          ],
        ),
      ],
    );
  }

  // STEP 3: Smart Pricing
  Widget _buildStep3SmartPricing() {
    final matName = _materialsController.text.isNotEmpty ? _materialsController.text : 'Natural Materials';
    final craftingHours = _craftingTimeController.text.isNotEmpty ? _craftingTimeController.text : 'Ancestral Handwork';

    final double analysisSuggested = _currentAnalysis?.suggestedPrice ?? 2400.0;
    final double basePrice = _sellingPrice > 0 ? _sellingPrice : (analysisSuggested > 0 ? analysisSuggested : 2400.0);

    final double matCost = _currentAnalysis?.materialCost != null && _currentAnalysis!.materialCost > 0
        ? _currentAnalysis!.materialCost
        : (basePrice * 0.40);

    final double laborCost = _currentAnalysis?.laborCost != null && _currentAnalysis!.laborCost > 0
        ? _currentAnalysis!.laborCost
        : (basePrice * 0.60);

    final double recPrice = matCost + laborCost;

    final int profitMarginPercent = recPrice > 0
        ? (((recPrice - matCost) / recPrice) * 100).round().clamp(10, 90)
        : 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 3: Fair Trade Smart Pricing', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('AI calculated fair payout based on material cost and labor hours.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildPriceBreakdownRow('Material Cost ($matName)', '₹ ${matCost.round()}'),
              const SizedBox(height: 8),
              _buildPriceBreakdownRow('Labor & Craftsmanship ($craftingHours)', '₹ ${laborCost.round()}'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('AI Recommended Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('₹ ${recPrice.round()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Artisan Profit Margin: $profitMarginPercent%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Adjust Your Final Selling Price (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('₹ ${_sellingPrice.round()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
          ],
        ),
        Slider(
          value: _sellingPrice.clamp(100.0, 100000.0),
          min: 100,
          max: 50000,
          divisions: 499,
          activeColor: AppColors.primary,
          label: '₹ ${_sellingPrice.clamp(100.0, 50000.0).toStringAsFixed(0)}',
          onChanged: (val) {
            setState(() {
              _sellingPrice = val;
              _priceController.text = val.toStringAsFixed(0);
            });
          },
        ),
      ],
    );
  }

  // STEP 4: Heritage Story
  Widget _buildStep4HeritageStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 4: Heritage Story Generator', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('AI generated heritage narrative to captivate buyers and explain craft history.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 16),

        const Text('Multilingual Heritage Translation (22 Indian Languages):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _languages.map((lang) {
              final isSelected = lang == _selectedLanguage;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(lang, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textPrimary)),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onSelected: (val) {
                    if (val) {
                      _translateStoryToLanguage(lang);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        if (_isGeneratingStory)
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: AppColors.secondary, strokeWidth: 2),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'VIRASAT AI is composing a rich 80-120 word heritage story...',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),

        TextField(
          controller: _storyController,
          maxLines: 6,
          enabled: !_isGeneratingStory,
          style: const TextStyle(fontSize: 13, height: 1.4),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isGeneratingStory ? null : _regenerateStoryWithAi,
                icon: _isGeneratingStory
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      )
                    : const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text(_isGeneratingStory ? 'Generating...' : 'Regenerate with AI'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 5: Voice-to-Listing
  Widget _buildStep5VoiceListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 5: Voice-to-Listing Assistant', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Speak in your native regional language. AI transcribes and structures your product data.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 16),

        const Text('Target Speech Language (22 Indian Languages):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _languages.map((lang) {
              final isSelected = lang == _selectedLanguage;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(lang, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textPrimary)),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onSelected: (val) {
                    if (val) setState(() => _selectedLanguage = lang);
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _triggerVoiceRecording,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: _isRecordingVoice ? Colors.redAccent : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecordingVoice ? Colors.redAccent : AppColors.primary).withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecordingVoice ? Icons.mic_rounded : Icons.mic_none_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _voiceStatusText.isNotEmpty
                    ? _voiceStatusText
                    : (_isRecordingVoice ? 'Listening in $_selectedLanguage...' : 'Tap Mic to Speak Craft Details'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: _isRecordingVoice
                      ? Colors.redAccent
                      : (_voiceStatusText.contains('Captured') ? AppColors.success : AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text('Live AI Transcript:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: _voiceTranscriptController,
          maxLines: 3,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),
      ],
    );
  }

  // STEP 6: Image Enhancement
  Widget _buildStep6ImageEnhancement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 6: AI Studio Image Enhancement', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('AI automatically enhances studio lighting, isolates craft background & sharpens details.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterChip(
              selected: !_showEnhancedImage,
              label: const Text('Original Photo'),
              onSelected: (val) => setState(() => _showEnhancedImage = false),
            ),
            const SizedBox(width: 12),
            FilterChip(
              selected: _showEnhancedImage,
              label: const Text('AI Enhanced (Studio Light)'),
              selectedColor: AppColors.secondary.withValues(alpha: 0.3),
              onSelected: (val) => setState(() => _showEnhancedImage = true),
            ),
          ],
        ),

        const SizedBox(height: 16),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: _showEnhancedImage ? AppColors.primaryGradient : null,
            color: _showEnhancedImage ? null : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _showEnhancedImage ? Icons.auto_awesome_rounded : Icons.image_outlined,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  _showEnhancedImage ? 'Studio Lighted • Background Isolated' : 'Raw Craft Photograph',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // STEP 7: Preview & Publish
  Widget _buildStep7PreviewPublish() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 7: Product Preview & Publish', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Review how your listing appears in Artisan India before publishing.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 20),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Stack(
                  children: [
                    Center(child: Icon(Icons.auto_awesome_rounded, size: 80, color: Colors.white.withValues(alpha: 0.2))),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
                        child: const Text('AUTHENTIC GI TAGGED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_nameController.text, style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text('${_cityController.text}, ${_stateController.text}', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                    const SizedBox(height: 8),
                    Text('₹ ${_sellingPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 12),
                    Text(_storyController.text, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdownRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Future<void> _onNextStep() async {
    if (_currentStep < 7) {
      setState(() => _currentStep++);
    } else {
      if (_isPublishing) return;
      setState(() => _isPublishing = true);

      try {
        final stateText = _stateController.text;
        String imageUrl = _uploadedPhotoSlots.isNotEmpty ? _uploadedPhotoSlots.first : 'https://images.unsplash.com/photo-1606293926075-69a00dbfde81?w=800';

        // 1. Upload photo to Supabase storage if it's a local file / web blob
        if (_uploadedPhotoSlots.isNotEmpty && !_uploadedPhotoSlots.first.startsWith('http') && !_uploadedPhotoSlots.first.startsWith('assets/')) {
          try {
            final firstSlot = _uploadedPhotoSlots.first;
            final name = '${DateTime.now().millisecondsSinceEpoch}.jpg';
            List<int>? bytes;

            if (kIsWeb || firstSlot.startsWith('blob:')) {
              bytes = await XFile(firstSlot).readAsBytes();
            } else {
              final file = File(firstSlot);
              if (await file.exists()) {
                bytes = await file.readAsBytes();
              }
            }

            if (bytes != null && bytes.isNotEmpty) {
              final uploadedUrl = await SupabaseService.uploadProductImage(bytes, name);
              if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
                imageUrl = uploadedUrl;
              }
            }
          } catch (e) {
            debugPrint('[SellMyCraftScreen] Storage upload note: $e');
          }
        }

        final user = ref.read(authProvider).user;
        final validArtisanId = (user.id.isNotEmpty && user.id != 'guest_user') ? user.id : '524536a0-db7e-4d49-8e17-82c6770e2ccd';
        final validArtisanName = user.name.isNotEmpty ? user.name : 'Master Artisan';

        final newCraft = GiProductModel(
          id: 'published_${DateTime.now().millisecondsSinceEpoch}',
          name: _nameController.text.isNotEmpty ? _nameController.text : 'Handcrafted Heritage Art',
          stateName: stateText.isNotEmpty ? stateText : 'Gujarat',
          stateId: stateText.length >= 2 ? 'IN-${stateText.substring(0, 2).toUpperCase()}' : 'IN-GJ',
          district: _cityController.text.isNotEmpty ? _cityController.text : 'Craft Cluster',
          category: _categoryController.text.isNotEmpty ? _categoryController.text : 'Textiles',
          price: _sellingPrice,
          description: _storyController.text,
          imageUrl: imageUrl,
          imageUrls: [imageUrl],
          giTagYear: 2024,
          certifiedArtisanCount: 1,
          artisanId: validArtisanId,
          artisanName: validArtisanName,
          sellerName: validArtisanName,
        );

        // 2. Insert into Supabase live products table
        GiProductModel? insertedProduct;
        try {
          insertedProduct = await SupabaseService.insertProduct(newCraft);
        } catch (e) {
          debugPrint('[SellMyCraftScreen] insertProduct note: $e');
        }
        final finalProduct = insertedProduct ?? newCraft;

        // 3. Update local state & refresh buyer marketplace feeds
        SupabaseService.registerUserAddedProduct(finalProduct);
        ref.read(artisanProductsProvider.notifier).addProduct(finalProduct);
        ref.invalidate(featuredProductsProvider);
        ref.invalidate(filteredProductsProvider);
        ref.invalidate(marketplaceHomeDataProvider);

        if (!mounted) return;

        await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Product Published Live!',
                    style: TextStyle(fontFamily: 'Playfair Display', fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_nameController.text} is now live on Artisan India marketplace for buyers nationwide.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/artisan-products');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('View My Products'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } catch (e) {
        debugPrint('[SellMyCraftScreen] Publish exception: $e');
      } finally {
        if (mounted) {
          setState(() => _isPublishing = false);
        }
      }
    }
  }
}
