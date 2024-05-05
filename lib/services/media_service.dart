


import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService{
  static MediaService get instance => MediaService();

  Future<XFile?> getImageFromGallery(){
    return ImagePicker().pickImage(source: ImageSource.gallery);
  }
}