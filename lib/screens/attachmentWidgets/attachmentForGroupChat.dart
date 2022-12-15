// ignore_for_file: avoid_print, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupOwnCard extends StatefulWidget {
  const GroupOwnCard({
    super.key,
    required this.path,
    required this.sentByMe,
    required this.time,
  });
  final String path;
  final bool sentByMe;
  final String time;

  @override
  State<GroupOwnCard> createState() => _GroupOwnCardState();
}

class _GroupOwnCardState extends State<GroupOwnCard> {
  @override
  Widget build(BuildContext context) {
    print("ddddd-----------${widget.path}");
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 1.5,
              width: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 15, top: 3, left: 3, right: 3),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.height / 4,
                  child: Card(
                      child: Image.network(
                    'https://prod.herbie.ai:8153/uploadFiles/${widget.path}',
                    loadingBuilder: (BuildContext context,
                        Widget child,
                        //ss
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                          child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null));
                    },
                    fit: BoxFit.fitWidth,
                  )),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              // left: 5,
              right: 2,
              child: Container(
                width: 65,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupReplyFileCard extends StatefulWidget {
  const GroupReplyFileCard(
      {super.key, required this.recieverName, this.path, required this.time});
  final String? path;
  final String time;
  final recieverName;
  @override
  State<GroupReplyFileCard> createState() => _GroupReplyFileCardState();
}

class _GroupReplyFileCardState extends State<GroupReplyFileCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Stack(
          children: [
            // Padding(
            //           padding:
            //               EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //           child: Align(
            //               alignment: Alignment.topLeft,
            //               child: Text(
            //                 widget.recieverName.toString(),
            //                 style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.w800),
            //               )),
            //         ),
            Container(
              height: MediaQuery.of(context).size.width / 1.5,
              width: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.green),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      widget.recieverName.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, top: 3, left: 3, right: 3),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.height / 4,
                      child: Card(
                          child: Image.network(
                        'https://prod.herbie.ai:8153/uploadFiles/${widget.path}',
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                              child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null));
                        },
                        fit: BoxFit.fitWidth,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 4,
              // left: 5,
              right: 6,
              child: Container(
                width: 65,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupSenderMessageItem extends StatefulWidget {
  const GroupSenderMessageItem(
      {super.key,
      required this.sentByMe,
      required this.message,
      this.path,
      required this.senttime,
      required this.sndBy,
      required this.MobileNumber});
  final bool sentByMe;
  final String message;
  final String senttime;
  final String? path;
  final String? sndBy;
  final MobileNumber;

  @override
  State<GroupSenderMessageItem> createState() => _GroupSenderMessageItemState();
}

class _GroupSenderMessageItemState extends State<GroupSenderMessageItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100, right: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 0, top: 5, left: 10, right: 5),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: (Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "${widget.message.toString()}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 3,
                      // right: 5,
                    ),
                    child: Text(
                      "${widget.senttime}",
                      style: TextStyle(
                          fontSize: 10,
                          color: (widget.sentByMe ? Colors.white : Colors.white)
                              .withOpacity(0.7)),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

class GroupReciverMessageItem extends StatefulWidget {
  const GroupReciverMessageItem(
      {required this.sentByMe,
      required this.message,
      required this.recieverName,
      this.path,
      required this.senttime})
      : super();
  final bool sentByMe;
  final recieverName;
  final String message;
  final String senttime;
  final String? path;

  @override
  State<GroupReciverMessageItem> createState() =>
      _GroupRecieverMessageItemState();
}

class _GroupRecieverMessageItemState extends State<GroupReciverMessageItem> {
  @override
  Widget build(BuildContext context) {
    final key = encrypt.Key.fromUtf8('d6F3Efeq................');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final EncryptedText = encrypter.encrypt(widget.message, iv: iv);
    final decryptedText = encrypter.decrypt(EncryptedText, iv: iv);

    return Padding(
      padding: const EdgeInsets.only(right: 100, left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 0, top: 5, left: 10, right: 5),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recieverName.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "${decryptedText.toString()}",
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                widget.sentByMe ? Colors.white : Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 3,
                          // right: 5,
                        ),
                        child: Text(
                          "${widget.senttime}",
                          style: TextStyle(
                              fontSize: 10,
                              color: (widget.sentByMe
                                      ? Colors.white
                                      : Colors.white)
                                  .withOpacity(0.7)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  LatLng? currentLatLng;
  final Completer<GoogleMapController> _controller = Completer();

  Future<void> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: GoogleMap(
          onTap: (argument) {
            print("++++++++++++ ON TAP +++++++++++++");
            print(argument);
          },
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
              target: LatLng(8.196207, 77.149917), zoom: 1),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: <Marker>{
            if (currentLatLng != null)
              Marker(
                draggable: true,
                markerId: const MarkerId("1"),
                position: currentLatLng!,
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: const InfoWindow(
                  title: 'My Location',
                ),
              )
          },
        ),
        floatingActionButton: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                  child: Center(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text('Current Location',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )),
            ],
          ),
          onTap: () {
            _goToCurrentLocation();

            Navigator.pop(context, currentLatLng);
          },
        ));
  }

  Future<void> _goToCurrentLocation() async {
    await _determinePosition();
    final GoogleMapController controller = await _controller.future;
    if (currentLatLng != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng!, zoom: 16)));
    }
  }
}

class GroupOwnLocationCard extends StatefulWidget {
  const GroupOwnLocationCard(
      {super.key, required this.path, required this.time});
  final String path;
  final String time;

  @override
  State<GroupOwnLocationCard> createState() => _GroupOwnLocationCardState();
}

