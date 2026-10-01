import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_colors.dart';

class PermissionService {
  PermissionService._();

  /// Requests Microphone permission for voice recording and speech recognition.
  static Future<bool> requestMicrophonePermission([BuildContext? context]) async {
    try {
      final status = await Permission.microphone.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        if (context != null && context.mounted) {
          _showSettingsDialog(
            context,
            title: 'Microphone Permission Required',
            message: 'Microphone access is required for voice-to-listing and recording craft descriptions. Please enable Microphone permission in application settings.',
          );
        }
        return false;
      }

      final requestResult = await Permission.microphone.request();
      if (requestResult.isGranted) {
        return true;
      }

      if (requestResult.isPermanentlyDenied && context != null && context.mounted) {
        _showSettingsDialog(
          context,
          title: 'Microphone Permission Required',
          message: 'Microphone access is required for voice recording. Please enable Microphone permission in application settings.',
        );
      } else if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required to record voice description.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting microphone permission: $e');
      return true; // Fallback gracefully
    }
  }

  /// Requests GPS Location permission to discover nearby crafts within 50 km.
  static Future<bool> requestLocationPermission(BuildContext context) async {
    try {
      final status = await Permission.locationWhenInUse.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        if (context.mounted) {
          _showSettingsDialog(
            context,
            title: 'Location Permission Required',
            message: 'Location access is required to show crafts newly listed near you within 50 km. Please enable Location permission in application settings.',
          );
        }
        return false;
      }

      final requestResult = await Permission.locationWhenInUse.request();
      if (requestResult.isGranted) {
        return true;
      }

      if (requestResult.isPermanentlyDenied && context.mounted) {
        _showSettingsDialog(
          context,
          title: 'Location Permission Required',
          message: 'Location access is required to find nearby crafts. Please enable Location permission in settings.',
        );
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  /// Requests Camera permission with rationale dialogs for denied/permanently denied states.
  static Future<bool> requestCameraPermission(BuildContext context) async {
    try {
      final status = await Permission.camera.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        if (context.mounted) {
          _showSettingsDialog(
            context,
            title: 'Camera Permission Required',
            message: 'Camera access is required to capture photos of your craft products. Please enable Camera permission in application settings.',
          );
        }
        return false;
      }

      final requestResult = await Permission.camera.request();
      if (requestResult.isGranted) {
        return true;
      }

      if (requestResult.isPermanentlyDenied && context.mounted) {
        _showSettingsDialog(
          context,
          title: 'Camera Permission Required',
          message: 'Camera access is required to capture photos of your craft products. Please enable Camera permission in application settings.',
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to capture product photos.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting camera permission: $e');
      return true; // Fallback to let ImagePicker handle intent gracefully
    }
  }

  /// Requests Photo Gallery permission for both Android 13+ (READ_MEDIA_IMAGES)
  /// and backward compatible Android storage permissions.
  static Future<bool> requestGalleryPermission(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        // Try photos permission for Android 13+ first
        final photoStatus = await Permission.photos.status;
        if (photoStatus.isGranted || photoStatus.isLimited) {
          return true;
        }

        final photoRequest = await Permission.photos.request();
        if (photoRequest.isGranted || photoRequest.isLimited) {
          return true;
        }

        // Try storage permission for Android 12 and below
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          return true;
        }

        final storageRequest = await Permission.storage.request();
        if (storageRequest.isGranted) {
          return true;
        }

        if (photoRequest.isPermanentlyDenied || storageRequest.isPermanentlyDenied) {
          if (context.mounted) {
            _showSettingsDialog(
              context,
              title: 'Gallery Permission Required',
              message: 'Access to photo gallery is required to select images of your craft products. Please enable Photos or Storage permission in application settings.',
            );
          }
          return false;
        }
      } else {
        // iOS Photo Library
        final status = await Permission.photos.status;
        if (status.isGranted || status.isLimited) return true;
        final request = await Permission.photos.request();
        if (request.isGranted || request.isLimited) return true;

        if (request.isPermanentlyDenied && context.mounted) {
          _showSettingsDialog(
            context,
            title: 'Photo Library Permission Required',
            message: 'Access to photo gallery is required to select images. Please enable Photo permission in settings.',
          );
        }
        return false;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery permission is required to choose photos.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting gallery permission: $e');
      return true; // Fallback to let ImagePicker handle intent gracefully
    }
  }

  /// Displays user-friendly dialog redirecting to app settings.
  static void _showSettingsDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Open Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
