// ignore_for_file: camel_case_types, file_names, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linkus/screens/chatscreen%20Files/groupmemberlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Landing Files/widgets.dart';
import '../filters/mediaFilter.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import '../../controller/chatcontroller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../attachmentWidgets/chatinputbox.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:linkus/controller/chatcontroller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linkus/screens/Landing%20Files/widgets.dart';
import 'package:linkus/screens/filters/mediaFilter.dart';
import 'package:linkus/screens/filters/searchFilter.dart';
import 'package:linkus/variables/Api_Control.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../attachmentWidgets/attachmentForGroupChat.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'NewGroup.dart';

class groupChat extends StatefulWidget {
  var names;
  var images;
  var buddyId;
  final mobileNumber;
  final String? usernames;
  final GroupImages;
  final GroupNames;
  final GroupKey;
  final senderName;

  groupChat(
      {super.key,
      this.images,
      this.names,
      this.usernames,
      this.buddyId,
      this.senderName,
      this.GroupImages,
      this.mobileNumber,
      this.GroupNames,
      this.GroupKey});

  @override
  State<groupChat> createState() => _groupChatState();
}

class _groupChatState extends State<groupChat> {
  bool MicIcon = true;
  bool sndMsg = true;
  bool ImgSnd = false;
  int scrollCount = 0;
  var loginId;
  var responseStatusCode;

