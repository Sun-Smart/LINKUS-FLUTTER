import 'dart:convert';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:janus_client/janus_client.dart';
import 'package:linkus/utils/settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart'as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart'as rtc_remote_view;

// const APP_ID = "b332dd3b5b0b49ca8b0bef3e1a319174";
// const Token = "";
 ClientRole _role = ClientRole.Broadcaster;
class VoiceCall extends StatefulWidget {
  var buddyname;
  var buddyImage;
  final String? channelName;
  final ClientRole? role;
  VoiceCall({super.key, required this.buddyImage, required this.buddyname,this.channelName,this.role});

  @override
  State<VoiceCall> createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  JanusAudioBridgePlugin? pluginHandle;
  JanusSession? session;
  Map<String?, AudioBridgeParticipants?> participants = {};

  leave() async {
    setState(() {
      participants.clear();
    });
    await pluginHandle?.hangup();
    pluginHandle?.dispose();
    session?.dispose();
  }

  // final _channelController = TextEditingController();
  // bool _validateError = false;
  // ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;

  // // ClientRole _role = ClientRole.Broadcaster;
  // @override
  // void dispose() {
  //   _channelController.dispose();
  //   super.dispose();
  // }

  final _users = <int>[];
  final _infoStrings =<String>[];
  bool muted = false;
  late RtcEngine _engine;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    
    super.dispose();
  }

  Future<void>initialize()async{
    if(appid.isEmpty){
      setState(() {
        _infoStrings.add("appid missing");
        _infoStrings.add("agora engine is not starting");
      });
      return;
      
   
    }
    //initagoraengine
    _engine = await RtcEngine.create(appid);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role!);
    //  _engine = createAgoraRtcEngine();
    // await _engine.initialize(const RtcEngineContext(
    //     appId: appid
    // ));
    // await _engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    // await _engine.setClientRole(role:widget.role!);
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions!=VideoDimensions(width: 1920,height: 1000);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(token, widget.channelName!, null, 0);
    // await _engine.joinChannel(token: token,channelId: widget.channelName!,uid: 0,options: null!);

    // AudioEncodedFrameObserverConfig config =AudioEncodedFrameObserverConfig();
  

  }

void _addAgoraEventHandlers(){
    _engine.setEventHandler(
      RtcEngineEventHandler(
      //   onError: (type,data) {
      //   setState(() {
      //     final info = 'Error: ${type.name}';
      //     _infoStrings.add(info);
      //   });
      // },
      error: (err) {
        setState(() {
          final info = 'Error: $err';
          _infoStrings.add(info);
        });
      },
      //   onError: (Code){
      //   setState(() {
      //     final info = 'Error'$'code';
      //     _infoStrings.add(info);
      //   });
      // },
      joinChannelSuccess: (channel, uid, elapsed) {
        final info = 'Join Channel: $channel,uid:$uid';
        _infoStrings.add(info);
      },
      //  onJoinChannelSuccess: (connection,elapsed) {
      //   final info = 'Join Channel: ${connection.channelId}, uid: ${connection.localUid}';
      //   setState(() {
      //     _infoStrings.add(info);
      //   });
      // },
      // onJoinChannelSuccess: (channel,uid,elapsed){
      //   setState(() {
      //     final info = 'Join channel: $channel,uid:$uid';
      //   });
      // },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('leave channel');
          _users.clear();
        });
      },
      // onLeaveChannel: (connection, stats) {
      //   setState(() {
      //     _infoStrings.add('Leave Channel');
      //     _users.clear();
      //   });
      // },

