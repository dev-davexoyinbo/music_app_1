import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app_trial_1/my_theme.dart';

class MusicDetailSheet extends StatefulWidget {
  const MusicDetailSheet({Key? key}) : super(key: key);

  @override
  _MusicDetailSheetState createState() => _MusicDetailSheetState();
}

class _MusicDetailSheetState extends State<MusicDetailSheet> {
  double _sliderValue = 20;
  late ScrollController scrollController;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        this.scrollController = scrollController;
        scrollController.addListener(_scrollControllerListener);

        return Container(
          decoration: BoxDecoration(
            color: MyTheme.darkColorBlur,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 20,
                  child: Center(
                    child: Container(
                      height: 6,
                      width: 60,
                      decoration: BoxDecoration(
                        color: MyTheme.darkColorLight2,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage("assets/images/music_cover.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pain",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 24),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite_border_outlined,
                                color: MyTheme.darkColorLight2),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.tune_outlined,
                                color: MyTheme.darkColorLight2),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Ryan Jones",
                      style: TextStyle(color: MyTheme.darkColorLight2),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 1,
                        trackShape: _CustomTrackShape(),
                      ),
                      child: Slider(
                          value: _sliderValue,
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = value;
                            });
                          },
                          label: "20",
                          min: 0,
                          max: 100,
                          activeColor: Colors.grey[300],
                          inactiveColor: Colors.grey[700]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "00:00",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "00:20",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.repeat, color: Colors.grey[500],),
                        Center(
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(Icons.skip_previous, color: MyTheme.darkColorBlur, ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(Icons.pause, color: MyTheme.darkColorBlur, size: 40,),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(Icons.skip_next, color: MyTheme.darkColorBlur,),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Icon(Icons.shuffle, color: Colors.grey[500],),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  } //end build t

  void _scrollControllerListener() {
    print(this.scrollController.position.pixels);
  }
} //end state class

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