class _GroupOwnLocationCardState extends State<GroupOwnLocationCard> {
  @override
  Widget build(BuildContext context) {
    String a = widget.path.replaceAll("LatLng(", "");
    a = a.replaceAll(")", "");
    LatLng? loc =
        LatLng(double.parse(a.split(",")[0]), double.parse(a.split(",")[1]));
    return Stack(children: [
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            height: MediaQuery.of(context).size.width / 1.5,
            width: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 15, top: 3, left: 3, right: 3),
              child: Card(
                child: GoogleMap(
                  markers: <Marker>{
                    Marker(
                      draggable: true,
                      markerId: const MarkerId("1"),
                      position: loc,
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: const InfoWindow(
                        title: 'My Location',
                      ),
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    target: loc,
                    zoom: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 4,
        // left: 5,
        right: 17,
        child: Container(
          width: 65,
          color: Colors.transparent,
          child: Center(
            child: Text(
              widget.time,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ]);

    //   child: Container(
    //     height: 150,
    //     width: 300,
    //     color: Colors.blue,
    //     child: GoogleMap(
    //       markers: <Marker>{
    //         Marker(
    //           draggable: true,
    //           markerId: const MarkerId("1"),
    //           position: loc,
    //           icon: BitmapDescriptor.defaultMarker,
    //           infoWindow: const InfoWindow(
    //             title: 'My Location',
    //           ),
    //         )
    //       },
    //       initialCameraPosition: CameraPosition(
    //         target: loc,
    //         zoom: 16,
    //       ),
    //     ),
    //   ),
    // ),
  }
}

class GroupReplyLocationCard extends StatefulWidget {
  const GroupReplyLocationCard(
      {super.key,
      required this.path,
      required this.time,
      required this.recieverName});
  final String path;
  final String time;
  final recieverName;

  @override
  State<GroupReplyLocationCard> createState() => _GroupReplyLocationCardState();
}

class _GroupReplyLocationCardState extends State<GroupReplyLocationCard> {
  @override
  Widget build(BuildContext context) {
    String a = widget.path.replaceAll("LatLng(", "");
    a = a.replaceAll(")", "");
    LatLng? loc =
        LatLng(double.parse(a.split(",")[0]), double.parse(a.split(",")[1]));
    return Stack(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            height: MediaQuery.of(context).size.width / 1.5,
            width: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 15, top: 3, left: 3, right: 3),
              child: Card(
                child: GoogleMap(
                  markers: <Marker>{
                    Marker(
                      draggable: true,
                      markerId: const MarkerId("1"),
                      position: loc,
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: const InfoWindow(
                        title: 'My Location',
                      ),
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    target: loc,
                    zoom: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 4,
        left: 150,
        child: Container(
          width: 65,
          color: Colors.transparent,
          child: Center(
            child: Text(
              widget.time,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

class GroupReplyVoiceCard extends StatefulWidget {
  String path;
  String time;
  final recieverName;
  GroupReplyVoiceCard(
      {Key? key,
      required this.path,
      required this.time,
      required this.recieverName})
      : super(key: key);

  @override
  State<GroupReplyVoiceCard> createState() => _GroupReplyVoiceCardState();
}

class _GroupReplyVoiceCardState extends State<GroupReplyVoiceCard> {
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

class GroupOwnVoiceCard extends StatefulWidget {
  String path;
  String time;

  GroupOwnVoiceCard({
    required this.path,
    required this.time,
  });

  @override
  State<GroupOwnVoiceCard> createState() => _GroupOwnVoiceCardState();
}

class _GroupOwnVoiceCardState extends State<GroupOwnVoiceCard> {
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

// ignore_for_file: camel_case_types, non_constant_identifier_names, file_names

class GroupfileViewSender extends StatefulWidget {
  final String pathoffile;
  final String time;
  final Function OnDocssend;
  const GroupfileViewSender(
      {super.key,
      required this.pathoffile,
      required this.OnDocssend,
      required this.time});

  @override
  State<GroupfileViewSender> createState() => _GroupfileViewSenderState();
}

class _GroupfileViewSenderState extends State<GroupfileViewSender> {
  openFie() {
    // print('pathoffile--pathoffile--$pathoffile');
    return Expanded(
      child: Text(
        widget.pathoffile,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

//  Future<void> _launchInWebViewOrVC(Uri url) async {
  @override
  Widget build(BuildContext context) {
    openFie();
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
          onTap: () {
            _launchInBrowser(Uri.parse(
              'https://prod.herbie.ai:8153/uploadFiles/${widget.pathoffile}',
            ));
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 60,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(children: [
                      const Icon(Icons.file_copy),
                      const SizedBox(
                        width: 10,
                      ),
                      openFie(),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          widget.pathoffile.split(".").last.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        widget.time,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class GroupfileViewReciever extends StatefulWidget {
  final String pathoffile;
  final String time;
  final Function OnDocssend;
  final recieverName;

  const GroupfileViewReciever({
    super.key,
    required this.pathoffile,
    required this.OnDocssend,
    required this.recieverName,
    required this.time,
  });

  @override
  State<GroupfileViewReciever> createState() => _GroupfileViewRecieverState();
}

class _GroupfileViewRecieverState extends State<GroupfileViewReciever> {
  openFie() {
    // print('pathoffile--pathoffile--$pathoffile');
    return Expanded(
      child: Text(
        widget.pathoffile,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

//  Future<void> _launchInWebViewOrVC(Uri url) async {
  @override
  Widget build(BuildContext context) {
    openFie();
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
          onTap: () {
            _launchInBrowser(Uri.parse(
              'https://prod.herbie.ai:8153/uploadFiles/${widget.pathoffile}',
            ));
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green),
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 60,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(children: [
                      const Icon(Icons.file_copy),
                      const SizedBox(
                        width: 10,
                      ),
                      openFie(),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          widget.pathoffile.split(".").last.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        widget.time,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
