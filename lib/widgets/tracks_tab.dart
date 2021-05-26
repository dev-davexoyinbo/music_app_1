import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/widgets/track_strip.dart';

class TracksTab extends StatefulWidget {
  const TracksTab({Key? key}) : super(key: key);

  @override
  _TracksTabState createState() => _TracksTabState();
}

class _TracksTabState extends State<TracksTab> {
  final MusicController musicController = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return musicController.songs.length == 0
        ? Center(child: _EmptyMessageWidget())
        : Container(
            child: Obx(() {
              return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: musicController.songs.length,
                  itemBuilder: (context, index) {
                    var song = musicController.songs[index];
                    String title = song.title;
                    String artist = song.artist;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TrackStrip(
                        isPlaying: index == 2,
                        imageFuture: musicController.getAudioImage(song),
                        name: title,
                        artist: artist,
                        timeString: index % 2 == 0 ? "02:12" : "02:48",
                      ),
                    );
                  });
            }),
          );
  }
}

class _EmptyMessageWidget extends StatelessWidget {
  const _EmptyMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_empty_outlined,
            size: 83,
            color: Colors.grey[500],
          ),
          SizedBox(height: 5),
          Text(
            "Message:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Text(
              "There is no music in your local storage.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
          )
        ],
      ),
    );
  }
}
