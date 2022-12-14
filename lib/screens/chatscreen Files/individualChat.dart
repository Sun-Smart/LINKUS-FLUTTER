//ignore_for_file: non_constant_identifier_names,
//prefer_typing_uninitialized_variables, unnecessary_string_interpolations, prefer_const_constructors, file_names, use_key_in_widget_constructors, avoid_print, await_only_futures, unused_local_variable, library_prefixes, deprecated_member_use, must_be_immutable, sized_box_for_whitespace

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:linkus/controller/chatcontroller.dart';
import 'package:linkus/screens/Landing%20Files/widgets.dart';

import 'package:linkus/screens/attachmentWidgets/attachmentForIndividualChat.dart';
import 'package:linkus/screens/chatscreen%20Files/voicecall.dart';

import 'package:linkus/screens/filters/mediaFilter.dart';
import 'package:linkus/screens/filters/searchFilter.dart';
import 'package:linkus/variables/Api_Control.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../attachmentWidgets/chatinputbox.dart';
import '../attachmentWidgets/location.dart';
import '../attachmentWidgets/ownvoice.dart';
import '../attachmentWidgets/replyvoice.dart';
import '../attachmentWidgets/sendermsg.dart';

import 'package:http/http.dart' as http;
import 'dart:io';

import 'fileView.dart';

ScrollController scrollController = ScrollController();

class PersonalChat extends StatefulWidget {
  var names;
  var images;
  var buddyId;
  var status;
  String? time;
  final mobileNumber;

  final String? loggedInName;
  final VoidCallback callback;

  PersonalChat(
      {super.key,
      required this.callback,
      this.time,
      this.loggedInName,
      this.images,
      this.names,
      this.status,
      this.buddyId,
      this.mobileNumber});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  bool MicIcon = true;
  bool sndMsg = true;
  bool ImgSnd = false;
  int scrollCount = 0;
  var loginId;
  var responseStatusCode;

