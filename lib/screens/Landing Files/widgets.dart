// ignore_for_file: import_of_legacy_library_into_null_safe, unused_field, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, camel_case_types, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:linkus/controller/chatcontroller.dart';
import 'package:linkus/screens/attachmentWidgets/location.dart';
import 'package:linkus/screens/chatscreen%20Files/cameraPage.dart';
import 'package:linkus/screens/chatscreen%20Files/cameraView.dart';
import 'package:linkus/screens/chatscreen%20Files/dataList.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../variables/Api_Control.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:http/http.dart';
import '../chatscreen Files/groupChat.dart';
import '../chatscreen Files/individualChat.dart';

//wertyuioiuyfd
class ChatList extends StatefulWidget {
  dynamic chtcntLen;
  dynamic profIcon;
  dynamic msgText;
  dynamic contactName;
  dynamic ntfctnCnt;
  dynamic msgdte$tme;
  dynamic ItmCnt;
  dynamic onTap;
  final name;

  ChatList(
      {Key? key,
      this.profIcon,
      this.msgText,
      this.contactName,
      this.ntfctnCnt,
      this.msgdte$tme,
      this.ItmCnt,
      this.onTap,
      this.name,
      this.chtcntLen})
      : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

final TextEditingController chatController = TextEditingController();
final TextEditingController SearchController = TextEditingController();

class _ChatListState extends State<ChatList> {
  var noData;
  var loader;
  @override
  void initState() {
    LoadData();
    if (usernames.isEmpty) {
      setState(() {
        noData = true;
        loader = true;
      });
    }
    super.initState();
  }

  var mobileNumber;

  var usernames = [];
  var profilePics = [];
  var buddyId = [];
  var RecentMsg = [];

  var username_length;
  var responseStatusCode;
  String searchString = "";
  LoadData() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('mobileNumber');

    print('--------------->$mobileNumber');

    http.Response response = await http.post(Uri.parse(RecentChats_Api), body: {
      'myid': mobileNumber.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });
    responseStatusCode = response.body;
    print(response.body);
    var d1 = json.decode(response.body);
    var Data = d1;
    print(Data);
    print(Data.length);
    // var ;
    if (Data != null || Data != []) {
      for (var i = 0; i < Data.length; i++) {
        usernames.add(Data[i]['username']);
        buddyId.add(Data[i]['buddyid']);
        profilePics.add(Data[i]['buddyimage']);
        RecentMsg.add(Data[i]['message']);
      }
    } else {
      return Text('No Chats Found');
    }

    print('--------->$usernames');
    setState(() {
      username_length = usernames.length;
      print('--------->$username_length');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: Center(child: CircularProgressIndicator()),
        future: Future.delayed(const Duration(seconds: 5)),
        builder: ((context, snapshot) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Card(
                elevation: 5,
                child: TextFormField(
                    controller: SearchController,
                    // controller: ,
                    onChanged: (value) {
                      setState(() {
                        searchString = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        contentPadding: EdgeInsets.symmetric(vertical: 15))),
              ),
            ),
            usernames.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: username_length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return usernames[index]
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchString)
                              ? ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PersonalChat(
                                                  loggedInName:
                                                      widget.name.toString(),
                                                  names: usernames[index],
                                                  buddyId: buddyId[index],
                                                  images: profilePics[index],
                                                  mobileNumber:
                                                      mobileNumber.toString(),
                                                )));
                                  },
                                  leading: CircleAvatar(
                                    radius: 25,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: profilePics[index],
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(usernames[index]),
                                  subtitle: Text(
                                      // decrypted(

                                      RecentMsg[index].toString()

                                      // )

                                      ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      widget.ntfctnCnt,
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      widget.msgdte$tme
                                    ],
                                  ),
                                )
                              : Container();
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return usernames[index]
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchString)
                              ? const Divider()
                              : Container();
                        }),
                  )
                : responseStatusCode == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 200),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 250),
                        child: Text(
                          "No Chats Found",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      )
            // : Container()
          ]);
        }));
  }
}

decrypted(value) {
  var decoded = base64.decode(base64.normalize(value));
  print('-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=${utf8.decode(decoded)}');
  return utf8.decode(decoded);
  // return
}

