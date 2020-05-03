import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mts_test_app/models/enums/picture_state.dart';

class Picture {
  final String image;
  bool opened;
  PictureState state;
  Image processedImage;
  StreamController<bool> openedController;
  StreamController<PictureState> stateController;  

  Picture({ 
    @required this.image,
    this.state = PictureState.notProcessed,
    this.opened = false,
  }) {
    this.openedController = StreamController<bool>.broadcast();
    this.openedController.stream.listen((opened) => {
      this.opened = opened
    });

    this.stateController = StreamController<PictureState>.broadcast();
    this.stateController.stream.listen((state) => {
      this.state = state
    });
  }

  void dispose(){
    stateController.close();
    openedController.close();
  }
}