import 'package:flutter/material.dart';
import 'package:mts_test_app/models/enums/constants.dart';
import 'package:mts_test_app/models/picture.dart';
import 'package:mts_test_app/models/pictures.dart';

class ImageViewer extends StatelessWidget {
  final int selectedPageIndex;

  ImageViewer({ 
    @required this.selectedPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    Picture picture = Pictures.pictures[selectedPageIndex];

    return StreamBuilder<bool>(
      stream: picture.openedController.stream,
      builder: (context, _) {
        if (!picture.opened)
          return Container();

        return Container(
          decoration: BoxDecoration(
            color: kOverlayColor,
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: picture.processedImage,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    tooltip: 'Закрыть',
                    backgroundColor: kMtsRedColor,
                    child: kIconClose,
                    onPressed: () {
                      picture.openedController.add(false);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}