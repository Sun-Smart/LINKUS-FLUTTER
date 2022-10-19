import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:janus_client/janus_client.dart';

class VoiceCall extends StatefulWidget {
 var buddyname;
  var  buddyImage;
   VoiceCall({super.key, required this. buddyImage,required this.buddyname});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("End to End Encryption"),
       leading: Icon(Icons.lock)
        
      ),
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
             Text(widget.buddyname,
             style: TextStyle(fontSize: 15),),


            SizedBox(height: MediaQuery.of(context).size.height/5,),
           const Text("Calling....",
           style: TextStyle(fontSize: 15),),
             SizedBox(height: MediaQuery.of(context).size.height/3,),

             InkWell(
              onTap:(){
              leave();
              Navigator.pop(context);} ,
               child:const  CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                //child: Colors.red,
                child: Icon(Icons.phone,color: Colors.white,)),
             )
            
                   
        ],
      ),
    );
  }
}


