// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable, non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Landing Files/widgets.dart';

class ChatInputBox extends StatefulWidget {
  dynamic controller;
  dynamic onTap;
  Function onsent;
  Function DocumentSnd;
  Function onLocation;

  ChatInputBox(
      {super.key,
      required this.controller,
      this.onTap,
      required this.onsent,
      required this.DocumentSnd,
      required this.onLocation});

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool MicIcon = true;
  bool emojiShowing = false;
  bool emojiVisibility = true;
  bool isKeyboardVisible = false;
  FlutterSoundRecorder myRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();

  bool isRecording = false;
  String _duration = "0.0";

  @override
  void initState() {
    super.initState();

    KeyboardVisibility.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });

      if (isKeyboardVisible && emojiShowing) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
    myRecorder.openRecorder();
    myPlayer.openPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    myRecorder.closeRecorder();
  }

  _onEmojiSelected(Emoji emoji) {
    setState(() {
      chatController
        ..text += emoji.emoji
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: chatController.text.length));
    });
  }

  _onBackspacePressed() {
    chatController
      ..text = chatController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: chatController.text.length));
  }

  onTap(text) {
    setState(() {
      if (chatController.text.trim() == "") {
        MicIcon = true;
      } else {
        MicIcon = false;
      }
      emojiVisibility = false;
    });
  }

  onChanged(value) {
    setState(() {
      if (chatController.value.text.isEmpty) {
        setState(() {
          MicIcon = true;
        });
      } else if (chatController.value.text.isNotEmpty) {
        setState(() {
          MicIcon = false;
        });
      }
      emojiVisibility = false;
    });
  }

  XFile? file;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalFormKey,
      child: Wrap(
        children: [
          Container(
            color: const Color.fromRGBO(1, 123, 255, 1),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: isRecording
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              cursorHeight: 16,
                              enabled: false,
                              maxLines: 10,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              // autovalidateMode: AutovalidateMode.always,
                              cursorColor: Colors.grey.shade900,
                              // onTap: onTap(),
                              // onTap: onTap(),

                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 16),
                                  hintText: 'Recording... $_duration',
                                  prefixIcon: const Icon(
                                    Icons.mic,
                                    color: Colors.red,
                                  )),
                            ))
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              cursorHeight: 16,
                              controller: chatController,
                              onTap: onTap(MicIcon),

                              onChanged: onChanged,
                              maxLines: 10,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              // autovalidateMode: AutovalidateMode.always,
                              cursorColor: Colors.grey.shade900,
                              // onTap: onTap(),
                              // onTap: onTap(),

                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  hintText: 'Type a message',
                                  prefixIcon: Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              emojiVisibility = false;
                                              // MicIcon = false;
                                              emojiShowing = !emojiShowing;

                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            });
                                          },
                                          icon: const Image(
                                              image: AssetImage(
                                                  'assets/images/smiley.png')))),

                                  // :Icon(Icons.send)

                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return attatchmentContents(
                                            Ontap: widget.onTap,
                                            onsentimage: widget.onsent,
                                            OnDocSend: widget.DocumentSnd,
                                            onLocation: widget.onLocation,
                                          );
                                        },
                                      );
                                    },

                                    icon: const Image(
                                      image: AssetImage(
                                          'assets/images/attachments.png'),
                                      height: 50,
                                    ),
                                    // iconSize: 25,
                                  )),
                            )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: MicIcon
                          ? GestureDetector(
                              onLongPress: () async {
                                Directory p = await getTemporaryDirectory();
                                await Permission.microphone.request();
                                setState(
                                  () {
                                    isRecording = true;
                                  },
                                );

                                myRecorder.startRecorder(
                                    codec: Codec.defaultCodec,
                                    toFile:
                                        "${p.path}/${DateTime.now().millisecondsSinceEpoch}.mp4");

                                print("++++++++++++++++++++++++++");
                                myRecorder.setSubscriptionDuration(
                                    const Duration(milliseconds: 300));
                                myRecorder.onProgress
                                    ?.listen((RecordingDisposition event) {
                                  print(event.duration);

                                  setState(
                                    () {
                                      _duration =
                                          "${event.duration.inMinutes.remainder(60)}.${event.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
                                    },
                                  );
                                });
                              },
                              onLongPressUp: () {
                                print(
                                    "Tyring to stop ${myRecorder.isRecording}");
                                setState(
                                  () {
                                    isRecording = false;
                                  },
                                );
                                if (myRecorder.isRecording) {
                                  myRecorder.stopRecorder().then((abc) {
                                    print("--------$abc");
                                    print("!!!!!!!!!!!!!!!!-----$_duration");
                                    if (double.parse(_duration) > 0.01) {
                                      print("-------good------");
                                      widget.DocumentSnd(
                                        abc,
                                        '${DateTime.now().millisecondsSinceEpoch}.mp4',
                                      );
                                    } else {
                                      print(
                                          "++++++++++Duration is invalid+++++++++++");
                                    }
                                  });
                                }
                              },
                              child: const Image(
                                image: AssetImage('assets/images/mic.png'),
                              ))
                          : Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: IconButton(
                                onPressed: widget.onTap,
                                icon: const Icon(
                                  Icons.send,
                                  color: Color.fromRGBO(1, 123, 255, 1),
                                  size: 20,
                                ),
                              ))),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
              height: 250.0,
              child: EmojiPicker(
                  onEmojiSelected: (Category ?category, Emoji emoji) {
                    _onEmojiSelected(emoji);
                  },
                  onBackspacePressed: _onBackspacePressed,
                  config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 0.8),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                     // progressIndicatorColor: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL)),
            ),
          )
        ],
      ),
    );
  }
}
