import 'package:flutter/material.dart';
import 'package:music_app_trial_1/my_theme.dart';


class MyScrollBar extends StatelessWidget {
  const MyScrollBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.polymer,
            color: MyTheme.accentColor,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                child: Icon(Icons.search),
              ),
              Stack(alignment: AlignmentDirectional.center, children: [
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    // padding: EdgeInsets.all(6),
                    height: 20,
                    width: 20,
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: MyTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ]),
            ],
          )
        ],
      ),
    );
  }//end build method
}//end
