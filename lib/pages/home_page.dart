import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mts_test_app/models/enums/constants.dart';
import 'package:mts_test_app/models/pictures.dart';
import 'package:mts_test_app/pages/components/image_slider.dart';
import 'package:mts_test_app/pages/components/image_viewer.dart';
import 'package:mts_test_app/pages/components/operation_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPageIndex = 0;
  StreamController<int> selectedPageIndexController;

  @override
  void initState() {
    super.initState();
    selectedPageIndexController = StreamController<int>.broadcast();
    selectedPageIndexController.stream
        .listen((index) => {selectedPageIndex = index});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMtsRedColor,
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool orientationPortrait = orientation == Orientation.portrait;
          double padding = orientationPortrait
              ? MediaQuery.of(context).size.height * 0.15
              : MediaQuery.of(context).size.height * 0.015;

          return Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: padding),
                    child: Text(
                      'MTC Cropper',
                      style: TextStyle(
                        color: kMtsWhiteColor,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<int>(
                    stream: selectedPageIndexController.stream,
                    builder: (context, _) {
                      return ImageSlider(
                        selectedPageIndex: selectedPageIndex,
                        orientationPortrait: orientationPortrait,
                        onPageChanged: onPageChanged,
                      );
                    }),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: padding),
                    child: StreamBuilder<int>(
                        stream: selectedPageIndexController.stream,
                        builder: (context, _) {
                          return OperationButton(
                            selectedPageIndex: selectedPageIndex,
                          );
                        }),
                  ),
                ),
                StreamBuilder<int>(
                  stream: selectedPageIndexController.stream,
                  builder: (context, _) {
                    return ImageViewer(
                      selectedPageIndex: selectedPageIndex,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onPageChanged(int pageIndex) {
    selectedPageIndexController.add(pageIndex);
  }

  @override
  void dispose() {
    selectedPageIndexController.close();
    Pictures.pictures.forEach((picture) => {picture.dispose()});
    super.dispose();
  }
}
