// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../provider/auth_provider.dart';
import '../../provider/game_provider.dart';
import '../../util/sucees.dart';

class MikeButton extends StatefulWidget {
  const MikeButton({Key? key, required this.match, required this.controller})
      : super(key: key);

  final String match;
  final YoutubePlayerController controller;

  @override
  State<MikeButton> createState() => _MikeButtonState();
}

class _MikeButtonState extends State<MikeButton> with TickerProviderStateMixin {
  bool isSpeak = false;
  late AnimationController _animationController;
  final SpeechToText _speechToText = SpeechToText();
  bool isListening = false;
  String transcription = '';
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    check();
    _animationController.reset();
    setState(() {});
  }

  void check() async {
    try {
      if (widget.match.toLowerCase() == _lastWords.toLowerCase()) {
        _animationController.reset();
        _stopListening();

        await Provider.of<AuthProv>(context, listen: false)
            .updateScore(40, widget.match);
        Provider.of<GameProvider>(context, listen: false)
            .addCompleted(widget.match);

        showSuccess(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isSpeak = !isSpeak;
        if (!isSpeak) {
          widget.controller.play();
          _animationController.reset();
          _stopListening();
        } else {
          widget.controller.pause();
          _animationController.repeat();
          _startListening();
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 300,
              child: Lottie.asset(
                'assets/lottie/speak.json',
                animate: !isSpeak,
                controller: _animationController,
                onLoaded: (composition) {
                  _animationController.duration = composition.duration;
                },
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Text(_lastWords),
            Text(
              // If listening is active show the recognized words
              _speechToText.isListening
                  ? 'Listening...'
                  // If listening isn't active but could be tell the user
                  // how to start it, otherwise indicate that speech
                  // recognition is not yet ready or not supported on
                  // the target device
                  : _speechEnabled
                      ? 'Tap the microphone to start listening...'
                      : 'Speech not available',
            )
          ],
        ),
      ),
    );
  }
}