userJoined: (uid, elapsed) {
setState(() {
    final info = 'User Joined: $uid';
  _infoStrings.add(info);
  _users.add(uid);
});
},

      
      // onLeaveChannel: (stats){
      //   setState(() {
      //     _infoStrings.add('Leave Channel');
      //     _users.clear();
      //   });
      // },
      // onUserJoined: (connection, remoteUid, elapsed) {
      //   setState(() {
      //     final info ='User Joined:$remoteUid';
      //     _infoStrings.add(info);
      //     _users.add(remoteUid);
      //   });
      // },

      userOffline: (uid, reason) {
        setState(() {
          final info = 'User Offline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteAudioFrame: (uid, elapsed) {
        setState(() {
          final info = 'First Remote video:$uid';
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'First Remote video:$uid ${width}x ${height}';
        });
    }));

// onUserOffline: (connection, remoteUid, reason) {
//         setState(() {
//           final info = 'User Offline:$remoteUid';
//           _infoStrings.add(info);
//           _users.remove(remoteUid);
//         },
        
//         );},
  

        // onFirstRemoteVideoFrame:(connection, remoteUid, width, height, elapsed) {
        //   setState(() {
        //     final info = 'First Remote video:$remoteUid ${width}x${height}';
        //     _infoStrings.add(info);
        //   });
        // })
        // );
      
  
  }
  Widget _viewrows(){
    final List<StatefulWidget> list =[];
    if(widget.role==ClientRole.Broadcaster){
      list.add(rtc_local_view.SurfaceView());
    }
    for(var uid in _users){
      list.add(rtc_remote_view.SurfaceView(
        uid:uid,
        channelId: widget.channelName!,
      ));
    }
    final views = list;
    return Column(
      children: List.generate(views.length, (index) => Expanded(child: views[index])),
    );
  }
  Widget _toolbar(){
    if(widget.role==ClientRole.Audience)
    return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
      child: Row(
        children: [
          RawMaterialButton(onPressed: (){
            setState(() {
              muted = !muted;
            });
            _engine.muteAllRemoteAudioStreams(muted);
          },
          child: Icon(muted?Icons.mic_off:Icons.mic,
          color: muted?Colors.white:Colors.blueAccent,
          size: 20,
          ),
          shape: const CircleBorder(),
          elevation: 20,fillColor: muted?Colors.blueAccent:Colors.white,
          padding: EdgeInsets.all(12),
          ),

          RawMaterialButton(onPressed: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.call_end,
          color: Colors.white,
          size: 20,
          ),
          shape: const CircleBorder(),
          elevation: 20,fillColor: Colors.red,
          padding: EdgeInsets.all(12),
          ),
          RawMaterialButton(onPressed: (){
            _engine.switchCamera();
          },
          child: Icon(Icons.switch_camera,
          color: Colors.blueAccent,size: 20,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: EdgeInsets.all(20),
          )
        ],
      ),
    );
  }
  Widget _panel(){
    return Visibility(
      // visible: viewpanel,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, index) {
              if(_infoStrings.isEmpty){
                return Text("null");
              }
              return Padding(padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: 
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2,horizontal: 5
                    ),decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      
                    ),
                    child: Text(_infoStrings[index],
                    style: TextStyle(
                      color: Colors.blueGrey
                    ),
                    ),

                  )
                  )
                ],
              ),
              );
            }),
            ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("End to End Encryption"), leading: Icon(Icons.lock)),
      body: Column(
        children: [
       
          Center(
            child: CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.buddyImage ?? "",
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) =>
                          CircularProgressIndicator(
                              value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.buddyname,
            style: TextStyle(fontSize: 15),
          ),
          Center(
            child: const Text(
              "Calling....",
              style: TextStyle(fontSize: 15),
            ),
          ),
      
             SizedBox(
              height: 100,
            child: _viewrows()),
          SizedBox(
            height: 100,
            child: _panel()),
          SizedBox(
            height: 100,
            child: _toolbar()),
          // InkWell(
          //   onTap: () {
          //     leave();
          //     Navigator.pop(context);
          //   },
          //   child: const CircleAvatar(
          //       radius: 30,
          //       backgroundColor: Colors.red,
          //       //child: Colors.red,
          //       child: Icon(
          //         Icons.phone,
          //         color: Colors.white,
          //       )),
          // )
        ],
      ),
    );
  }

  
}
