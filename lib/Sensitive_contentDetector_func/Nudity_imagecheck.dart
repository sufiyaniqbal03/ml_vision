
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


Future<bool> detectNudityInImage(File imageFile) async {
  /*The below function is made to use the check for image but due to some unstable and current change in the firebase_ml_vision
  it was giving error*/
  final  visionImage = FirebaseVisionImage.fromFile(imageFile);
  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  final List<ImageLabel> labels = await labeler.processImage(visionImage);

  for (ImageLabel label in labels) {
    if (label.text?.toLowerCase() == 'nudity' && label.confidence != null &&
        label.confidence! > 0.5) {
      return true;
    }
  }
  return false;
}




