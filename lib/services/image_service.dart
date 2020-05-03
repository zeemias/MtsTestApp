
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageService {
  static Future<Image> resizeAndCropImage(String imageSrc) async {
    var imageData = await rootBundle.load(imageSrc);
    var image = await decodeImageFromList(imageData.buffer.asUint8List());
    log('sourceWidth: ${image.width}, sourceHeight: ${image.height}');
    
    double resizeWidth = image.width >= image.height
      ? 1200 
      : 1200 * image.width / image.height;

    double resizeHeight = image.width <= image.height 
      ? 1200 
      : 1200 * image.height / image.width;

    var codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(), 
      targetWidth: resizeWidth.toInt(), 
      targetHeight: resizeHeight.toInt()
    );

    var frame = await codec.getNextFrame();
    var resizedImage = frame.image;

    double croppedHeight = resizeWidth * 0.5625;
    double verticalSpacing = (resizeHeight - croppedHeight) / 2;

    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder);

    canvas.drawImageRect(
      resizedImage,
      Rect.fromLTWH(0.0, verticalSpacing, resizeWidth, croppedHeight),
      Rect.fromLTWH(0.0, 0.0, resizeWidth, croppedHeight),
      Paint(),
    );

    var picture = recorder.endRecording();
    var croppedImage = await picture.toImage(resizeWidth.toInt(), croppedHeight.toInt());
    var byte = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    var byteList = byte.buffer.asUint8List();
    var imageResult = Image.memory(byteList, fit: BoxFit.fitWidth);
    log('croppedWidth: ${croppedImage.width}, croppedHeight: ${croppedImage.height}');

    // Пауза.
    await Future.delayed(const Duration(seconds: 3));

    return imageResult;
  }
}