import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb constant

class CloudStorageService {
  CloudStorageService._({required FirebaseStorage storage})
      : _storage = storage,
        baseRef = storage.ref();

  static final CloudStorageService instance = CloudStorageService._(
    storage: FirebaseStorage.instance,
  );

  final FirebaseStorage _storage;
  final Reference baseRef;
  final String profileImage = 'profile_images';

  Future<String> uploadUserImage(String uid, File image) async {
    try {
      final String filePath = '$profileImage/$uid'; // Combine path elements
      final Reference uploadTask = baseRef.child(filePath);

      // Handle web vs. mobile/desktop platform-specific uploads
      if (kIsWeb) {
        // Web: Use putData() for browser file selection
        final Uint8List imageBytes = await image.readAsBytes();
        final uploadTaskSnapshot = await uploadTask.putData(imageBytes);
        final imageUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        // Mobile/desktop: Use putFile() for device file system access
        final uploadTaskSnapshot = await uploadTask.putFile(image);
        final imageUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        return imageUrl;
      }
    } on FirebaseException catch (e) {
      // Handle specific Firebase Storage errors
      if (e.code == 'storage/object-not-found') {
        print('File or directory not found.');
      } else if (e.code == 'storage/unauthorized') {
        print('User does not have permission to access this storage bucket.');
      } else if (e.code == 'storage/canceled') {
        print('Upload was canceled (possibly due to user action).');
      } else {
        print('An unexpected error occurred: ${e.code} - ${e.message}');
      }
      rethrow; // Rethrow the exception for further handling in the UI
    } catch (error) {
      // Handle other non-Firebase exceptions
      print('An unknown error occurred: $error');
      rethrow; // Rethrow the exception for further handling in the UI
    }
  }
}