  late IO.Socket socket;
  GroupMsgController GroupChat = GroupMsgController();
  final ScrollController _scrollController = ScrollController();
  var chatMsg = [];
  var TimeStamp = [];
  var CryptedText;
  var CryptedImage;
  var DecryptedImage;
  var CryptedDocs;
  var EncryptedText;
  var DecryptedText;
  var groupKey;
  bool chatLoading = false;
  var key;
  var iv;
  var encrypter;
  var sentby;
  var recieverid;
  var DecryptedData;
  var replyerName;
  var rcvrnmefrmApi;
  var memberlength;
  String? memberslength;
  var groupmemblist = [];
  var formattedTime;
  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();
  scrollToDown() {
    setState(() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void initState() {
    _groupmemblist();

    LoadChatHistory();

    super.initState();

    socket = IO.io(
      'https://prod.herbie.ai:8152',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect(
      (data) {
        print("----------- Connected =----------");
      },
    );

    setUpSocketListener();
    myPlayer.openPlayer();
  }

  void setUpSocketListener() {
    socket.on('groupmessage', (data) {
      print(data);
      GroupChat.GroupMessage.add(Message.froJson(data));
    });
    socket.onPong((data) {
      print(data);
    });
    socket.onPing((data) => print(data));
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  var responseBody;

  LoadChatHistory() async {
    http.Response response =
        await http.post(Uri.parse(GroupChatHistory), body: {
      "limit": "20",
      "groupkey": widget.GroupKey.toString()
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });

    var jsonData = await jsonDecode(response.body);
    print("____________________________${jsonData.length}");

    for (var i = jsonData.length - 1; i >= 0; i--) {
      var data = jsonData[i]["message"];
      groupKey = jsonData[i]["groupkey"];
      sentby = jsonData[i]["sentby"];
      rcvrnmefrmApi = jsonData[i]["replydisplayname"];
      print(":::::::::::::::::::::::::::::::::::::::$groupKey");

      final k = encrypt.Key.fromUtf8('H4WtkvK4qyehIe2kjQfH7we1xIHFK67e');
      final iv = encrypt.IV.fromUtf8('HgNRbGHbDSz9T0CC');
      final encrypter =
          encrypt.Encrypter(encrypt.AES(k, mode: AESMode.sic, padding: null));

      LoadSendMessage(
          jsonData[i]["message"],
          int.parse(jsonData[i]["timestamp"]),
          jsonData[i]["sentby"],
          jsonData[i]["filetype"],
          jsonData[i]["replydisplayname"]);

      // scrollToUp();
      chatLoading = true;
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      scrollToDown();
    }
  }

  OnRefresh(limit) async {
    http.Response response =
        await http.post(Uri.parse(GroupChatHistory), body: {
      "limit": (limit + 10).toString(),
      "groupkey": widget.GroupKey.toString()
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });

    var jsonData = await jsonDecode(response.body);
    GroupChat.GroupMessage.clear();
    for (var i = limit; i >= 0; i--) {
      var data = jsonData[i]["message"];
      sentby = jsonData[i]["sentby"];

      var a1 = data.runtimeType;
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      final k = encrypt.Key.fromUtf8('H4WtkvK4qyehIe2kjQfH7we1xIHFK67e');
      final iv = encrypt.IV.fromUtf8('HgNRbGHbDSz9T0CC');
      final encrypter =
          encrypt.Encrypter(encrypt.AES(k, mode: AESMode.sic, padding: null));

      LoadSendMessage(
          jsonData[i]["message"],
          int.parse(jsonData[i]["timestamp"]),
          jsonData[i]["sentby"],
          jsonData[i]["filetype"],
          jsonData[i]["replydisplayname"]);

      chatLoading = true;
    }
  }

  Future _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
  }

  ConvertingTimeStamp(senttime) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(senttime * 1000);
    var format = DateFormat().add_jm();
    formattedTime = format.format(date);

    return formattedTime.toString();
  }

  LoadSendMessage(chatMsg, time, sentby, fileType, replyerName) async {
    var timeStamp = ConvertingTimeStamp(time);
    // scrollToDown();
    var messageJson = {
      "message": chatMsg.toString(),
      "sentByMe": socket.id,
      "senttime": timeStamp.toString(),
      "sndrMsgId": sentby,
      "path": '',
      "Docs": '',
      "fileType": fileType.toString(),
      "replyerName": rcvrnmefrmApi.toString()
    };

    GroupChat.GroupMessage.add(Message.froJson(messageJson));
  }

  crypto(plainText) {
    var encoded1 = base64.encode(utf8.encode(plainText));
    return encoded1;
  }

  _sendMessage(String text, String SndrMsgId) async {
    setState(() {
      sndMsg = true;
      ImgSnd = false;
    });
    String imgCurrentPath;
    for (var i = 0; i < GroupChat.GroupMessage.length; i++) {
      imgCurrentPath = GroupChat.GroupMessage[i].path;
      // rcvrnmefrmApi = GroupChat.GroupMessage[i].replyerName;

    }
    CryptedText = crypto(text);
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    var messageJson = {
      "message": CryptedText.toString(),
      "sentByMe": socket.id,
      "senttime": timeStamp.toString(),
      "sndrMsgId": widget.mobileNumber,
      "fileType": "text",
      "path": '',
      "Docs": '',
      "replyerName": widget.senderName.toString()
    };

    socket.emit('groupmessage', messageJson);

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    sendMessagetoApi();
  }

  decrypted(value) {
    var decoded = base64.decode(base64.normalize(value));
    return utf8.decode(decoded);
  }

  sendMessagetoApi() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "groupname": widget.GroupNames.toString(),
      "groupkey": widget.GroupKey.toString(),
      "message": CryptedText.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sendername": "",
      "groupimage": widget.images.toString(),
      "timestamp": time.toString(),
      "replydisplayname": widget.senderName.toString(),
      "filetype": "text",
      "experts": null,
      "tagmessage": "U2FsdGVkX19KLhaGO8tNT5QI5w8ip3iO0+Fn1PKApsk=",
      "tagfileextension": null,
      "tagtime": null,
      "Tagsend": "",
      "Date": "2022-08-25T09:58:23.153Z",
      "tagfiletype": "",
      "Taglatitude": "",
      "Taglocation": "",
      "Filedate": "",
      "status": "1",
      "Taskfrom": "",
      "Taskto": "",
      "channel": "android",
      "opengroup": "false",
      "forwardmsg": null,
      "selectedColor": "none",
      "showMore": false,
      "edited": null
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(Save_Msg_GroupChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    print("*********************************************************");
    print(
        "************************************************************************$statucode");
  }

  _OnSendMap(String latlng, String SndrMsgId) async {
    setState(() {
      sndMsg = true;
      ImgSnd = false;
    });
    String imgCurrentPath;
    for (var i = 0; i < GroupChat.GroupMessage.length; i++) {
      imgCurrentPath = GroupChat.GroupMessage[i].path;
      rcvrnmefrmApi = GroupChat.GroupMessage[i].replyerName;
    }
    CryptedText = crypto(latlng);
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);

    var messageJson = {
      "message": CryptedText.toString(),
      "sentByMe": socket.id,
      "senttime": timeStamp.toString(),
      "sndrMsgId": widget.mobileNumber.toString(),
      "fileType": "map",
      "path": '',
      "Docs": '',
      "replyerName": widget.senderName.toString()
      // "location": location!=null?true:false,
      // "latitude": location.toString(),
    };

    socket.emit('groupmessage', messageJson);
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    sendMaptoApi();
  }

  sendMaptoApi() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "groupname": widget.GroupNames.toString(),
      "groupkey": widget.GroupKey.toString(),
      "message": CryptedText.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sendername": widget.names.toString(),
      "groupimage": widget.images.toString(),
      "timestamp": time.toString(),
      "replydisplayname": widget.senderName.toString(),
      "filetype": "map",
      "experts": null,
      "tagmessage": "U2FsdGVkX19KLhaGO8tNT5QI5w8ip3iO0+Fn1PKApsk=",
      "tagfileextension": null,
      "tagtime": null,
      "Tagsend": "",
      "Date": "2022-08-25T09:58:23.153Z",
      "tagfiletype": "",
      "Taglatitude": "",
      "Taglocation": "",
      "Filedate": "",
      "status": "1",
      "Taskfrom": "",
      "Taskto": "",
      "channel": "android",
      "opengroup": "false",
      "forwardmsg": null,
      "selectedColor": "none",
      "showMore": false,
      "edited": null
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(Save_Msg_GroupChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    print("*********************************************************");
    print(
        "************************************************************************$statucode");
  }

  onImageSend(String path, String msg) async {
    chatLoading = false;
    var request = http.MultipartRequest('POST', Uri.parse(uploadImage));

    request.files.add(await http.MultipartFile.fromBytes(
        "img", File(path).readAsBytesSync(),
        filename: path.split("/").last
        // "img", path,
        ));

    // var response = await request.send();
    // request.files.add(http.MultipartFile(
    //     'image', File(path).readAsBytes().asStream(), File(path).lengthSync(),
    //     filename: path.split("/").last));
    var res = await request.send();

    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    CryptedImage = crypto(path.split("/").last);
    print("########################$CryptedImage");
    var DecryptedText12 = decrypted(CryptedImage);

    var messageJson = {
      "message": CryptedImage.toString(),
      "sentByMe": socket.id.toString(),
      "sndrMsgId": widget.mobileNumber,
      "senttime": timeStamp.toString(),
      "path": '',
      "fileType": "image",
      "Docs": '',
      "replyerName": widget.senderName.toString()
    };

    socket.emit('groupmessage', messageJson);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
    });
    sendImagetoApi();
    chatLoading = true;
  }

  sendImagetoApi() async {
    print('Sending Msg');
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "groupname": widget.GroupNames.toString(),
      "groupkey": widget.GroupKey.toString(),
      "message": CryptedImage.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sendername": widget.names.toString(),
      "groupimage": widget.images.toString(),
      "timestamp": time.toString(),
      "replydisplayname": widget.senderName.toString(),
      "filetype": "image",
      "experts": null,
      "tagmessage": "U2FsdGVkX19KLhaGO8tNT5QI5w8ip3iO0+Fn1PKApsk=",
      "tagfileextension": null,
      "tagtime": null,
      "Tagsend": "",
      "Date": "2022-08-25T09:58:23.153Z",
      "tagfiletype": "",
      "Taglatitude": "",
      "Taglocation": "",
      "Filedate": "",
      "status": "1",
      "Taskfrom": "",
      "Taskto": "",
      "channel": "android",
      "opengroup": "false",
      "forwardmsg": null,
      "selectedColor": "none",
      "showMore": false,
      "edited": null
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(Save_Msg_GroupChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    print("*********************************************************");
    print(
        "************************************************************************$statucode");
  }

  onDocsSend(String filePath, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse(uploadImage));
    request.files.add(await http.MultipartFile.fromBytes(
        'file', File(filePath).readAsBytesSync(),
        filename: filePath.split("/").last));
    var response = await request.send();
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    CryptedDocs = crypto(filePath.split("/").last);
    var messageJson = {
      "message": CryptedDocs.toString(),
      "sentByMe": socket.id.toString(),
      "sndrMsgId": widget.mobileNumber,
      "senttime": timeStamp.toString(),
      "path": '',
      "fileType": "Docs",
      "Docs": CryptedDocs.toString(),
      "replyerName": widget.senderName.toString()
    };

    socket.emit('groupmessage', messageJson);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
    });
    sendingDocstoApi();
  }

  sendingDocstoApi() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "groupname": widget.GroupNames.toString(),
      "groupkey": widget.GroupKey.toString(),
      "message": CryptedDocs.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sendername": "",
      "groupimage": widget.images.toString(),
      "timestamp": time.toString(),
      "replydisplayname": widget.senderName.toString(),
      "filetype": "Docs",
      "experts": null,
      "tagmessage": "U2FsdGVkX19KLhaGO8tNT5QI5w8ip3iO0+Fn1PKApsk=",
      "tagfileextension": null,
      "tagtime": null,
      "Tagsend": "",
      "Date": "2022-08-25T09:58:23.153Z",
      "tagfiletype": "",
      "Taglatitude": "",
      "Taglocation": "",
      "Filedate": "",
      "status": "1",
      "Taskfrom": "",
      "Taskto": "",
      "channel": "android",
      "opengroup": "false",
      "forwardmsg": null,
      "selectedColor": "none",
      "showMore": false,
      "edited": null
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(Save_Msg_GroupChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    print("*********************************************************");
    print(
        "************************************************************************$statucode");
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? file;

  _groupmemblist() async {
    http.Response response = await http.post(Uri.parse(GroupMember), body: {
      "groupkey": widget.GroupKey.toString(),
    });
    groupmemblist = json.decode(response.body);
    print("----------ABI------------${response.body}");
    groupmemblist.removeWhere((item) => item['status'] == '0');
    memberlength = groupmemblist.length;
    setState(() {});
  }

  var name = [];
  var role = [];
  var groupmemberlist = [];
  var photo = [];
  var mobile = [];
  var Loginuser;
  var owner = [];
  var admin = [];
  bool show_delete_icon = false;
  var mobileNumber;
  var senderName;
  var GroupNames = [];
  var GroupImages = [];
  var GroupCreated = [];

  var GroupKey = [];
  var GroupName_Length;
  var Data = [];
  bool exitGroupButton = false;

  LoadGroupData() async {
    print("++++++++Something++++++++");
    final prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('mobileNumber');
    senderName = prefs.getString('username');

    print('--------------->$mobileNumber');
    print('--------------->$senderName');

    http.Response response = await http.post(Uri.parse(Group_List), body: {
      'uid': "$mobileNumber",
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });

    print(response.body);
    Data = jsonDecode(response.body);
    Data.clear();
    GroupImages.clear();
    GroupNames.clear();
    GroupImages.clear();
    GroupKey.clear();
    GroupCreated.clear();

    if (Data != null || Data != []) {
      // for (var i = Data.length - 1; i >= 0; i--) {
      for (var i = 0; i < Data.length; i++) {
        GroupNames.add(Data[i]['groupname']);
        GroupImages.add(Data[i]['groupimage']);
        GroupKey.add(Data[i]['groupkey']);
        GroupCreated.add(Data[i]['groupcreated']);
      }
    }
    print('--------->${GroupNames.length}');
    print('--------->${GroupKey.length}');
    // setState(() {
    //   GroupName_Length = GroupNames.length;
    //   print('--------->$GroupName_Length');
    // });
  }
//  grpmember() async {
//     final prefs = await SharedPreferences.getInstance();
//     Loginuser = prefs.getString('mobileNumber');
//     print("----number-------$Loginuser");

//     http.Response response = await http.post(Uri.parse(GroupMember), body: {
//       "groupkey": widget.GroupKey.toString(),
//     });
//     groupmemblist.clear();
//     name.clear();
//     photo.clear();
//     mobile.clear();
//     role.clear();
//     owner.clear();

//     groupmemblist = json.decode(response.body);

//     groupmemblist.removeWhere((item) => item['status'] == '0');
//     print("-----------$groupmemblist-------");
//     groupmemblist.forEach((user) => {
//           // if(user['status'].toString() == '1') {
//           name.add(user['username'].toString()),
//           photo.add(user["photourl"].toString()),
//           role.add(user["designation"]),
//           mobile.add(user["uid"].toString()),
//            owner.add(user["owner"].toString()),
//            if (
//          (user["owner"]) == Loginuser ) {
//         print("8838748734"),
//         show_delete_icon = true,
//       }
//        else{
//            print("77777777777777"),
//         show_delete_icon=false,
//        },
//     print("!111111111111222222222$owner"),
//         });

//     setState(() {});
//   }

  grpmember() async {
    final prefs = await SharedPreferences.getInstance();
    Loginuser = prefs.getString('mobileNumber');
    print("----number-------$Loginuser");

    http.Response response = await http.post(Uri.parse(GroupMember), body: {
      "groupkey": widget.GroupKey.toString(),
    });

    groupmemberlist.clear();
    name.clear();
    role.clear();
    photo.clear();
    mobile.clear();
    owner.clear();

    groupmemberlist = json.decode(response.body);
    groupmemblist.removeWhere((item) => item['status'] == '0');

    print("555555555551111111111${groupmemblist}");

    // for (var i = 0; i < groupmemberlist.length; i++) {
    //   name.add(groupmemberlist[i]['username'].toString());
    //   photo.add(groupmemberlist[i]["photourl"].toString());
    //   role.add(groupmemberlist[i]["designation"]);
    //   mobile.add(groupmemberlist[i]["uid"].toString());
    //   owner.add(groupmemberlist[i]["owner"].toString());
    groupmemblist.forEach(
      (user) => {
        if (user['status'].toString() == '1')
          {
            name.add(user['username'].toString()),
            photo.add(user["photourl"].toString()),
            role.add(user["designation"]),
            mobile.add(user["uid"].toString()),
            owner.add(user["owner"].toString()),
            print('---------------NAME--------${name}'),
            print("555555555551111111111${user["status"]}"),
            setState(() {}),
            for (var i = 0; i < owner.length; i++)
              {
                print("=======${owner[i]},${Loginuser}"),
                if (owner[i] == Loginuser)
                  {
                    show_delete_icon = true,
                  }
              },
            for (var i = 0; i < mobile.length; i++)
              {
                print("=======${mobile[i]},${Loginuser}"),
                if (mobile[i] == Loginuser)
                  {
                    exitGroupButton = true,
                  }
              },
            print("-------abi----------${mobile}")
          }
      },
    );
  }

  exit_group() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    showDialog(
        context: context,
        builder: (bc) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
    var data = {
      "exittimestamp": time.toString(),
      "groupkey": widget.GroupKey.toString(),
      "status": "0",
      "uid": Loginuser.toString(),
    };
    print("*******=========*****$data");
    http.Response response = await http.post(Uri.parse(exitGroup), body: data);
    print("--------Exit----${response.body}");
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: Text(
                    " You have Exit from ${widget.GroupNames} Group",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        child: Text(
                          "OK",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ]);
            });
        setState(() {});
      });
    }
    ;
  }

  delete_group() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    showDialog(
        context: context,
        builder: (bc) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
    Map data = {
      "exittimestamp": timeStamp.toString(),
      "groupkey": widget.GroupKey.toString(),
      "status": "0",
      "uid": Loginuser.toString(),
    };
    print("************$data");
    http.Response response =
        await http.post(Uri.parse(delete_groupchat), body: data);
    print("--------delete----${response.body}");
    if (response.statusCode == 200) {
      http.Response response1 =
          await http.post(Uri.parse(delete_Group), body: data);
      print("--------delete----${response1.body}");
      Navigator.pop(context);
      Navigator.pop(context);

      Future.delayed(Duration(seconds: 00)).then((value) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: Text(
                    " Successfully deleted ${widget.GroupNames}",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        child: Text(
                          "OK",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () {
                          LoadGroupData();
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ]);
            });

        print("-----time-$time,${widget.GroupKey}");

        setState(() {});
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    // rcvrnmefrmApi = GroupChat.GroupMessage[i].replyerName;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
    });
    bool isTextfield = false;
    return SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
                key: _scaffoldKey,
                endDrawer: Drawer(
                  child: InkWell(
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      //  padding: EdgeInsets.zero,

                      children: [
                        Container(
                          height: 70,
                          child: DrawerHeader(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.GroupNames,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.close,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(1, 123, 255, 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        CircleAvatar(
                          radius: 40,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget.GroupImages,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.groups_rounded,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.person_add,
                            size: 25,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Add member',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewGroup(
                                  hidegroupname: widget.GroupNames,
                                  groupKey: widget.GroupKey,
                                ),
                              ),
                            );
                            _groupmemblist();
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 4,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.group_rounded,
                            size: 25,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Group members',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupMemberList(
                                          grpkey: widget.GroupKey,
                                        )));
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 4,
                        ),
                        exitGroupButton == true
                            ? ListTile(
                                leading: Icon(
                                  Icons.exit_to_app,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  'Exit Group',
                                  style: TextStyle(fontSize: 18),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            content: Text(
                                              "Do you want to exit from ${widget.GroupNames} group?",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel")),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          exit_group();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey),
                                                        child: Text("OK")),
                                                  ],
                                                ),
                                              )
                                            ]);
                                      });
                                },
                              )
                            : Container(),
                        exitGroupButton == true
                            ? Divider(
                                thickness: 1,
                                height: 4,
                              )
                            : Container(),
                        show_delete_icon == true
                            ? ListTile(
                                //subtitle: Text(show_delete_icon.toString()),
                                // ignore: unrelated_type_equality_checks
                                leading: Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.black,
                                ),

                                // ignore: unrelated_type_equality_checks
                                title: Text(
                                  'Delete group ',
                                  style: TextStyle(fontSize: 18),
                                ),

                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            content: Text(
                                              "Do you want to delete ${widget.GroupNames} group?",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel")),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          delete_group();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey),
                                                        child: Text("OK")),
                                                  ],
                                                ),
                                              )
                                            ]);
                                      });
                                },
                              )
                            : Container(),
                      ],
                    ),
                    onTap: () {
                      grpmember();
                    },
                  ),
                ),
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 25,
                      )),
                  leadingWidth: 30,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.GroupImages,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.groups_rounded,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  child: Text(widget.GroupNames,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                            ],
                          ),
                          memberlength == null
                              ? Container()
                              : Row(
                                  children: [
                                    Text("${memberlength} members",
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                        ],
                      )),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                    Theme(
                        data: Theme.of(context).copyWith(
                          dividerTheme: const DividerThemeData(
                              color: Colors.black, thickness: 0.5),
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: PopupMenuButton(
                            color: const Color.fromRGBO(1, 123, 255, 1),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: Column(
                                    children: [
                                      Mainmenu(
                                          value: 1,
                                          height: 0,
                                          text: 'Group Information',
                                          onTap: () {
                                            grpmember();
                                            Navigator.pop(context);
                                            Scaffold.of(context)
                                                .openEndDrawer();
                                            print(
                                                "----------Ramiz-----${groupmemblist.length}");
                                          },
                                          Icon: const Icon(Icons.person)),
                                      const PopupMenuDivider()
                                    ],
                                  )),
                                  PopupMenuItem(
                                      child: Column(
                                    children: [
                                      Mainmenu(
                                          value: 2,
                                          height: 0,
                                          text: 'File Filter',
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pushAndRemoveUntil<
                                                dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const FileFilter(),
                                              ),
                                              (route) => true,
                                              //if you want to disable back feature set to false
                                            );
                                          },
                                          Icon: const Icon(Icons.file_open)),
                                      const PopupMenuDivider()
                                    ],
                                  )),
                                  PopupMenuItem(
                                      child: Column(
                                    children: [
                                      Mainmenu(
                                          value: 2,
                                          height: 0,
                                          text: 'Chat Filter',
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pushAndRemoveUntil<
                                                dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        SearchFilter(),
                                              ),
                                              (route) => true,
                                              //if you want to disable back feature set to false
                                            );
                                          },
                                          Icon: const Icon(Icons.abc)),
                                      const PopupMenuDivider()
                                    ],
                                  )),
                                  PopupMenuItem(
                                      child: Column(
                                    children: [
                                      Mainmenu(
                                          value: 2,
                                          height: 0,
                                          text: 'Clear Chat',
                                          onTap: () {},
                                          Icon: const Icon(Icons.delete)),
                                      const PopupMenuDivider()
                                    ],
                                  )),
                                  PopupMenuItem(
                                      child: Column(children: [
                                    Mainmenu(
                                        value: 2,
                                        height: 0,
                                        text: 'Wall Paper',
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: WillPopScope(
                                                    onWillPop: () async =>
                                                        false,
                                                    child: AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        backgroundColor:
                                                            Colors.white,
                                                        // content: const Text(''),
                                                        actions: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 70,
                                                                    bottom: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // ElevatedButton(
                                                                //   style: ElevatedButton.styleFrom(
                                                                //       shadowColor:
                                                                //           Colors
                                                                //               .grey,
                                                                //       shape: RoundedRectangleBorder(
                                                                //           borderRadius:
                                                                //               BorderRadius.circular(12))),
                                                                //   onPressed: () {
                                                                //     _pickFile();
                                                                //   },
                                                                //   child: const Text(
                                                                //       'Gallery'),
                                                                // ),

                                                                InkWell(
                                                                  onTap: () {
                                                                    _pickFile();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    width: 80,
                                                                    height: 40,
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        'Gallery',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    width: 80,
                                                                    height: 40,
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        'Default',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                );
                                              });
                                        },
                                        Icon:
                                            const Icon(Icons.wallpaper_sharp)),
                                    const PopupMenuDivider()
                                  ]))
                                ])),
                  ],
                ),
                body: Obx(() => Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/chatBackground.jpg',
                            ),
                            fit: BoxFit.cover)),
                    child: Column(children: [
                      Expanded(
                          child: RefreshIndicator(
                        onRefresh: () {
                          var updatingScroll =
                              GroupChat.GroupMessage.length + 10;

                          return OnRefresh(updatingScroll);
                        },
                        child: ListView.builder(
                            // reverse: true,
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            dragStartBehavior: DragStartBehavior.down,
                            shrinkWrap: false,
                            itemCount: GroupChat.GroupMessage.length + 1,
                            itemBuilder: (context, index) {
                              // print(
                              //     ":::::::::::::::::::::::::::::::::::::::${GroupChat.GroupMessage[index].replyerName}");
                              // var Date_Time = ConvertingTimeStamp((int.parse(
                              //     GroupChat.GroupMessage[index].senttime)));
                              if (responseStatusCode == 200) {
                                if (index == GroupChat.GroupMessage.length) {
                                  return Container(
                                    height: 110,
                                  );
                                }
                                if (GroupChat.GroupMessage[index].fileType ==
                                        "map" ||
                                    decrypted(GroupChat
                                            .GroupMessage[index].message)
                                        .toString()
                                        .startsWith("LatLng")) {
                                  print(
                                      "######### MAP ###############################################################");
                                  if (GroupChat.GroupMessage[index].sndrMsgId ==
                                      widget.mobileNumber) {
                                    return GroupOwnLocationCard(
                                      path: decrypted(
                                        GroupChat.GroupMessage[index].path,
                                      ),
                                      time: GroupChat
                                          .GroupMessage[index].senttime,
                                    );
                                  } else if (GroupChat
                                          .GroupMessage[index].sndrMsgId !=
                                      widget.mobileNumber) {
                                    return GroupReplyLocationCard(
                                      recieverName: GroupChat
                                          .GroupMessage[index].replyerName,
                                      path: decrypted(
                                        GroupChat.GroupMessage[index].path,
                                      ),
                                      time: GroupChat
                                          .GroupMessage[index].senttime,
                                    );
                                  }
                                  return Container();
                                } else if ((GroupChat
                                        .GroupMessage[index].fileType ==
                                    "text")) {
                                  if (GroupChat.GroupMessage[index].sndrMsgId ==
                                      widget.mobileNumber) {
                                    return GroupSenderMessageItem(
                                      message: decrypted(
                                        GroupChat.GroupMessage[index].message,
                                      ),
                                      senttime: GroupChat
                                          .GroupMessage[index].senttime,
                                      sentByMe: GroupChat
                                              .GroupMessage[index].sentByMe ==
                                          socket.id,
                                      sndBy: widget.buddyId,
                                      MobileNumber:
                                          widget.mobileNumber.toString(),
                                    );
                                  } else if (GroupChat
                                          .GroupMessage[index].sndrMsgId !=
                                      widget.mobileNumber) {
                                    return GroupReciverMessageItem(
                                        recieverName: GroupChat
                                            .GroupMessage[index].replyerName,
                                        message: decrypted(
                                          GroupChat.GroupMessage[index].message,
                                        ),
                                        senttime: GroupChat
                                            .GroupMessage[index].senttime
                                            .toString(),
                                        sentByMe: GroupChat
                                                .GroupMessage[index].sentByMe ==
                                            socket.id);
                                  }
                                  return Container();
                                } else if ((GroupChat
                                        .GroupMessage[index].fileType ==
                                    "image")) {
                                  if (GroupChat.GroupMessage[index].sndrMsgId ==
                                      widget.mobileNumber) {
                                    return GroupOwnCard(
                                      path: decrypted((GroupChat
                                              .GroupMessage[index].message))
                                          .toString(),
                                      sentByMe: true,
                                      time: GroupChat
                                          .GroupMessage[index].senttime
                                          .toString(),
                                    );
                                  } else if (GroupChat
                                          .GroupMessage[index].sndrMsgId !=
                                      widget.mobileNumber) {
                                    return GroupReplyFileCard(
                                      recieverName: GroupChat
                                          .GroupMessage[index].replyerName,
                                      path: decrypted(
                                        GroupChat.GroupMessage[index].message,
                                      ).toString(),
                                      time: GroupChat
                                          .GroupMessage[index].senttime
                                          .toString(),
                                    );
                                  }
                                } else if (GroupChat
                                        .GroupMessage[index].fileType ==
                                    "Docs") {
                                  if (GroupChat.GroupMessage[index].sndrMsgId ==
                                      widget.mobileNumber) {
                                    if (decrypted(
                                            GroupChat.GroupMessage[index].path)
                                        .endsWith(".mp4")) {
                                      return GroupOwnVoiceCard(
                                        path: decrypted(
                                          GroupChat.GroupMessage[index].path,
                                        ),
                                        time: GroupChat
                                            .GroupMessage[index].senttime,
                                      );
                                    }
                                    return GroupfileViewSender(
                                        pathoffile: decrypted(GroupChat
                                            .GroupMessage[index].message
                                            .toString()),
                                        time: GroupChat
                                            .GroupMessage[index].senttime,
                                        OnDocssend: onDocsSend);
                                  } else if (GroupChat
                                          .GroupMessage[index].sndrMsgId !=
                                      widget.mobileNumber) {
                                    if (decrypted(
                                            GroupChat.GroupMessage[index].path)
                                        .endsWith(".mp4")) {
                                      return GroupReplyVoiceCard(
                                        recieverName: GroupChat
                                            .GroupMessage[index].replyerName,
                                        path: decrypted(
                                            GroupChat.GroupMessage[index].path),
                                        time: GroupChat
                                            .GroupMessage[index].senttime,
                                      );
                                    }
                                    return GroupfileViewReciever(
                                        recieverName: GroupChat
                                            .GroupMessage[index].replyerName,
                                        pathoffile: decrypted(GroupChat
                                                .GroupMessage[index].message)
                                            .toString(),
                                        time: GroupChat
                                            .GroupMessage[index].senttime,
                                        OnDocssend: onDocsSend);
                                  }
                                }
                                return Container();
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 300),
                                child: Center(
                                    child: GroupChat.GroupMessage != null
                                        ? CircularProgressIndicator()
                                        : Container(
                                            child: Text(
                                                "Your conversation goes here"),
                                          )),
                              );
                            }),
                      ))
                    ]))),
                bottomSheet: ChatInputBox(
                  buddyname: '',
                  onsent: onImageSend,
                  controller: chatController,
                  onTap: () {
                    _sendMessage(chatController.text, sentby);

                    chatController.clear();
                    setState(() {
                      chatController.text.isEmpty
                          ? MicIcon = false
                          : MicIcon = true;
                    });
                  },
                  DocumentSnd: onDocsSend,
                  onLocation: (LatLng loc) {
                    print("**** LOCATION SEND *****");
                    _OnSendMap(loc.toString(), widget.mobileNumber);
                    Navigator.pop(context);
                    setState(() {});
                  },
                ))));
  }
}
