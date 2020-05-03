import 'package:flutter/material.dart';
import 'package:mts_test_app/models/enums/constants.dart';
import 'package:mts_test_app/models/enums/picture_state.dart';
import 'package:mts_test_app/models/pictures.dart';

class ImageSlider extends StatelessWidget {
  final int selectedPageIndex;
  final Orientation orientation;
  final double screenWidth;
  final Function(int pageIndex) onPageChanged;

  ImageSlider({ 
    this.selectedPageIndex,
    this.orientation,
    this.screenWidth,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    var viewportFraction = orientation == Orientation.portrait 
      ? 0.7 
      : 0.5;

    return PageView(
      controller: PageController(
        initialPage: selectedPageIndex,
        viewportFraction: viewportFraction,
      ),
      children: List<Widget>.generate(
        Pictures.pictures.length, (index) {
          return Center(
            child: Container(
              height: screenWidth * 0.65,
              width: screenWidth * 0.65,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(Pictures.pictures[index].image),
                  fit: BoxFit.cover,
                ),
              ),
              child: StreamBuilder<PictureState>(
                stream: Pictures.pictures[index].stateController.stream,
                builder: (context, stateControllerSnapshot) {
                  if (Pictures.pictures[index].state != PictureState.processing)
                    return Container();

                  return Container(
                    decoration: BoxDecoration(
                      color: kOverlayColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 30, 
                            maxWidth: 30
                          ),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kMtsRedColor),
                          ),
                        ),
                        Text(
                          'Обработка изображения',
                          style: TextStyle(
                            color: kMtsWhiteColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ), 
            ),
          );
        }, 
        growable: false,
      ),
      onPageChanged: onPageChanged,
    );
  }
}