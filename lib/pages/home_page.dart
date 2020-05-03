import 'dart:async';

import 'package:flutter/material.dart';
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
    selectedPageIndexController.stream.listen((index) => {
      selectedPageIndex = index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE30611),
      body: OrientationBuilder(
        builder: (context, orientation) {
          var screenWidth = orientation == Orientation.portrait 
            ? MediaQuery.of(context).size.width 
            : MediaQuery.of(context).size.height;

          var padding = orientation == Orientation.portrait 
            ? 150.0 
            : 15.0;

          return Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: padding),
                    child: Text(
                      'MTC Photoshop',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream: selectedPageIndexController.stream,
                  builder: (context, selectedPageIndexSnapshot) {
                    return ImageSlider(
                      selectedPageIndex: selectedPageIndex,
                      orientation: orientation,
                      screenWidth: screenWidth,
                      onPageChanged: onPageChanged,
                    );
                  }
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: padding),
                    child: StreamBuilder<int>(
                      stream: selectedPageIndexController.stream,
                      builder: (context, selectedPageIndexSnapshot) {
                        return OperationButton(
                          selectedPageIndex: selectedPageIndex,
                        );
                      }
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream: selectedPageIndexController.stream,
                  builder: (context, selectedPageIndexSnapshot) {
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
    Pictures.pictures.forEach((picture) => {
      picture.dispose()
    });
    super.dispose();
  }
}