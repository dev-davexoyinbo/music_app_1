import 'package:flutter/material.dart';

class PlayingWidgetSm extends StatelessWidget {

  late final Function _displayMediaSheetAction;
  PlayingWidgetSm({Key? key, Function? displayMediaSheetAction}) : super(key: key){
    this._displayMediaSheetAction = displayMediaSheetAction ?? (bool val){};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              _displayMediaSheetAction(true);
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/music_cover.jpg"),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pain",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Ryan Jones",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow, size: 32, color: Colors.grey[200]),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.clear_outlined, size: 32, color: Colors.grey[200])
            ],
          ),
        ],
      ),
    );
  }
}
