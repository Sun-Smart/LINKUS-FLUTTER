import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:linkus/screens/Login%20Files/loginscreen.dart';
import 'package:linkus/screens/chatscreen%20Files/dataList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../variables/Api_Control.dart';

import 'package:http/http.dart' as http;

bool isChecked = false;
bool AddButton = false;

class NewGroup extends StatefulWidget {
  String? hidegroupname;
  String? groupKey;

  NewGroup({super.key, this.hidegroupname, this.groupKey});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  bool isVisible = true;
  bool AddButton = false;
  TextEditingController groupNameController = TextEditingController();
  @override
  void initState() {
    testArray.clear();

    super.initState();
  }

  var mobile;
  String searchString = "";
  var groupusrname;
  var groupusername;
  var mob;
  var CryptedText;
  var GroupNames = [];
  var GroupImages = [];
  var GroupCreated = [];
  var GroupName_Length;
  var grpuser;
  var responseStatusCode;
  var grpname1;
  var grpname;
  var usernames = [];
  int? memberslength;

  var responseStatus;
  crypto(plainText) {
    var encoded1 = base64.encode(utf8.encode(plainText));
    return encoded1;
  }

  ConvertingTimeStamp(senttime) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(senttime);
    var format = DateFormat().format(date);
    //var formattedTime = format.format(date);
    print("87654356798765$format");
    return format.toString();
  }

  CreateGroup() async {
    print("____________");
    CryptedText = crypto(groupNameController.text.toString());
    final prefs = await SharedPreferences.getInstance();
    groupusername = await prefs.getString('username');
    mob = prefs.getString('mobileNumber');
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    grpname1 = widget.hidegroupname;
    grpname = groupNameController.text.toString();

    Map data = {
      "uid": mob.toString(),
      "groupname": grpname.toString(),
      "groupkey": CryptedText.toString(),
      "groupimage": "default",
      "opengroup": "true",
      "timestamp": time.toString(),
      "groupstatus": "A",
      "owner": mob.toString(),
      "groupcreated": "${groupusername.toString()} created group",
      "status": "1"
    };
    print("11111111111111111111111111111111111111111$time");
    print("1122344551122334455$data");
    http.Response response = await http.post(
      Uri.parse(Create_Group),
      body: data,
      // body: {
      //   "uid": mob,
      //   "groupname": grpname.toString(),
      //   "groupkey": CryptedText.toString(),
      //   "groupimage": "default",
      //   "opengroup": "false",
      //   "timestamp": timeStamp,
      //   "groupstatus": "A",
      //   "owner":mob,
      //   "groupcreated": "${groupusername.toString()} created group",
      //   "status": "1"
      // },
    );
    print("----BODY---$time-------");

    print("**********${groupNameController.text}");
    print("++++++++++++$CryptedText");

    print("++++ertyutrertyuytr+++++${response.body}");
    //print('-------------------------${body}');

    //LoadGroupData();
    add_users();

    if (response.statusCode == 200) {
      // ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      //       const SnackBar(content: Text('Group created Successfully')));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                content: Text("Group Created Successfully"),
                actions: <Widget>[
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
                        // Navigator.pop(context);
                        //  Navigator.pop(context);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ]);
          });
    }
  }

  add_users() async {
    CryptedText = crypto(groupNameController.text.toString());
    print('''\n\n\ngroup name: ${groupNameController.text}\n
    crypted : ${CryptedText}\n\n\n''');
    print("____________${testArray.length}");
    memberslength = testArray.length;
    print("======${memberslength}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('members', memberslength.toString());

    groupusrname = await prefs.getString('username');
    mob = prefs.getString('mobileNumber');

    var time = DateTime.now().millisecondsSinceEpoch;

    var timeStamp = ConvertingTimeStamp(time);

    testArray.forEach((user) async {
      mobile = user['number'];
      grpuser = user['name'];
      print("------******-$username");

      var body = {
        "uid": mobile.toString(),
        "groupname": groupNameController.text.toString(),
        "groupkey": CryptedText.toString(),
        "groupimage": "default",
        "opengroup": "true",
        "timestamp": time.toString(),
        "groupstatus": "A",
        "groupcreated":
            "${groupusrname.toString()} added ${grpuser.toString()}",
        "status": "1"
      };
      print("000000000000000000$body");
      http.Response response = await http.post(
        Uri.parse(Create_Group),
        body: body,
      );
      print("nisha---------${response.body}");
      print("++++++Res+++${response.statusCode}");
      // statuscode= response.statusCode;
      responseStatusCode = response.statusCode;
      print("+++++Status++++${responseStatusCode}");
    });
    if (responseStatusCode == 200 || responseStatusCode == null) {
      print("---------------Good----------------");
    } else {
      print("---------------Bad----------------");
    }

    setState(() {});
    groupNameController.clear();
    testArray.clear();
  }

  add_user_to_group(
      {required String groupName,
      required String groupKey,
      required String mobile,
      required String groupusrname,
      required String grpuser}) async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var timeStamp = ConvertingTimeStamp(time);
    final prefs = await SharedPreferences.getInstance();
    groupusrname = (await prefs.getString('username'))!;
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
    var body = {
      "uid": mobile.toString(),
      "groupname": groupName.toString(),
      "groupkey": groupKey.toString(),
      "groupimage": "default",
      "opengroup": "true",
      "timestamp": time.toString(),
      "groupstatus": "A",
      "groupcreated": "${groupusrname.toString()} added ${grpuser.toString()}",
      "status": "1"
    };
    print("5555555555555$body");
    http.Response response = await http.post(
      Uri.parse(Create_Group),
      body: body,
    );
    print("12345r6t78908uiyjghv${time}");
    print("+++++++++${response.statusCode}");
    responseStatus = response.statusCode;
    print("abi---------${response.body}");
    if (responseStatus == 200) {
      print("-----------Good----------");
      // ScaffoldMessenger.maybeOf(context)
      //     ?.showSnackBar(SnackBar(content: Text('Added Successfully')));

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                content: const Text(
                  "Added Successfully",
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
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ]);
          });
    } else {
      print("-----------Wrong----------");
    }
  }

  LoadGroupData() async {
    final prefs = await SharedPreferences.getInstance();
    mob = prefs.getString('mobileNumber');

    print('--------------->$mob');

    http.Response response = await http.post(
      Uri.parse(Group_List),
      body: {
        'uid': "$mob",
      },
    );
    responseStatusCode = response.statusCode;
    print("ahaan$responseStatusCode+++++++++++++");
    print("-------++++++++++-------${response.body}");
    var Data = jsonDecode(response.body);
    // var Data = d1;
    print("nbvbcxzsdfgthgyujghfdxvcbcbn$Data");
    print(Data.length);
    // var ;
    if (Data != null || Data != []) {
      for (var i = 0; i < Data.length; i++) {
        print("ahaannn${Data[i]}");
        GroupNames.add(Data[i]['groupname']);
        GroupImages.add(Data[i]['groupimage']);
        GroupCreated.add(Data[i]['groupcreated']);
      }
    }
    print('--------->$GroupNames');
    // setState(() {
    //  // GroupName_Length = GroupNames.length;
    //   print('--------->$GroupName_Length');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(1, 123, 255, 1),
          leading: IconButton(
              onPressed: () {
                for (var i = 0; i < contactList.length; i++) {
                  contactList[i].isChecked = false;
                }
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
              )),
          leadingWidth: 35,
          title: const Text('Contacts'),
          actions: [
            Checkbox(
                checkColor: Colors.white,
                // fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                  // AddButton == true || widget.hidegroupname != ''
                  //     ? IconButton(
                  //         onPressed: () {
                  //           print(widget.hidegroupname != "");
                  //           if (widget.hidegroupname != "") {
                  //             print(testArray);
                  //             testArray.forEach((user) {
                  //               add_user_to_group(
                  //                   groupusrname: groupusrname ?? "",
                  //                   groupName: widget.hidegroupname ?? "",
                  //                   groupKey: widget.groupKey ?? "",
                  //                   grpuser: user['name'],
                  //                   mobile: user['number']);
                  //             });
                  //           } else {
                  //             CreateGroup();
                  //           }
                  //           // add_group();
                  //         },
                  //         icon: const Icon(
                  //           Icons.add,
                  //           size: 30,
                  //         ))
                  //     : Container(),
                })
          ],
        ),
        body: NewGroupContact(
            profIcon: const Icon(Icons.person),
            msgText: null,
            contactName: null,
            ntfctnCnt: null,
            msgdte$tme: const SizedBox(),
            ItmCnt: null,
            controller: groupNameController,
            onTap: () {}),
        bottomSheet: widget.hidegroupname != ''
            ? null
            : Container(
                // margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    // color: Color.fromRGBO(1, 123, 255, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 1,
                        blurRadius: 7,
                      ),
                    ]),
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80)),
                  child: TextFormField(
                    onChanged: ((value) {
                      // print('()()()()()()()()()()$value');
                      setState(() {
                        if (value == '') {
                          setState(() {
                            AddButton = false;
                          });
                        } else {
                          AddButton = true;
                        }
                      });
                    }),
                    controller: groupNameController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromRGBO(1, 123, 255, 1),
                          ), //<-- SEE HERE
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromRGBO(1, 123, 255, 1),
                          ), //<-- SEE HERE
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: isVisible
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = true;
                                    for (var i = 0;
                                        i < contactList.length;
                                        i++) {
                                      if (contactList[i].isChecked == true) {
                                        contactList[i].isChecked = false;
                                      }
                                    }

                                    for (var i = 0;
                                        i < contactList.length;
                                        i++) {
                                      if (contactList[i].isChecked == true) {
                                        contactList[i].isChecked = false;
                                        print("-------");
                                      } else if (contactList[i].isChecked ==
                                          false) {
                                        contactList[i].isChecked = true;
                                        print(
                                            "++++++${contactList[i].phonenumber}");
                                      }
                                    }
                                    isVisible = false;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    'Select all',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    for (var i = 0;
                                        i < contactList.length;
                                        i++) {
                                      contactList[i].isChecked = false;
                                      print(
                                          "------${contactList[i].phonenumber}");
                                    }
                                    isVisible = true;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Text(
                                    'Unselect all',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                        hintText: 'Type a Group Name',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20)),
                  ),
                ),
              ),
        floatingActionButton: AddButton == true || widget.hidegroupname != ''
            ? FloatingActionButton(
                // isExtended: true,
                child: Icon(Icons.add),
                backgroundColor: Color.fromRGBO(1, 123, 255, 1),
                onPressed: () {
                  setState(() {
                    print(widget.hidegroupname != "");
                    if (widget.hidegroupname != "") {
                      print(testArray);
                      testArray.forEach((user) {
                        add_user_to_group(
                            groupusrname: groupusrname ?? "",
                            groupName: widget.hidegroupname ?? "",
                            groupKey: widget.groupKey ?? "",
                            grpuser: user['name'],
                            mobile: user['number']);
                      });
                    } else {
                      CreateGroup();
                    }
                  });
                },
              )
            : Container());
  }
}

