import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static bool _initialized = false;

  /// Ensures Firebase core is initialized.
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp();
      _initialized = true;
      debugPrint('[FirebaseService] Firebase initialized successfully.');
    } catch (e) {
      _initialized = true;
      debugPrint('[FirebaseService] Firebase initialization note: $e');
    }
  }

  /// Uploads an image file to Firebase Storage bucket and returns the public download URL.
  static Future<String> uploadProductImage(File imageFile, {String? customFileName}) async {
    await initialize();
    try {
      final fileName = customFileName ?? 'craft_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child('craft_images/$fileName');
      
      final uploadTask = await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      debugPrint('[LOG] Image upload success: URL=$downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('[LOG] Storage upload error: $e');
      throw Exception('Failed to upload image to Firebase Storage: $e');
    }
  }

  /// Saves or updates a product document in Firebase Firestore collection 'products'.
  static Future<String> saveProductToFirestore(Map<String, dynamic> productData, {String? docId}) async {
    await initialize();
    try {
      final collection = FirebaseFirestore.instance.collection('products');
      final now = DateTime.now().toIso8601String();
      final dataToSave = {
        ...productData,
        'updatedAt': now,
        'createdAt': productData['createdAt'] ?? now,
      };

      String id;
      if (docId != null && docId.isNotEmpty) {
        await collection.doc(docId).set(dataToSave, SetOptions(merge: true));
        id = docId;
      } else {
        final docRef = await collection.add(dataToSave);
        id = docRef.id;
        await docRef.update({'id': id});
      }

      debugPrint('[LOG] Firestore write success: docId=$id');
      return id;
    } catch (e) {
      debugPrint('[LOG] Firestore write failure: error=$e');
      throw Exception('Failed to write product data to Firestore: $e');
    }
  }

  /// Reads back a product document from Firestore collection 'products' by document ID.
  static Future<Map<String, dynamic>> getProductFromFirestore(String docId) async {
    await initialize();
    try {
      final docSnap = await FirebaseFirestore.instance.collection('products').doc(docId).get();
      if (!docSnap.exists || docSnap.data() == null) {
        debugPrint('[LOG] Firestore read failure: Product document $docId does not exist');
        throw Exception('Product document $docId does not exist in Firestore');
      }

      final data = docSnap.data()!;
      debugPrint('[LOG] Firestore read success: docId=$docId');
      return data;
    } catch (e) {
      debugPrint('[LOG] Firestore read failure: error=$e');
      throw Exception('Failed to read product data from Firestore: $e');
    }
  }
}
