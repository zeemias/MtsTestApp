import 'package:flutter/material.dart';
import 'package:mts_test_app/models/enums/constants.dart';
import 'package:mts_test_app/models/enums/picture_state.dart';
import 'package:mts_test_app/models/pictures.dart';
import 'package:mts_test_app/services/image_service.dart';

class OperationButton extends StatelessWidget {
  final int selectedPageIndex;

  OperationButton({ 
    this.selectedPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    var picture = Pictures.pictures[selectedPageIndex];

    return StreamBuilder<PictureState>(
      stream: picture.stateController.stream,
      builder: (context, stateControllerSnapshot) {
        switch (picture.state) {
          case PictureState.notProcessed:
            return RaisedButton(
              color: kMtsWhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Обработать изображение',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () async {
                picture.stateController.add(PictureState.processing);
                picture.processedImage = await ImageService.resizeAndCropImage(picture.image);
                picture.stateController.add(PictureState.processed);
              },
            ); 

          case PictureState.processed:
            return RaisedButton(
              color: kMtsWhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Открыть изображение',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () {
                  picture.openedController.add(true);
              },
            );

          default:
          return Container();
        }
      },
    );
  }
}