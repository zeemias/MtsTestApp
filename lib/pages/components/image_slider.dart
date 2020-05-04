import 'package:flutter/material.dart';
import 'package:mts_test_app/models/enums/constants.dart';
import 'package:mts_test_app/models/enums/picture_state.dart';
import 'package:mts_test_app/models/pictures.dart';

class ImageSlider extends StatelessWidget {
  final int selectedPageIndex;
  final bool orientationPortrait;
  final Function(int pageIndex) onPageChanged;

  ImageSlider({
    @required this.selectedPageIndex,
    @required this.orientationPortrait,
    @required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(
        initialPage: selectedPageIndex,
        viewportFraction: orientationPortrait ? 0.7 : 0.5,
      ),
      children: List<Widget>.generate(
        Pictures.pictures.length,
        (index) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.shortestSide * 0.65,
              width: MediaQuery.of(context).size.shortestSide * 0.65,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Pictures.pictures[index].image),
                  fit: BoxFit.cover,
                ),
              ),
              child: StreamBuilder<PictureState>(
                stream: Pictures.pictures[index].stateController.stream,
                builder: (context, _) {
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
                          constraints:
                              BoxConstraints(maxHeight: 30, maxWidth: 30),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kMtsRedColor),
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
