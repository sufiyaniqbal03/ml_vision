import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

Future<bool> detectNudityInImage(File imageFile) async {
  /*The below function is made to use the check for image but due to some unstable and current change in the firebase_ml_vision
  it was giving error*/

  final visionImage = InputImage.fromFile(imageFile);
  final ImageLabelerOptions options =
      ImageLabelerOptions(confidenceThreshold: 0.5);
  final labeler = ImageLabeler(options: options);
  final List<ImageLabel> labels = await labeler.processImage(visionImage);

  for (ImageLabel label in labels) {
    if (label.label == 'nudity' && label.confidence > 0.5) {
      return true;
    }
  }

  return false;
}
