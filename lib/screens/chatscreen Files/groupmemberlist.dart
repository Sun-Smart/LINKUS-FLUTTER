import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkus/screens/Landing%20Files/groupTab.dart';
import 'package:linkus/screens/Login%20Files/loginscreen.dart';
import 'package:linkus/variables/Api_Control.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NewGroup.dart';

class GroupMemberList extends StatefulWidget {
  String grpkey;
  GroupMemberList({super.key, required this.grpkey});

  @override
  State<GroupMemberList> createState() => _GroupMemberListState();
}

class _GroupMemberListState extends State<GroupMemberList> {
  var name = [];
  var role = [];
  var groupmemblist = [];
  var photo = [];
  var mobile = [];
  var Loginuser;
  var admin = [];

  @override
  void initState() {
    grpmember();

    super.initState();

    print("+++++++++++GROUPKEY++++++++${widget.grpkey}");
  }
// ignore: non_constant_identifier_names

  grpmember() async {
    final prefs = await SharedPreferences.getInstance();
    Loginuser = prefs.getString('mobileNumber');
    print("----number-------$Loginuser");

    http.Response response = await http.post(Uri.parse(GroupMember), body: {
      "groupkey": widget.grpkey.toString(),
    });
    groupmemblist.clear();
    name.clear();
    photo.clear();
    mobile.clear();
    role.clear();
   

    groupmemblist = json.decode(response.body);

    groupmemblist.removeWhere((item) => item['status'] == '0');
    print("-----------$groupmemblist-------");
    groupmemblist.forEach((user) => {
          // if(user['status'].toString() == '1') {
          name.add(user['username'].toString()),
          photo.add(user["photourl"].toString()),
          role.add(user["designation"]),
          mobile.add(user["uid"].toString()),
          // }else{
          // name.add(user['username'].toString()),
          //   photo.add(user["photourl"].toString()),
          //   role.add(user["designation"]),
          //   mobile.add(user["uid"].toString()),
          // }

          //  var owner.add (user["owner"].toString()),
          // print("------------owner--------${owner.toString()}");
          // print("---------${mobile[i]},sunsmart${Loginuser}");
        });

    setState(() {});
  }

  group_admin({required String Groupkey, required String mobile}) async {
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
      "groupkey": Groupkey.toString(),
      "uid": mobile.toString(),
    };

    http.Response response =
        await http.post(Uri.parse(ChangeAdmin), body: data);

    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.pop(context);
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
                        },
                      ),
                    )
                  ]);
            });
      });
    } else {
      print("-----------Wrong----------");
    }

    grpmember();
    setState(() {});
    print("---------Data-------${data}");
    print("---------Response-------${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Group Members"),
        ),
        body: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 3)),
            builder: ((context, snapshot) {
              return groupmemblist.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(children: [
                      Expanded(
                        child: ListView.separated(
                            itemCount: groupmemblist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                  title: Text(name[index].toString(),
                                      style: TextStyle(color: Colors.black)),
                                  //
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(role[index].toString()),
                                      (groupmemblist[index]["owner"] !=
                                              "undefined")
                                          ? const Text(
                                              "Group Admin",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          : (groupmemblist[index]["owner"] ==
                                                  'undefined')
                                              ? const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                )
                                              : Container(),
                                    ],
                                  ),
                                  leading: InkWell(
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: photo[index],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.person,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      (groupmemblist[index]["owner"] ==
                                              "undefined")
                                          ? showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5.5,
                                                  color: Colors.blueAccent,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 25),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Text(
                                                                "My Options",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          InkWell(
                                                              child: Row(
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .person_add,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    'Make Group Admin',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () {
                                                                group_admin(
                                                                    Groupkey: widget
                                                                        .grpkey
                                                                        .toString(),
                                                                    mobile: mobile[
                                                                            index]
                                                                        .toString());

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                print(
                                                                    "---------${widget.grpkey.toString()},${mobile[index].toString()}");
                                                              }),
                                                          const Divider(
                                                            color: Colors.white,
                                                            thickness: 1,
                                                          ),
                                                          InkWell(
                                                            child: Row(
                                                              children: const [
                                                                Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  'Cancel',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })
                                          : null;
                                    },
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                thickness: 1,
                              );
                            }),
                      ),
                    ]);
            })));
  }
}
