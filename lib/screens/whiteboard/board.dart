// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:learning/provider/auth_provider.dart';
import 'package:learning/provider/game_provider.dart';
import 'package:learning_digital_ink_recognition/learning_digital_ink_recognition.dart';import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/digital_ink_provider.dart';
import '../../util/loading.dart';
import '../../util/sucees.dart';
import 'painter.dart';

class DigitalInkRecognitionPage extends StatefulWidget {
  const DigitalInkRecognitionPage(
      {super.key,
      required this.macth,
      required this.height,
      this.isFill = false,
      required this.score,
      required this.controller});
  final String macth;
  final bool isFill;
  final double height;
  final int score;
  final YoutubePlayerController controller;
  @override
  // ignore: library_private_types_in_public_api
  _DigitalInkRecognitionPageState createState() =>
      _DigitalInkRecognitionPageState();
}

class _DigitalInkRecognitionPageState extends State<DigitalInkRecognitionPage> {
  final String _model = 'en-US';

  DigitalInkRecognitionState get state => Provider.of(context, listen: false);
  late DigitalInkRecognition _recognition;

  double get _width => MediaQuery.of(context).size.width;
  double _height = 0;

  @override
  void initState() {
    _recognition = DigitalInkRecognition(model: _model);
    _height = widget.height - 50;
    super.initState();
  }

  @override
  void dispose() {
    _recognition.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init();
  }

  // need to call start() at the first time before painting the ink
  Future<void> _init() async {
    //print('Writing Area: ($_width, $_height)');
    await _recognition.start(writingArea: Size(_width, _height));
    // always check the availability of model before being used for recognition
    await _checkModel();
  }

  // reset the ink recognition
  Future<void> _reset() async {
    state.reset();
    await _recognition.start(writingArea: Size(_width, _height));
  }

  Future<void> _checkModel() async {
    bool isDownloaded = await DigitalInkModelManager.isDownloaded(_model);

    if (!isDownloaded) {
      await DigitalInkModelManager.download(_model);
    }
  }

  Future<void> _actionDown(Offset point) async {
    state.startWriting(point);
    await _recognition.actionDown(point);
  }

  Future<void> _actionMove(Offset point) async {
    state.writePoint(point);
    await _recognition.actionMove(point);
  }

  Future<void> _actionUp() async {
    state.stopWriting();
    await _recognition.actionUp();
  }

  Future<void> _startRecognition() async {
    try {
      widget.controller.pause();
      showAlertDialog(context);
      if (state.isNotProcessing) {
        state.startProcessing();
        // always check the availability of model before being used for recognition
        await _checkModel();
        state.data = await _recognition.process();
        state.stopProcessing();
        if (state.isCorrect(widget.macth)) {
          // ignore: use_build_context_synchronously

          await Provider.of<AuthProv>(context, listen: false)
              .updateScore(widget.score, widget.macth);
          Provider.of<GameProvider>(context, listen: false)
              .addCompleted(widget.macth);
          Navigator.of(context).pop();
          showSuccess(context);
          // ignore: use_build_context_synchronously
        } else {
          throw "Wipe and try again !";
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height - 100,
      child: Column(
        children: [
          Builder(
            builder: (_) {
              _init();

              return GestureDetector(
                onScaleStart: (details) async =>
                    await _actionDown(details.localFocalPoint),
                onScaleUpdate: (details) async =>
                    await _actionMove(details.localFocalPoint),
                onScaleEnd: (details) async => await _actionUp(),
                child: Consumer<DigitalInkRecognitionState>(
                  builder: (_, state, __) => CustomPaint(
                    painter: DigitalInkPainter(writings: state.writings),
                    child: SizedBox(
                      width: _width,
                      height: 200,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.isFill) const Text("Write the complete word to continue"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _startRecognition,
                child: const Text('Check '),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Wipe'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Center(
            child:
                Consumer<DigitalInkRecognitionState>(builder: (_, state, __) {
              if (state.isNotProcessing && state.isNotEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      state.toCompleteString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              }

              if (state.isProcessing) {
                return Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    color: Colors.transparent,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              return Container();
            }),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
