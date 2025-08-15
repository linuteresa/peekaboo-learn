import 'package:flutter/material.dart';
import 'package:learning/models/games.dart';
import 'package:learning/screens/letter/mike.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../whiteboard/board.dart';

class LetterGamePage extends StatefulWidget {
  const LetterGamePage({super.key, required this.letter});
  final Games letter;

  @override
  State<LetterGamePage> createState() => _LetterGamePageState();
}

class _LetterGamePageState extends State<LetterGamePage> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '',
  );
  @override
  void initState() {
    String? videoId = YoutubePlayer.convertUrlToId(widget.letter.url);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: true,
          enableCaption: false,
          hideControls: false),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Writing ${widget.letter.letter}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: height * 0.26,
          width: double.infinity,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // two buttons in a row play/pause and replay
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     _controller.play();
            //   },
            //   child: const Text('Play'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     _controller.pause();
            //   },
            //   child: const Text('Pause'),
            // ),
            ElevatedButton(
              onPressed: () {
                _controller.seekTo(const Duration(seconds: 0));
              },
              child: const Text('Replay'),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        // button to naviogate DigitalInkRecognitionPage
        if (widget.letter.type != 'speak')
          DigitalInkRecognitionPage(
            macth: widget.letter.letter,
            height: height * 0.6,
            score: widget.letter.points,
            isFill: widget.letter.type == 'fill',
            controller: _controller,
          ),

        if (widget.letter.type == 'speak')
          MikeButton(
            match: widget.letter.letter,
            controller: _controller,
          )
      ]),
    );
  }
}