class Mainmenu extends StatefulWidget {
  final int value;
  final double height;
  final text;
  final onTap;
  final Icon;

  const Mainmenu(
      {super.key,
      required this.value,
      required this.height,
      required this.text,
      required this.onTap,
      required this.Icon});

  @override
  State<Mainmenu> createState() => _MainmenuState();
}

class _MainmenuState extends State<Mainmenu> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.Icon,
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: widget.onTap,
            child: SizedBox(
              height: 30,
              width: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class footer extends StatelessWidget {
  const footer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromRGBO(1, 123, 255, 1),
        height: 20,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      '\u00a9 Copyright Ecnchat.io',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Center(
                      child: Text(
                    'Enchat',
                    style: TextStyle(color: Colors.white),
                  )),
                ],
              ),
            )));
  }
}

class attatchmentContents extends StatefulWidget {
  attatchmentContents(
      {super.key,
      required this.Ontap,
      required this.onsentimage,
      required this.OnDocSend,
      required this.onLocation});
  Function Ontap;
  Function onsentimage;
  Function OnDocSend;
  Function onLocation;

  @override
  State<attatchmentContents> createState() => _attatchmentContentsState();
}

var localPath;
loadData() async {
  final prefs = await SharedPreferences.getInstance();
  localPath = prefs.getString('localpath');
}

class _attatchmentContentsState extends State<attatchmentContents> {
  msgController FilesControll = msgController();
  @override
  void initState() {
    loadData();
    super.initState();
  }

  var result;

  Future _pickFile(BuildContext context) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false);
    var path = result!.files.first.path;

    // final path =
    join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => CameraViewPage(
          path: path.toString(),
          // result.path,
          OnImagesend: widget.onsentimage,
        ),
      ),
    );
  }

  Future _sendFile(BuildContext context) async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      // type: FileType.custom,
      // allowedExtensions: ['pdf', 'docx']
    );
    var path = result!.files.first.path;
    var name = result.files.first.name;

    // final path =
    join((await getTemporaryDirectory()).path, "${DateTime.now()}");

    // Navigator.pop(context, path);
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.white,
                // content: const Text(''),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            width: 80,
                            height: 40,
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            widget.OnDocSend(path, name);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },

                          // Navigator.pop(context);

                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            width: 80,
                            height: 40,
                            child: const Center(
                              child: Text(
                                'Send',
                                style: TextStyle(color: Colors.white),
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
  }

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 308,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      // await FilePicker.platform.pickFiles(type: FileType.any);

                      _sendFile(context);
                    },
                    child: Column(
                      children: const [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 151, 64, 251),
                          child: Icon(
                            Icons.file_copy,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Document'),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen(
                                    onImageSend: widget.onsentimage,
                                  )));
                    },
                    child: Column(
                      children: const [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.pink,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Camera'),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  InkWell(
                    onTap: () async {
                      _pickFile(context);
                      // await FilePicker.platform.pickFiles(type: FileType.image);
                    },
                    child: Column(
                      children: const [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purpleAccent,
                          child: Icon(
                            Icons.filter,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Gallery'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: const [
                          CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.location_on),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Location'),
                          )
                        ],
                      ),
                    ],
                  ),
                  onTap: () async {
                    LatLng latLang = await Navigator.push(
                        context,
                        (MaterialPageRoute(
                            builder: ((context) => Location()))));
                    print("+++++++++++++++++ LAT LANG ++++++++++++++++");
                    print(latLang);
                    if (latLang == null) return;
                    widget.onLocation(latLang);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class allContactsList extends StatefulWidget {
  final profIcon;
  final msgText;
  final contactName;
  final ntfctnCnt;
  final msgdte$tme;
  final ItmCnt;
  final mobileNumber;
  final buddyId;

  const allContactsList(
      {required this.profIcon,
      required this.msgText,
      required this.contactName,
      required this.ntfctnCnt,
      required this.msgdte$tme,
      required this.ItmCnt,
      super.key,
      this.mobileNumber,
      this.buddyId});

  @override
  State<allContactsList> createState() => _allContactsListState();
}

class _allContactsListState extends State<allContactsList> {
  @override
  void initState() {
    listItems;
    super.initState();
  }

  final TextEditingController SearchController = TextEditingController();
  String searchString = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      builder: ((context, snapshot) {
        return listItems.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Card(
                      elevation: 5,
                      child: TextFormField(
                          controller: SearchController,
                          onChanged: (value) {
                            setState(() {
                              searchString = value.toLowerCase();
                            });
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15))),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: listItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return listItems[index]
                                  .Name
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchString)
                              ? ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PersonalChat(
                                                  buddyId:
                                                      widget.buddyId[index],
                                                  mobileNumber:
                                                      widget.mobileNumber,
                                                  names: listItems[index].Name,
                                                  images:
                                                      listItems[index].photourl,
                                                )));
                                  },
                                  leading: CircleAvatar(
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            listItems[index].photourl ?? "",
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(listItems[index].Name),
                                  subtitle: Text(listItems[index].jobProfile),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      listItems[index].status == "online"
                                          ? Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.green),
                                            )
                                          : Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.red),
                                            ),
                                      widget.msgdte$tme
                                    ],
                                  ),
                                )
                              : Container();
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return listItems[index]
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchString)
                              ? const Divider()
                              : Container();
                        }),
                  ),
                ],
              );
      }),
    );
  }
}