  late IO.Socket socket;
  msgController chat = msgController();
  var chatMsg = [];
  var userLogged;
  var TimeStamp_date;
  var CryptedText;
  var CryptedImage;
  var DecryptedImage;
  var CryptedDocs;
  var EncryptedText;
  var DecryptedText;
  var messageIdfromApi;
  bool chatLoading = false;
  var key;
  var iv;
  var encrypter;
  var senderid;
  var recieverid;
  var DecryptedData;
  var buddy_profileinfo;
  bool? MsgSeen;
  var lastseen;
  var userprofile;
  var unread_result = [];
  var jsonData = [];
  var Data;
  bool? load_data;

  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();
  scrollToDown() {
    setState(() {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      }
    });
  }

  bool _isSearching = false;
  loadDatafrmStrge() async {
    final prefs = await SharedPreferences.getInstance();
    userLogged = prefs.getString('username');
    userprofile = prefs.getString('profilepic');
    return userLogged;
  }

  @override
  void initState() {
    print("----usernames--------${widget.names}");
    senderid = "${widget.mobileNumber}_${widget.buddyId}";
    recieverid = "${widget.buddyId}_${widget.mobileNumber}";

    loadDatafrmStrge();

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
        MsgSeen = true;
      },
    );

    setUpSocketListener();
    myPlayer.openPlayer();
  }

  void setUpSocketListener() {
    socket.on('chatmessage', (data) {
      print(data);
      chat.chatMessages.add(Message.froJson(data));
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

  LoadChatHistory() async {
    print(
        'Going----------------------------------- Gud${widget.buddyId}_${widget.mobileNumber}');
    print(
        'Going----------------------------------- Gud${widget.mobileNumber}_${widget.buddyId}');

    http.Response response = await http.post(Uri.parse(chat_history), body: {
      "limit": "10",
      "message_id": senderid,
      "message_id1": recieverid
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });
    responseStatusCode = response.statusCode;
    print("weeeeeeeeeeeeeeeeeeeeeeeee${load_data}");
    Data = response.body;
    print("-----------$Data");
    if (Data != 'no data found') {
      jsonData = await json.decode(Data.toString());
    }
    //response.body.toString();

    print("-----jsondata------$jsonData----------");

    if (Data.length > 0) {
      // setState(() {

      //   load_data = false;
      // });
      if (Data != 'no data found') {
        print("------------print--------");
        for (var i = jsonData.length - 1; i >= 0; i--) {
          var data = jsonData[i]["message"];
          TimeStamp_date = jsonData[i]["timestamp"];
          var date = ConvertingTimeStamp1(TimeStamp_date);
          messageIdfromApi = jsonData[i]["message_id"];
          var a1 = data.runtimeType;

          final k = encrypt.Key.fromUtf8('H4WtkvK4qyehIe2kjQfH7we1xIHFK67e');
          final iv = encrypt.IV.fromUtf8('HgNRbGHbDSz9T0CC');
          final encrypter = encrypt.Encrypter(
              encrypt.AES(k, mode: AESMode.sic, padding: null));

          LoadSendMessage(
              jsonData[i]["message"],
              int.parse(jsonData[i]["timestamp"]),
              messageIdfromApi,
              jsonData[i]["filetype"]);

          // scrollToUp();
          chatLoading = true;
          // scrollController.animateTo(scrollController.position.maxScrollExtent,
          //     duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
          scrollToDown();
        }
      } else {
        print("-------no data found---");
        Data = "no data found";
      }
    } else {
      // jsonData = response.body;
      print("checking---------$jsonData");
    }
    print("checkingasasasas---------$Data");
    print("true or flse----------${load_data}");
  }

  OnRefresh(limit) async {
    http.Response response = await http.post(Uri.parse(chat_history), body: {
      "limit": (limit + 10).toString(),
      "message_id": senderid,
      "message_id1": recieverid
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });

    var jsonData = await jsonDecode(response.body);
    chat.chatMessages.clear();
    for (var i = limit; i >= 0; i--) {
      var data = jsonData[i]["message"];
      messageIdfromApi = jsonData[i]["message_id"];
      var a1 = data.runtimeType;
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      final k = encrypt.Key.fromUtf8('H4WtkvK4qyehIe2kjQfH7we1xIHFK67e');
      final iv = encrypt.IV.fromUtf8('HgNRbGHbDSz9T0CC');
      final encrypter =
          encrypt.Encrypter(encrypt.AES(k, mode: AESMode.sic, padding: null));

      LoadSendMessage(
          jsonData[i]["message"],
          int.parse(jsonData[i]["timestamp"]),
          messageIdfromApi,
          jsonData[i]["filetype"]);

      chatLoading = true;
    }
  }

  LoadSendMessage(
    chatMsg,
    time,
    sndrMsgId,
    fileType,
  ) async {
    var timeStamp = ConvertingTimeStamp(time);
    // scrollToDown();
    var messageJson = {
      "message": chatMsg.toString(),
      "sentByMe": socket.id,
      "senttime": timeStamp.toString(),
      "sndrMsgId": sndrMsgId,
      "path": '',
      "Docs": '',
      "fileType": fileType.toString()
    };

    chat.chatMessages.add(Message.froJson(messageJson));
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
    for (var i = 0; i < chat.chatMessages.length; i++) {
      imgCurrentPath = chat.chatMessages[i].path;
    }
    CryptedText = crypto(text);
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    var messageJson = {
      "message": CryptedText.toString(),
      "sentByMe": socket.id,
      "senttime": timeStamp.toString(),
      "sndrMsgId": SndrMsgId,
      "fileType": "text",
      "path": '',
      "Docs": ''
    };

    socket.emit('chatmessage', messageJson);
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

    sendMessagetoApi();
  }

  decrypted(value) {
    print("-----value-------$value");
    var decoded = base64.decode(base64.normalize(value));
    print("------rrrrrrr----$decoded");

    return utf8.decode(decoded);
  }

  sendMessagetoApi() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "buddyid": widget.buddyId.toString(),
      "message": CryptedText.toString(),
      "sentby": widget.mobileNumber.toString(),
      "username": widget.names ?? "".toString(),
      "buddyImage": widget.images ?? "".toString(),
      "message_id": senderid,
      "timestamp": time.toString(),
      "deviceid": "0",
      "sentto": widget.buddyId ?? "".toString(),
      "location": false,
      "latitude": "undefined,undefined",
      "status": "1",
      "filetype": "text",
      "fileextension": "",
      "tagmessage": null,
      "Taskfrom": "",
      "Taskto": "",
      "chatType": "1",
      "forwardmsg": null,
      "channel": "android",
      "showMore": false,
      "attachtext": "",
      "selfdestruct": false,
      "favourite": null,
      "edited": null
    };

    print("-----testing-----------${data}");

    String body = json.encode(data);

    print(
        "---------ramiz-----------$body,,,,,,,,,,,,${widget.buddyId},,,,,,${widget.names}");
    http.Response response = await http.post(Uri.parse(Save_Msg_PersonalChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});

    var statucode = response.statusCode;

    SendMessagetoRecent();
  }

// senderid
  SendMessagetoRecent() async {
    print("recent--------------- ${widget.names}---------${userLogged}");
    final prefs = await SharedPreferences.getInstance();
    userLogged = prefs.getString('username');
    userprofile = prefs.getString('profilepic');
    var time = DateTime.now().millisecondsSinceEpoch;
    var data = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.mobileNumber.toString(),
      "buddyid": widget.buddyId.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sentto": widget.buddyId.toString(),
      "message_id": senderid,
      "buddyImage": widget.images ?? "".toString(),
      "username": widget.names ?? "".toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedText.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };
    var data1 = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.buddyId.toString(),
      "buddyid": widget.mobileNumber.toString(),
      "sentby": widget.buddyId.toString(),
      "sentto": widget.mobileNumber.toString(),
      "message_id": recieverid,
      "buddyImage": userprofile ?? "".toString(),
      "username": userLogged ?? "".toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedText.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };

    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$data");
    String body = json.encode(data);
    String body1 = json.encode(data1);
    http.Response response = await http.post(Uri.parse(RecentMsg),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    http.Response responses = await http.post(Uri.parse(RecentMsg),
        body: body1,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$statucode");
    print("_+_+_+_+_+_+_+_+_+_+_+_+_+${response.body}");
  }

  _OnSendMap(String latlng, String SndrMsgId) async {
    setState(() {
      sndMsg = true;
      ImgSnd = false;
    });
    String imgCurrentPath;
    for (var i = 0; i < chat.chatMessages.length; i++) {
      imgCurrentPath = chat.chatMessages[i].path;
    }
    CryptedText = crypto(latlng);
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    var messageJson = {
      "message": CryptedText.toString(),
      "sentByMe": socket.id,
      "senttime": timeStamp.toString(),
      "sndrMsgId": SndrMsgId,
      "fileType": "map",
      "path": '',
      "Docs": '',
      // "location": location!=null?true:false,
      // "latitude": location.toString(),
    };

    socket.emit('chatmessage', messageJson);
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    sendMaptoApi();
    SendMaptoRecent();
  }

  sendMaptoApi() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "buddyid": widget.buddyId.toString(),
      "message": CryptedText.toString(),
      "sentby": widget.mobileNumber.toString(),
      "username": widget.names ?? "".toString(),
      "buddyImage": widget.images ?? "".toString(),
      "message_id": senderid,
      "timestamp": time.toString(),
      "deviceid": "0",
      "sentto": widget.buddyId.toString(),
      "location": true,
      "latitude": "undefined,undefined",
      "status": "1",
      "filetype": "map",
      "fileextension": "",
      "tagmessage": null,
      "Taskfrom": "",
      "Taskto": "",
      "chatType": "1",
      "forwardmsg": null,
      "channel": "android",
      "showMore": false,
      "attachtext": "",
      "selfdestruct": false,
      "favourite": null,
      "edited": null
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(Save_Msg_PersonalChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
  }

  var buddy_employee;
  var buddy_mobile;
  var buddy_designation;
  var buddy_department;
  var buddy_gender;
  var buddy_email;
  var buddy_image;
  buddy_profile() async {
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
    print("----testing---");

    Map data = {
      "mobile": widget.buddyId.toString(),
    };
    print(data);
    String body = json.encode(data);
    print(body);

    var response = await http.post(
      Uri.parse(MyProfile_Api),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    );
    print("result:==========${response.body}");
    if (response.statusCode == 200) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pop(context);
        buddy_profileinfo = json.decode(response.body);
        // buddy_profileinfo=buddy_profileinfo[0];
        buddy_employee = buddy_profileinfo[0]['employee'];
        buddy_mobile = buddy_profileinfo[0]['mobile'];
        buddy_gender = buddy_profileinfo[0]['gender'];
        buddy_designation = buddy_profileinfo[0]['designation'];
        buddy_department = buddy_profileinfo[0]['department'];
        buddy_email = buddy_profileinfo[0]['email'];
        buddy_image = buddy_profileinfo[0]["photourl"];
        print("result:====+++++======${buddy_profileinfo[0]['employee']}");
        setState(() {});
      });
    }
  }

  SendMaptoRecent() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    // var data = {
    //   "sender": widget.mobileNumber.toString(),
    //   "message_id": recieverid,
    //   "buddyid": widget.mobileNumber.toString(),
    //   "sentby": widget.mobileNumber.toString(),
    //   "sentto": widget.buddyId.toString(),
    //   "uid": widget.buddyId.toString(),
    //   "username": widget.loggedInName.toString(),
    //   "buddyImage": "default",
    //   "messagecount": 0,
    //   "fileType": "text",
    //   "message": CryptedText.toString(),
    //   "openGroup": false,
    //   "timestamp": time.toString(),
    //   "fileextension": ""
    // };
    // String body = json.encode(data);
    // http.Response response = await http.post(Uri.parse(RecentMsg),
    //     body: body,
    //     headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    final prefs = await SharedPreferences.getInstance();
    userLogged = prefs.getString('username');
    userprofile = prefs.getString('profilepic');
    var data = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.mobileNumber.toString(),
      "buddyid": widget.buddyId.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sentto": widget.buddyId.toString(),
      "message_id": senderid,
      "buddyImage": widget.images ?? "".toString(),
      "username": widget.names ?? "".toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedText.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };
    var data1 = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.buddyId.toString(),
      "buddyid": widget.mobileNumber.toString(),
      "sentby": widget.buddyId.toString(),
      "sentto": widget.mobileNumber.toString(),
      "message_id": recieverid,
      "buddyImage": userprofile ?? "".toString(),
      "username": userLogged ?? "".toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedText.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };

    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$data");
    String body = json.encode(data);
    String body1 = json.encode(data1);
    http.Response response = await http.post(Uri.parse(RecentMsg),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    http.Response responses = await http.post(Uri.parse(RecentMsg),
        body: body1,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$statucode");
  }

  onImageSend(String path, String msg) async {
    chatLoading = false;
    var request = http.MultipartRequest('POST', Uri.parse(uploadImage));
    print("########################$request");
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

    var DecryptedText12 = decrypted(CryptedImage);

    var messageJson = {
      "message": CryptedImage.toString(),
      "sentByMe": socket.id.toString(),
      "sndrMsgId": senderid,
      "senttime": timeStamp.toString(),
      "path": '',
      "fileType": "image",
      "Docs": ''
    };

    socket.emit('chatmessage', messageJson);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
    });
    sendImagetoApi();
    SendImagetoRecent();
    chatLoading = true;
  }

  sendImagetoApi() async {
    print('Sending Msg');
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "message": CryptedImage.toString(),
      "sentby": widget.mobileNumber.toString(),
      "message_id": widget.mobileNumber + '_' + widget.buddyId,
      "timestamp": time.toString(),
      "sentto": widget.buddyId.toString(),
      "buddyid": widget.buddyId.toString(),
      "username": userLogged.toString(),
      "buddyImage": widget.images.toString(),
      "channel": "android",
      "location": false,
      "latitude": false,
      "status": "1",
      "filetype": "image",
      "tagmessage": null,
      "Date": "2022-08-12T05:27:48.439Z",
      "fileextension": ".jpg",
      "Taskfrom": "",
      "Taskto": "",
      "chatType": "1",
      "selfdestruct": false,
      "selected": false,
      "forwardmsg": null,
      "selectedColor": "none",
      "showMore": false
    };

    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(Save_Msg_PersonalChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
  }

  SendImagetoRecent() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    userLogged = prefs.getString('username');
    userprofile = prefs.getString('profilepic');
    //var time = DateTime.now().millisecondsSinceEpoch;
    var data = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.mobileNumber.toString(),
      "buddyid": widget.buddyId.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sentto": widget.buddyId.toString(),
      "message_id": senderid,
      "buddyImage": widget.images ?? "".toString(),
      "username": widget.names.toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedImage.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };
    var data1 = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.buddyId.toString(),
      "buddyid": widget.mobileNumber.toString(),
      "sentby": widget.buddyId.toString(),
      "sentto": widget.mobileNumber.toString(),
      "message_id": recieverid,
      "buddyImage": userprofile ?? "".toString(),
      "username": userLogged.toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedImage.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };

    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$data");
    String body = json.encode(data);
    String body1 = json.encode(data1);
    http.Response response = await http.post(Uri.parse(RecentMsg),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    http.Response responses = await http.post(Uri.parse(RecentMsg),
        body: body1,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    // var data = {
    //   "sender": widget.mobileNumber.toString(),
    //   "message_id": recieverid,
    //   "buddyid": widget.mobileNumber.toString(),
    //   "sentby": widget.mobileNumber.toString(),
    //   "sentto": widget.buddyId.toString(),
    //   "uid": widget.buddyId.toString(),
    //   "username": widget.loggedInName.toString(),
    //   "buddyImage": "default",
    //   "messagecount": "",
    //   "fileType": "text",
    //   "filetype": "text",
    //   "message": CryptedImage.toString(),
    //   "openGroup": false,
    //   "timestamp": time.toString(),
    //   "fileextension": ""
    // };
    // String body = json.encode(data);
    // http.Response response = await http.post(Uri.parse(RecentMsg),
    //     body: body,
    //     headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$statucode");
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
      "sndrMsgId": senderid,
      "senttime": timeStamp.toString(),
      "path": '',
      "fileType": "Docs",
      "Docs": CryptedDocs.toString()
    };

    socket.emit('chatmessage', messageJson);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
    });
    print("audioooooooooooooooooooooooooooooooooooooooooo$messageJson");
    sendingDocstoApi();
  }

  sendingDocstoApi() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    Map data = {
      "message": CryptedDocs.toString(),
      "sentby": widget.mobileNumber.toString(),
      "message_id": widget.mobileNumber + '_' + widget.buddyId,
      "timestamp": time.toString(),
      "sentto": widget.buddyId.toString(),
      "buddyid": widget.buddyId.toString(),
      "username": widget.names.toString(),
      "buddyImage": widget.images.toString(),
      "channel": "android",
      "location": false,
      "latitude": false,
      "status": "1",
      "filetype": "Docs",
      "tagmessage": null,
      "Date": "2022-08-12T05:27:48.439Z",
      "fileextension": ".jpg",
      "Taskfrom": "",
      "Taskto": "",
      "chatType": "1",
      "selfdestruct": false,
      "selected": false,
      "forwardmsg": null,
      "selectedColor": "none",
      "showMore": false
    };

    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(Save_Msg_PersonalChat),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;
    SendDocstoRecent();
  }

  SendDocstoRecent() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    userLogged = prefs.getString('username');
    userprofile = prefs.getString('profilepic');
    //var time = DateTime.now().millisecondsSinceEpoch;
    var data = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.mobileNumber.toString(),
      "buddyid": widget.buddyId.toString(),
      "sentby": widget.mobileNumber.toString(),
      "sentto": widget.buddyId.toString(),
      "message_id": senderid,
      "buddyImage": widget.images ?? "".toString(),
      "username": widget.names ?? "".toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedDocs.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };
    var data1 = {
      "sender": widget.mobileNumber.toString(),
      "uid": widget.buddyId.toString(),
      "buddyid": widget.mobileNumber.toString(),
      "sentby": widget.buddyId.toString(),
      "sentto": widget.mobileNumber.toString(),
      "message_id": recieverid,
      "buddyImage": userprofile ?? "".toString(),
      "username": userLogged ?? "".toString(),
      "messagecount": 0,
      "fileType": "text",
      "message": CryptedDocs.toString(),
      "openGroup": false,
      "timestamp": time.toString(),
      "fileextension": ""
    };

    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$data");
    String body = json.encode(data);
    String body1 = json.encode(data1);
    http.Response response = await http.post(Uri.parse(RecentMsg),
        body: body,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    http.Response responses = await http.post(Uri.parse(RecentMsg),
        body: body1,
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    var statucode = response.statusCode;

    // var data = {
    //   "sender": widget.mobileNumber.toString(),
    //   "message_id": recieverid,
    //   "buddyid": widget.mobileNumber.toString(),
    //   "sentby": widget.mobileNumber.toString(),
    //   "sentto": widget.buddyId.toString(),
    //   "uid": widget.buddyId.toString(),
    //   "username": widget.loggedInName.toString(),
    //   "buddyImage": "default",
    //   "messagecount": "",
    //   "fileType": "text",
    //   "filetype": "text",
    //   "message": CryptedDocs.toString(),
    //   "openGroup": false,
    //   "timestamp": time.toString(),
    //   "fileextension": ""
    // };
    // String body = json.encode(data);
    // http.Response response = await http.post(Uri.parse(RecentMsg),
    //     body: body,
    //     headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    //var statucode = response.statusCode;
    print("_+_+_+_+_+_+_+_+_+_+_+_+_+$statucode");
  }

  update_status(String loginnumber, status, last_changed, deviceid) async {
    print("ssssssssssssssssssssssssss");
    var data = {
      "mobile": loginnumber.toString(),
      "status": status ?? "",
      "last_changed": last_changed.toString(),
      "deviceid": deviceid ?? ""
    };

    http.Response response = await post(Uri.parse(Statusupdate), body: data);

    var res = response.body;
    print("somethinng-----------------$res");
  }

  clearchatmessage(
    cleartimestamp,
    loginnumber,
  ) async {
    print("ssssssss---clearchat----ssssssssssssssssss");
    var data = {
      "cleartimestamp": cleartimestamp.toString(),
      "sentby": loginnumber.toString(),
      "message_id": senderid,
    };
    print("-----------data--------$data");
    http.Response response =
        await post(Uri.parse(clearChatmessage), body: data);

    var res = response.body;
    print("somethinng-----------------$res");
    if (response.statusCode == 200) {
      setState(() {
        jsonData.clear;
      });
    }
  }

  XFile? file;
  bool isTextfield = true;
  String searchString = "";

  final TextEditingController SearchController = TextEditingController();
  bool checking = false;
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
    });

    return SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
                endDrawer: Drawer(
                    child: InkWell(
                  // onTap: () async{
                  //   buddy_profile();
                  // },
                  child: Column(children: [
                    Container(
                      height: 70,
                      child: DrawerHeader(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.names ?? '',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
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
                      radius: 50,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: buddy_image ?? '',
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
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            "Employee Code :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            buddy_employee ?? ''.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            "Gender :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            // buddy_profileinfo['gender']??"".toString(),
                            buddy_gender ?? ''.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Text(
                            "Mobile :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            buddy_mobile ?? "".toString(),
                            //buddy_profileinfo['mobile'] ?? "".toString(),
                            // mobile ?? ''.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Text(
                            "Email :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            buddy_email ?? ''.toString(),
                            //buddy_profileinfo['email']??"".toString(),
                            //email ?? ''.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Text(
                            "Designation :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            buddy_designation ?? ''.toString(),
                            // buddy_profileinfo['designation'] ??
                            //  ''.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Text(
                            "Department :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            buddy_department ?? ''.toString(),
                            //buddy_profileinfo['department']??"".toString(),
                            // department ?? ''.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                  ]),
                )),
                appBar: isTextfield
                    ? AppBar(
                        leading: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.callback();
                              });

                              Navigator.pop(
                                context,
                              );
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 25,
                            )),
                        leadingWidth: 30,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.images ?? "",
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.person,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                widget.status == 'online'
                                    ? Positioned(
                                        left: 28,
                                        top: 26,
                                        child: Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.green),
                                        ))
                                    : Positioned(
                                        left: 28,
                                        top: 26,
                                        child: Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.red),
                                        )),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                widget.names ?? ''.toString(),
                                style: TextStyle(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.video_call)),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VoiceCall(
                                              buddyname: widget.names,
                                              buddyImage: widget.images,
                                            )));
                              },
                              icon: const Icon(Icons.call)),
                          Theme(
                              data: Theme.of(context).copyWith(
                                dividerTheme: const DividerThemeData(
                                    color: Colors.black, thickness: 0.5),
                                iconTheme: IconThemeData(color: Colors.white),
                              ),
                              child: PopupMenuButton(
                                  color: const Color.fromRGBO(1, 123, 255, 1),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            height: 10,
                                            child: Column(
                                              children: [
                                                Mainmenu(
                                                    value: 1,
                                                    height: 0,
                                                    text: 'Profile',
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      buddy_profile();
                                                      Scaffold.of(context)
                                                          .openEndDrawer();
                                                    },
                                                    Icon: const Icon(
                                                        Icons.person)),
                                                PopupMenuDivider()
                                              ],
                                            )),
                                        PopupMenuItem(
                                            height: 30,
                                            child: Column(
                                              children: [
                                                Mainmenu(
                                                    value: 2,
                                                    height: 0,
                                                    text: 'Search',
                                                    onTap: () {
                                                      setState(() {
                                                        Navigator.pop(context);
                                                        print(
                                                            "goodddddddddddddddddddddddddddd");
                                                        isTextfield = false;
                                                      });

                                                      // Navigator.pop(context,
                                                      //     isTextfield = true);
                                                    },
                                                    Icon: const Icon(
                                                        Icons.search)),
                                                PopupMenuDivider()
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
                                                      builder: (BuildContext
                                                              context) =>
                                                          FileFilter(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                                Icon: const Icon(
                                                    Icons.file_open)),
                                            PopupMenuDivider()
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
                                                        builder: (BuildContext
                                                                context) =>
                                                            SearchFilter()),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                                Icon: const Icon(Icons.chat)),
                                            PopupMenuDivider()
                                          ],
                                        )),
                                        PopupMenuItem(
                                            child: Column(
                                          children: [
                                            Mainmenu(
                                                value: 2,
                                                height: 0,
                                                text: 'Block',
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return WillPopScope(
                                                          onWillPop: () async =>
                                                              false,
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    250,
                                                                    241,
                                                                    161),
                                                            content: Text(
                                                              'Do you want to block this contact?',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15),
                                                            ),
                                                            title: const Text(
                                                              'Confirm !',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 35),
                                                            ),
                                                            actions: <Widget>[
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    shadowColor:
                                                                        Colors
                                                                            .grey,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12))),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    shadowColor:
                                                                        Colors
                                                                            .grey,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12))),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                Icon: const Icon(Icons.lock)),
                                            PopupMenuDivider()
                                          ],
                                        )),
                                        PopupMenuItem(
                                            child: Column(
                                          children: [
                                            Mainmenu(
                                                value: 2,
                                                height: 0,
                                                text: 'Clear Chat',
                                                onTap: () {
                                                  // clearchatmessage(DateTime.now().millisecondsSinceEpoch,mobileNumber);
                                                },
                                                Icon: const Icon(Icons.delete)),
                                            PopupMenuDivider()
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return WillPopScope(
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
                                                            actions: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 70,
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        _pickFile();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        width:
                                                                            80,
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            'Gallery',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        width:
                                                                            80,
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            'Default',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                      );
                                                    });
                                              },
                                              Icon: const Icon(
                                                  Icons.wallpaper_sharp)),
                                          const PopupMenuDivider()
                                        ]))
                                      ])),
                        ],
                      )
                    : AppBar(
                        leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 25,
                            )),
                        leadingWidth: 30,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.images ?? "",
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.person,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                widget.status == 'online'
                                    ? Positioned(
                                        left: 28,
                                        top: 26,
                                        child: Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.green),
                                        ))
                                    : Positioned(
                                        left: 28,
                                        top: 26,
                                        child: Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.red),
                                        )),
                              ],
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                                child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: SearchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  //   focusedBorder: InputBorder.none,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  prefixIcon: InkWell(
                                    child: Icon(Icons.arrow_back_rounded),
                                    onTap: () {
                                      setState(() {
                                        isTextfield = true;
                                        SearchController.clear();
                                        searchString = "";
                                      });
                                    },
                                  ),
                                  hintText: "Search",
                                  filled: true,
                                  fillColor: Colors.white,
                                  //contentPadding: EdgeInsets.zero
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchString = value.toLowerCase();
                                  });
                                },
                              ),
                            )),
                          ],
                        ),
                        actions: [
                          Theme(
                              data: Theme.of(context).copyWith(
                                dividerTheme: const DividerThemeData(
                                    color: Colors.black, thickness: 0.5),
                                iconTheme:
                                    const IconThemeData(color: Colors.white),
                              ),
                              child: PopupMenuButton(
                                  color: const Color.fromRGBO(1, 123, 255, 1),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            height: 10,
                                            child: Column(
                                              children: [
                                                Mainmenu(
                                                    value: 1,
                                                    height: 0,
                                                    text: 'Profile',
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      buddy_profile();
                                                      Scaffold.of(context)
                                                          .openEndDrawer();
                                                    },
                                                    Icon: const Icon(
                                                        Icons.person)),
                                                PopupMenuDivider()
                                              ],
                                            )),
                                        PopupMenuItem(
                                            height: 30,
                                            child: Column(
                                              children: [
                                                Mainmenu(
                                                    value: 2,
                                                    height: 0,
                                                    text: 'Search',
                                                    onTap: () {
                                                      isTextfield = false;
                                                      // Navigator.pop(context,
                                                      //     isTextfield = true);
                                                    },
                                                    Icon: const Icon(
                                                        Icons.search)),
                                                PopupMenuDivider()
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
                                                      builder: (BuildContext
                                                              context) =>
                                                          FileFilter(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                                Icon: const Icon(
                                                    Icons.file_open)),
                                            PopupMenuDivider()
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
                                                      builder: (BuildContext
                                                              context) =>
                                                          SearchFilter(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                                Icon: const Icon(Icons.chat)),
                                            PopupMenuDivider()
                                          ],
                                        )),
                                        PopupMenuItem(
                                            child: Column(
                                          children: [
                                            Mainmenu(
                                                value: 2,
                                                height: 0,
                                                text: 'Block',
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return WillPopScope(
                                                          onWillPop: () async =>
                                                              false,
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    250,
                                                                    241,
                                                                    161),
                                                            content: Text(
                                                              'Do you want to block this contact?',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15),
                                                            ),
                                                            title: const Text(
                                                              'Confirm !',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 35),
                                                            ),
                                                            actions: <Widget>[
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    shadowColor:
                                                                        Colors
                                                                            .grey,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12))),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    shadowColor:
                                                                        Colors
                                                                            .grey,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12))),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                Icon: const Icon(Icons.lock)),
                                            PopupMenuDivider()
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
                                            PopupMenuDivider()
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return WillPopScope(
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
                                                            actions: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 70,
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        _pickFile();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        width:
                                                                            80,
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            'Gallery',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        width:
                                                                            80,
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            'Default',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                      );
                                                    });
                                              },
                                              Icon: const Icon(
                                                  Icons.wallpaper_sharp)),
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
                          var updatingScroll = chat.chatMessages.length + 10;

                          return OnRefresh(updatingScroll);
                        },
                        child: ListView.builder(
                            // reverse: true,
                            scrollDirection: Axis.vertical,
                            controller: scrollController,
                            dragStartBehavior: DragStartBehavior.down,
                            shrinkWrap: false,
                            itemCount: chat.chatMessages.length + 1,
                            itemBuilder: (context, index) {
                              // var Date_Time = ConvertingTimeStamp((int.parse(
                              //     chat.chatMessages[index].senttime)));
                              if (responseStatusCode == 200) {
                                if (index == chat.chatMessages.length) {
                                  return Container(
                                    height: emojiShowing ? 400 : 150,
                                  );
                                }
                                if (chat.chatMessages[index].fileType ==
                                        "map" ||
                                    decrypted(chat.chatMessages[index].message)
                                        .toString()
                                        .startsWith("LatLng")) {
                                  print(
                                      "######### MAP ###############################################################");
                                  if (chat.chatMessages[index].sndrMsgId ==
                                      senderid) {
                                    return OwnLocationCard(
                                      path: decrypted(
                                        chat.chatMessages[index].path,
                                      ),
                                      time: chat.chatMessages[index].senttime,
                                    );
                                  } else if (chat
                                          .chatMessages[index].sndrMsgId ==
                                      recieverid) {
                                    return ReplyLocationCard(
                                      path: decrypted(
                                        chat.chatMessages[index].path,
                                      ),
                                      time: chat.chatMessages[index].senttime,
                                    );
                                  }
                                  return Container();
                                } else if ((chat.chatMessages[index].fileType ==
                                        "text"
                                    // chat.chatMessages[index].path == null ||
                                    //       chat.chatMessages[index].path == '') &&
                                    //   (chat.chatMessages[index].Docs == null ||
                                    //       chat.chatMessages[index].Docs == ''

                                    )) {
                                  if (chat.chatMessages[index].sndrMsgId ==
                                      senderid) {
                                    print("---------nisha-----${decrypted(
                                      chat.chatMessages[index].message,
                                    )}");
                                    return SenderMessageItem(
                                      MsgSeen: MsgSeen,
                                      message: decrypted(
                                        chat.chatMessages[index].message,
                                      ),
                                      senttime:
                                          chat.chatMessages[index].senttime,
                                      sentByMe:
                                          chat.chatMessages[index].sentByMe ==
                                              socket.id,
                                      sndBy: widget.buddyId,
                                      MobileNumber:
                                          widget.mobileNumber.toString(),
                                    );
                                  } else if (chat
                                          .chatMessages[index].sndrMsgId ==
                                      recieverid) {
                                    return RecieverMessageItem(
                                        message: decrypted(
                                          chat.chatMessages[index].message,
                                        ),
                                        senttime: chat
                                            .chatMessages[index].senttime
                                            .toString(),
                                        sentByMe:
                                            chat.chatMessages[index].sentByMe ==
                                                socket.id);
                                  }
                                  return Container();
                                } else if ((chat.chatMessages[index].fileType ==
                                    "image")) {
                                  if (chat.chatMessages[index].sndrMsgId ==
                                      senderid) {
                                    return PersonelOwnCard(
                                      path: decrypted((chat
                                              .chatMessages[index].message))
                                          .toString(),
                                      sentByMe: true,
                                      time: chat.chatMessages[index].senttime
                                          .toString(),
                                    );
                                  } else if (chat
                                          .chatMessages[index].sndrMsgId ==
                                      recieverid) {
                                    return PersonelReplyFileCard(
                                      path: decrypted(
                                        chat.chatMessages[index].message,
                                      ).toString(),
                                      time: chat.chatMessages[index].senttime
                                          .toString(),
                                    );
                                  }
                                } else if (chat.chatMessages[index].fileType ==
                                    "Docs") {
                                  if (chat.chatMessages[index].sndrMsgId ==
                                      senderid) {
                                    if (decrypted(chat.chatMessages[index].path)
                                        .endsWith(".mp4")) {
                                      return OwnVoiceCard(
                                        path: decrypted(
                                          chat.chatMessages[index].path,
                                        ),
                                        time: chat.chatMessages[index].senttime,
                                      );
                                    }
                                    return fileViewSender(
                                        pathoffile: decrypted(chat
                                            .chatMessages[index].message
                                            .toString()),
                                        time: chat.chatMessages[index].senttime,
                                        OnDocssend: onDocsSend);
                                  } else if (chat
                                          .chatMessages[index].sndrMsgId ==
                                      recieverid) {
                                    if (decrypted(chat.chatMessages[index].path)
                                        .endsWith(".mp4")) {
                                      return ReplyVoiceCard(
                                        path: decrypted(
                                            chat.chatMessages[index].path),
                                        time: chat.chatMessages[index].senttime,
                                      );
                                    }
                                    return fileViewReciever(
                                        pathoffile: decrypted(chat
                                                .chatMessages[index].message)
                                            .toString(),
                                        time: chat.chatMessages[index].senttime,
                                        OnDocssend: onDocsSend);
                                  }
                                }
                                return Container();
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 300),
                                child: Center(
                                    child: chat.chatMessages.firstRebuild
                                        ? CircularProgressIndicator()
                                        : null),
                              );
                            }),
                      ))
                    ]))),
                bottomSheet: ChatInputBox(
                  buddyname: widget.names ?? '',
                  onsent: onImageSend,
                  controller: chatController,
                  onLocation: (LatLng loc) {
                    print("**** LOCATION SEND *****");
                    _OnSendMap(loc.toString(), senderid);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  onTap: () {
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);

                    _sendMessage(chatController.text, senderid);

                    chatController.clear();
                    setState(() {
                      chatController.text.isEmpty
                          ? MicIcon = false
                          : MicIcon = true;
                    });
                  },
                  DocumentSnd: onDocsSend,
                ))));
  }

  Future _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
  }

  ConvertingTimeStamp(senttime) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(senttime);
    var format = DateFormat('hh:mm').format(date);
    //var formattedTime = format.format(date);
    print("aaaaaaaaaaaaaaaaaa-------$format");
    return format.toString();
  }
}

