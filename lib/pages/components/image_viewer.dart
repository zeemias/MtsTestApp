import 'package:flutter/material.dart';
import 'package:mts_test_app/models/enums/constants.dart';
import 'package:mts_test_app/models/pictures.dart';

class ImageViewer extends StatelessWidget {
  final int selectedPageIndex;

  ImageViewer({ 
    this.selectedPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    var picture = Pictures.pictures[selectedPageIndex];

    return StreamBuilder<bool>(
      stream: picture.openedController.stream,
      builder: (context, openedControllerSnapshot) {
        if (!picture.opened)
          return Container();

        return Container(
          decoration: BoxDecoration(
            color: kOverlayColor,
          ),
          child: Stack(
            children: <Widget>[
              Center(
                // child: Image.asset(
                //   Pictures.pictures[selectedPageIndex].image,
                //   fit: BoxFit.fill,
                // ),
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