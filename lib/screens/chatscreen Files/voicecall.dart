import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:janus_client/janus_client.dart';
import 'package:linkus/utils/settings.dart';
import 'package:permission_handler/permission_handler.dart';

// const APP_ID = "b332dd3b5b0b49ca8b0bef3e1a319174";
// const Token = "";
 ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;
class VoiceCall extends StatefulWidget {
  var buddyname;
  var buddyImage;
  final String? channelName;
  final ClientRoleType? role;
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
    // _engine = await RtcEngine.create(appid);
    await _engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(role:widget.role!);
    // _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions!=VideoDimensions(width: 1920,height: 1000);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(token: token,channelId: widget.channelName!,uid: 0,options: null!);

    // AudioEncodedFrameObserverConfig config =AudioEncodedFrameObserverConfig();
  }

  void __addAgoraEventHandlers(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("End to End Encryption"), leading: Icon(Icons.lock)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
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
          ),
          Text(
            widget.buddyname,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          const Text(
            "Calling....",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          InkWell(
            onTap: () {
              leave();
              Navigator.pop(context);
            },
            child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                //child: Colors.red,
                child: Icon(
                  Icons.phone,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }

  
}
