import 'package:flutter/material.dart';
import 'package:music_app_trial_1/widgets/track_strip.dart';

class TracksTab extends StatefulWidget {
  const TracksTab({Key? key}) : super(key: key);

  @override
  _TracksTabState createState() => _TracksTabState();
}

class _TracksTabState extends State<TracksTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TrackStrip(
                isPlaying: index == 2,
                image: AssetImage(index % 2 == 0
                    ? "assets/images/music_cover.jpg"
                    : "assets/images/therapy_session.jpg"),
                name: index % 2 == 0 ? "Pain" : "Therapy Session",
                artist: index % 2 == 0 ? "Ryan Jones" : "NF",
                timeString: index % 2 == 0 ? "02:12" : "02:48",
              ),
            );
          }),
    );
  }
}
