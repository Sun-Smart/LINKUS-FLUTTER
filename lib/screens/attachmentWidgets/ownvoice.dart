// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';

class OwnVoiceCard extends StatefulWidget {
  String path;
  String time;

  OwnVoiceCard({
    required this.path,
    required this.time,
  });

  @override
  State<OwnVoiceCard> createState() => _OwnVoiceCardState();
}

class _OwnVoiceCardState extends State<OwnVoiceCard> {
  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();
  // ignore: prefer_typing_uninitialized_variables

  double _progress = 0.0;
  Duration? _duration;
  // ignore: prefer_typing_uninitialized_variables
  var duration;
  AudioPlayer? player;

  @override
  void initState() {
    super.initState();  
  }
 initialize() {
    myPlayer.openPlayer();
    myPlayer.closePlayer();
    
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
      alignment: Alignment.centerRight,
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
                                    // myPlayer
                                    //     .startPlayer(
                                    //         fromURI:
                                    //             'https://prod.herbie.ai:8153/uploadFiles/${widget.path}')
                                    //     .then((value) {
                                    //   print("then");
                                    //   print(value);
                                    // });

                                    // myPlayer.setSubscriptionDuration(
                                    //     const Duration(milliseconds: 300));
                                    // myPlayer.onProgress?.listen((event) {
                                    //   int sec = event.duration.inSeconds;
                                    //   int posSec = event.position.inSeconds;
                                    //   setState(() {
                                    //     _progress = posSec / sec;
                                    //   });
                                    // });
                                 print("------------PLAYER============");
                                    initialize();
                                   
                                    player?.play();
                                    ProcessingState.ready;
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
                bottom: 2,
                // left: 5,
                right: 11,
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