ConvertingTimeStamp1(senttime) {
  final DateTime date =
      DateTime.fromMillisecondsSinceEpoch(int.parse(senttime));
  var format = DateFormat('dd/MM/yyyy').format(date);
  //var formattedTime = format.format(date);
  print("aaaaaaaaaaaaaaaaaa-------$format");
  return format.toString();
}

class RecieverMessageItem extends StatefulWidget {
  const RecieverMessageItem(
      {required this.sentByMe,
      required this.message,
      this.path,
      required this.senttime})
      : super();
  final bool sentByMe;
  final String message;
  final String senttime;
  final String? path;

  @override
  State<RecieverMessageItem> createState() => _RecieverMessageItemState();
}

class _RecieverMessageItemState extends State<RecieverMessageItem> {
  @override
  Widget build(BuildContext context) {
    final key = encrypt.Key.fromUtf8('d6F3Efeq................');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final EncryptedText = encrypter.encrypt(widget.message, iv: iv);
    final decryptedText = encrypter.decrypt(EncryptedText, iv: iv);

    return Padding(
      padding: EdgeInsets.only(right: 100, left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding: EdgeInsets.only(bottom: 0, top: 5, left: 10, right: 5),
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
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
                      "${decryptedText.toString()}",
                      style: TextStyle(
                          fontSize: 18,
                          color: widget.sentByMe ? Colors.white : Colors.white),
                    ),
                  ),
                ),
                SizedBox(
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
