// ignore_for_file: avoid_print, must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';

class ReplyVoiceCard extends StatefulWidget {
  String path;
  String time;

  ReplyVoiceCard({
    Key? key,
    required this.path,
    required this.time,
  }) : super(key: key);

  @override
  State<ReplyVoiceCard> createState() => _ReplyVoiceCardState();
}

class _ReplyVoiceCardState extends State<ReplyVoiceCard> {
  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();
  double _progress = 0.0;
  Duration? _duration;
  // ignore: prefer_typing_uninitialized_variables
  var duration;
  AudioPlayer? player;

  @override
  void initState() {
    super.initState();
    myPlayer.openPlayer();
    // flutterSoundHelper.

    player = AudioPlayer();
    duration = player
        ?.setUrl('https://prod.herbie.ai:8153/uploadFiles/${widget.path}')
        .then((value) {
      print("######################################################");
      print('-----------------yyyyyyc$value');
      // _duration =?;
      _duration = value;

      setState(() {
        _duration = value;
      });
    });
    player?.positionStream.listen((event) {
      print(event.inDays);
      int sec = _duration?.inSeconds ?? 5;
      int posSec = event.inSeconds;
      setState(() {
        _progress = posSec / sec;
        if (_progress > 0.99) {
          player?.stop();
          _progress = 0.0;
        }
      });
    }, onDone: () {
      print("++++++++++++++ DONE +++++++++++++++");
      setState(() {
        player?.pause();
      });
    });
    player?.playerStateStream.listen((event) {
      print(event);
    });
    print(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                // height: 70,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(3, 3),
                          blurRadius: 8)
                    ]),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              color: Colors.white,
                              value: _progress,
                            ),
                          ),
                          (player?.playing ?? false)
                              ? IconButton(
                                  onPressed: () {
                                    player?.pause();
                                  },
                                  icon: const Icon(
                                    Icons.pause,
                                    size: 25,
                                    color: Colors.white,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    
                                    print("------------PLAYER============");

                                    player?.play();
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 25,
                                    color: Colors.white,
                                  ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 1,
                // left: 5,
                right: 13,
                child: Center(
                  child: Text(
                    widget.time,
                    style: const TextStyle(color: Colors.white, fontSize: 10
                        // fontWeight: FontWeight.bold
                        ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                // left: 5,
                left: 18,
                child: Center(
                  child: _duration == null
                      ? Container()
                      : Text(
                          "${_duration?.inMinutes.remainder(60)}:${_duration?.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                          style:
                              const TextStyle(color: Colors.white, fontSize: 10
                                  // fontWeight: FontWeight.bold
                                  ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
