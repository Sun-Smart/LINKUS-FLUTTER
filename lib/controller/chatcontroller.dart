// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:core';


import 'package:get/get.dart';

class msgController extends GetxController {
  var chatMessages = <Message>[].obs;
}

class Message {
  String message;
  String sentByMe;
  String senttime;
  String sndrMsgId;
  String path;
  String? Docs;
  String fileType;
  String? replyerName;
  Message(
      {required this.message,
      required this.sentByMe,
      required this.senttime,
      required this.path,
      required this.sndrMsgId,
      this.Docs,
      this.replyerName,
      required this.fileType});
  factory Message.froJson(Map<String, dynamic> json) {
    return Message(
        message: json["message"],
        sentByMe: json["sentByMe"],
        senttime: json["senttime"],
        sndrMsgId: json["sndrMsgId"],
        path: json["message"],
        Docs: json["Docs"],
        fileType: json["fileType"],
        replyerName: json["replyerName"]);
  }
}

class GroupMsgController extends GetxController {
  var GroupMessage = <Message>[].obs;
}

class GroupMsg {
  String message;
  String sentByMe;
  String senttime;
  String sndrMsgId;
  String path;
  String? Docs;
  String fileType;
  String? replyerName;
  GroupMsg(
      {required this.message,
      required this.sentByMe,
      required this.senttime,
      required this.path,
      required this.sndrMsgId,
      this.Docs,
      this.replyerName,
      required this.fileType});
  factory GroupMsg.froJson(Map<String, dynamic> json) {
    return GroupMsg(
        message: json["message"],
        sentByMe: json["sentByMe"],

        senttime: json["senttime"],
        sndrMsgId: json["sndrMsgId"],
        path: json["message"],
        Docs: json["Docs"],
        fileType: json["fileType"],
        replyerName: json["replyerName"]);
  }
}
//git commit checking