class NewGroupContact extends StatefulWidget {
  final profIcon;
  final msgText;
  final contactName;
  final ntfctnCnt;
  final msgdte$tme;
  final ItmCnt;
  final onTap;
  final controller;

  NewGroupContact(
      {Key? key,
      required this.profIcon,
      required this.msgText,
      required this.contactName,
      required this.ntfctnCnt,
      required this.msgdte$tme,
      required this.ItmCnt,
      required this.onTap,
      required this.controller})
      : super(key: key);

  @override
  State<NewGroupContact> createState() => _NewGroupContactState();
}

class _NewGroupContactState extends State<NewGroupContact> {
  var photo;
  bool? hidephoto;
  bool checkedValue = false;
  String searchString = "";

  var username;
  var mobile;
  TextEditingController groupcontoller = TextEditingController();

  @override
  void initState() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => Data());
      super.initState();
    });
  }

  Data() async {
    var response = await http.post(
      Uri.parse(Contacts_Api),
      body: {"compid": "1"},
    );
    // print("length:${(response.body).length}");
    //  print("result:${response.body}");

    Contactmodel.add((jsonDecode(response.body)));

    // print("length:${jsonDecode(response.body).length}");
    contactList.clear();
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      contactList.add(Employee(
          id: i + 1,
          Name: jsonDecode(response.body)[i]['username'] ?? "",
          jobProfile: jsonDecode(response.body)[i]['designation'] ?? "",
          photourl: jsonDecode(response.body)[i]["photourl"] ?? "",
          isChecked: false,
          phonenumber: jsonDecode(response.body)[i]['mobile']));
    }
    filterContactList = contactList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Card(
            elevation: 5,
            child: TextFormField(
                controller: groupcontoller,
                onChanged: (value) {
                  print(contactList[0].Name);
                  filtercourse(value);
                  if (filterContactList.isEmpty) {
                    filterContactList = contactList;
                    setState(() {});
                  }
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    contentPadding: EdgeInsets.symmetric(vertical: 15))),
          ),
        ),
        Expanded(
          child: ListView.separated(
              itemCount: filterContactList.length,
              itemBuilder: (BuildContext context, int index) {
                // contactList = filterContactList;

                final employee = filterContactList[index];
                return filterContactList[index]
                        .Name
                        .toString()
                        .toLowerCase()
                        .contains(searchString)
                    ? CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: employee.isChecked,
                        onChanged: (val) {
                          setState(() {
                            print('------check--------${employee.isChecked}');
                            employee.isChecked = !employee.isChecked;
                            print('------check--------${employee.isChecked}');
                            if (employee.isChecked == true) {
                              for (var i = 0; i < contactList.length; i++) {
                                if (contactList[i].phonenumber ==
                                    employee.phonenumber) {
                                  var object = {};
                                  object['name'] = employee.Name;
                                  object['number'] = employee.phonenumber;
                                  testArray.add(object);

                                  print('sdsdsd${object['number']}');
                                  print("******testarray*****${testArray}");
                                }
                              }
                            } else {
                              var object = {};
                              object['name'] = employee.Name;
                              object['number'] = employee.phonenumber;
                              testArray.removeWhere((item) =>
                                  item['number'] == object['number'] &&
                                  item['name'] == object['name']);
                              print('ttatata$testArray');
                            }
                          });
                        },
                        title: Text(filterContactList[index].Name),
                        secondary: CircleAvatar(
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: contactList[index].photourl ?? "",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        subtitle: Text(filterContactList[index].jobProfile),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                      )
                    : Container();
              },
              separatorBuilder: (BuildContext context, int index) {
                return filterContactList[index]
                        .toString()
                        .toLowerCase()
                        .contains(searchString)
                    ? Divider()
                    : Container();
              }),
        ),
      ],
    );
  }

  void filtercourse(value) {
    filterContactList = contactList
        .where((o) => o.Name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }
}
