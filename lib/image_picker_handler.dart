import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_altaoss/image_picker_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;

  ImagePickerHandler(this._listener, this._controller);
  String filename;

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    cropImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 525,
      maxHeight: 525,
      aspectRatioPresets:[
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
    );
    filename=basename(croppedFile.path);
    //filename=basename(image.path);
    _listener.userImage(croppedFile,filename);
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image,String _filename);
}
