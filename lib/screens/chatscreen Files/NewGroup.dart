// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:linkus/screens/chatscreen%20Files/dataList.dart';

import '../../variables/Api_Control.dart';

import 'package:http/http.dart' as http;

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  bool isVisible = true;
  bool AddButton = false;
  TextEditingController groupNameController = TextEditingController();
  // create_group() async {
  //   Response response = await post(Uri.parse(Create_Group), body: {
  //     {
  //       "groupcreated": "Sijin created group",
  //       "groupimage": "default",
  //       "groupkey": "e6d81658234569466bf217812cdbd2acc6e05",
  //       "groupname": "Mohamed Fazil Flutter",
  //       "groupstatus": "A",
  //       "opengroup": false,
  //       "owner": "8903725995",
  //       "status": "1",
  //       "timestamp": 1658234569466,
  //       "uid": "8903725995"
  //     }
  //   }, headers: {
  //     "Content-type": "application/x-www-form-urlencoded",
  //     "Accept": "application/json",
  //     "charset": "utf-8"
  //   });
  //   // responseStatusCode = response.statusCode;
  //   print('()()()()()()()()()(${response.body}');
  //   var Data = jsonDecode(response.body);
  //   // var Data = d1;
  //   print('()()()()()()()()()()()()()()()()$Data');
  //   print(Data.length);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 123, 255, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                for (var i = 0; i < listItems.length; i++) {
                  listItems[i].isChecked = false;
                }
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
            )),
        leadingWidth: 35,
        title: const Text('Contacts'),
        actions: [
          AddButton == true
              ? IconButton(
                  onPressed: () {
                    // create_group();
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                  ))
              : Container(),
          const SizedBox(
            width: 5,
          )
        ],
      ),
      body: NewGroupContact(
          profIcon: const Icon(Icons.person),
          msgText: null,
          contactName: null,
          ntfctnCnt: null,
          msgdte$tme: const SizedBox(),
          ItmCnt: null,
          onTap: () {}),
      bottomSheet: TextFormField(
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
            suffixIcon: isVisible
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isVisible = true;
                        for (var i = 0; i < listItems.length; i++) {
                          if (listItems[i].isChecked == true) {
                            listItems[i].isChecked = false;
                          }
                        }

                        for (var i = 0; i < listItems.length; i++) {
                          if (listItems[i].isChecked == true) {
                            listItems[i].isChecked = true;
                          } else if (listItems[i].isChecked == false) {
                            listItems[i].isChecked = true;
                          }
                        }
                        isVisible = false;
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        'Select all',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w800),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        for (var i = 0; i < listItems.length; i++) {
                          listItems[i].isChecked = false;
                        }
                        isVisible = true;
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        'Unselect all',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
            hintText: 'Type a Group Name',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
      ),
    );
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
  const NewGroupContact({
    Key? key,
    required this.profIcon,
    required this.msgText,
    required this.contactName,
    required this.ntfctnCnt,
    required this.msgdte$tme,
    required this.ItmCnt,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NewGroupContact> createState() => _NewGroupContactState();
}

class _NewGroupContactState extends State<NewGroupContact> {
  var photo;
  bool? hidephoto;
  bool checkedValue = false;
  String searchString = "";

  @override
  void initState() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => Data());
      super.initState();
    });
  }

  create_group() async {
    Response response = await post(Uri.parse(Create_Group), body: {
      "groupcreated": "Sijin created group",
      "groupimage": "default",
      "groupkey": "e6d81658234569466bf217812cdbd2acc6e05",
      "groupname": "Mohamed Fazil Flutter",
      "groupstatus": "A",
      "opengroup": false,
      "owner": "8903725995",
      "status": "1",
      "timestamp": 1658234569466,
      "uid": "8903725995"
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "charset": "utf-8"
    });
    // responseStatusCode = response.statusCode;
    print(response.body);
    var Data = jsonDecode(response.body);
    // var Data = d1;
    print(Data);
    print(Data.length);
  }

  Data() async {
    Map data = {"compid": "1"};
    print(data);
    String body = json.encode(data);
    print(body);

    var response = await http.post(
      Uri.parse(Contacts_Api),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    );
    // print("length:${(response.body).length}");
    //  print("result:${response.body}");

    Contactmodel.add((jsonDecode(response.body)));

    // print("length:${jsonDecode(response.body).length}");
    listItems.clear();
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      listItems.add(Employee(
        id: i + 1,
        Name: jsonDecode(response.body)[i]['username'] ?? "",
        jobProfile: jsonDecode(response.body)[i]['designation'] ?? "",
        photourl: jsonDecode(response.body)[i]["photourl"] ?? "",
        isChecked: false,
      ));
    }

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
        Expanded(
          child: ListView.separated(
              itemCount: listItems.length,
              itemBuilder: (BuildContext context, int index) {
                final employee = listItems[index];

                return listItems[index]
                        .Name
                        .toString()
                        .toLowerCase()
                        .contains(searchString)
                    ? CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: employee.isChecked,
                        onChanged: (newValue) {
                          setState(() {
                            employee.isChecked = newValue!;
                          });
                        },
                        title: Text(listItems[index].Name),
                        secondary: CircleAvatar(
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: listItems[index].photourl ?? "",
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
                        subtitle: Text(listItems[index].jobProfile),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
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
  }
}