class GroupChatList extends StatefulWidget {
  final profIcon;
  final msgText;
  final contactName;
  final ntfctnCnt;
  final msgdte$tme;
  final ItmCnt;
  final onTap;
  final username;

  const GroupChatList(
      {required this.profIcon,
      required this.msgText,
      required this.contactName,
      required this.ntfctnCnt,
      required this.msgdte$tme,
      required this.ItmCnt,
      required this.onTap,
      super.key,
      this.username});

  @override
  State<GroupChatList> createState() => _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatList> {
  final TextEditingController SearchController = TextEditingController();
  @override
  void initState() {
    LoadGroupData();
    super.initState();
  }

  var mobileNumber;
  var senderName;
  var GroupNames = [];
  var GroupImages = [];
  var GroupCreated = [];
  var GroupKey = [];
  var GroupName_Length;
  var responseStatusCode;
  LoadGroupData() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('mobileNumber');
    senderName = prefs.getString('username');
    // final LocalStorage storage = LocalStorage('localstorage_app');

    // mobileNumber = storage.getItem('mobileNumber');
    print('--------------->$mobileNumber');
    print('--------------->$senderName');

    http.Response response = await http.post(Uri.parse(Group_List), body: {
      'uid': "$mobileNumber",
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });
    responseStatusCode = response.statusCode;
    print(response.body);
    var Data = jsonDecode(response.body);
    // var Data = d1;
    print(Data);
    print(Data.length);
    // var ;
    if (Data != null || Data != []) {
      for (var i = 0; i < Data.length; i++) {
        GroupNames.add(Data[i]['groupname']);
        GroupImages.add(Data[i]['groupimage']);
        GroupKey.add(Data[i]['groupkey']);
        GroupCreated.add(Data[i]['groupcreated']);
      }
    }
    print('--------->$GroupNames');
    print('--------->$GroupKey');
    setState(() {
      GroupName_Length = GroupNames.length;
      print('--------->$GroupName_Length');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1)),
        builder: ((context, snapshot) {
          if (responseStatusCode == 200) {
            return ListView.separated(
                shrinkWrap: true,
                itemCount: GroupName_Length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => groupChat(
                                  mobileNumber: mobileNumber,
                                  senderName: senderName,
                                  GroupNames: GroupNames[index],
                                  GroupKey: GroupKey[index],
                                  GroupImages: GroupImages[index])));
                    },
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: GroupImages[index],
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
                    // leading: CircleAvatar(
                    //     // radius: 25,
                    //     backgroundColor: Colors.grey.withOpacity(0.1),
                    //     backgroundImage:
                    //         ,
                    title: Text(GroupNames[index]),
                    subtitle: Text(GroupCreated[index]),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.ntfctnCnt,
                        const SizedBox(
                          height: 5,
                        ),
                        widget.msgdte$tme
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
