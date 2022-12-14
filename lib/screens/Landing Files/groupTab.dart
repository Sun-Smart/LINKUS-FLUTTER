// ignore_for_file: prefer_const_constructors, camel_case_types, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:linkus/screens/chatscreen%20Files/NewGroup.dart';
import 'package:linkus/variables/Api_Control.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'widgets.dart';

class groupTab extends StatefulWidget {
  const groupTab({
    super.key,
  });

  @override
  State<groupTab> createState() => _groupTabState();
}

class _groupTabState extends State<groupTab> {
  var text;
  var mobileNumber;
  var senderName;
  var GroupNames = [];
  var GroupImages = [];
  var GroupCreated = [];
  var GroupKey = [];
  var GroupName_Length;
  var responseStatusCode;
  var Data = [];
  var time = [];

  @override
  void initState() {
    super.initState();
    LoadGroupData();
  }

  LoadGroupData() async {
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
    responseStatusCode = response.statusCode;
    print(response.body);

    Data = jsonDecode(response.body);
    // Data = Data.sort((a, b) => {

    // })
    // Data.sort((a, b) {

    // })
    //Data.sort();
// var getdata= Data;
    //  var getdta;
    //     getdta = Data;
      Data.sort((a, b) => a['groupname'].toLowerCase().compareTo(b['groupname'].toLowerCase()));
    print('testing,${Data}');
    //  DateTime.fromMillisecondsSinceEpoch(weatherData['daily'][i]['dt'].toInt() * 1000)
    // Data.sort((a, b) {
    //   print("${a}, ${b}");
    //   return a;
      
    //   // var c =
    //   //     DateTime.fromMillisecondsSinceEpoch(a['timestamp'].toInt()*1000);
    //   // var d =
    //   //     DateTime.fromMillisecondsSinceEpoch(b['timestamp'].toInt()*1000);
    //   // return c.isBefore(d) ? 1 : -1;
    // });
    print('testing2,${Data}');
//  Data.sort((a, b) {
//         var c = int.parse(DateTime.parse(a.timestamp).toString());
//        var d = int.parse(DateTime.parse(b.timestamp).toString());
//          return c -d;
//        });
    //print("5555555555$getdata");
    // var Data = d1;
    print("-------------${Data}");
    print(Data.length);
    // var ;
    GroupImages.clear();
    GroupNames.clear();
    GroupKey.clear();
    GroupCreated.clear();

    if (Data != null || Data != []) {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch);
      var format = DateFormat().format(date);

      for (var i = 0; i < Data.length; i++) {
        //  for (var i =  Data.length-1; i >= 0; i--) {
        GroupNames.add(Data[i]['groupname']);
        GroupImages.add(Data[i]['groupimage']);
        GroupKey.add(Data[i]['groupkey']);
        GroupCreated.add(Data[i]['groupcreated']);
        time.add(Data[i]['timestamp']);
      }

      //  Data.sort((a, b) {
      //   var c = int.parse(DateTime.parse(a.timestamp).toString());
      //   var d = int.parse(DateTime.parse(b.timestamp).toString());
      //   return c < d ? 1 : -1;
      // });

//      Data.sort((a, b) {
//         // var c =int.parse(a['timestamp']);
//         // var d = int.parse(b['timestamp']);
//         //return c < d ? 1 : -1;
//         var c = DateFormat('YYYY').format(a['timestamp']).toString();
//         var d = DateFormat('YYYY').format(b['timestamp']).toString();

//       return -c.compareTo(d);

//       });

    }

    print('--------->${GroupNames.length}');
    print('--------->${GroupKey.length}');
    setState(() {
      GroupName_Length = GroupNames.length;
      print('--------->$GroupName_Length');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Card(
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    await Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => NewGroup(
                          hidegroupname: "",
                        ),
                      ),
                      // (route) => true,
                      //if you want to disable back feature set to false
                    );
                    print("Back from page");
                    setState(() {
                      LoadGroupData();
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_circle),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Create Group'),
                        ],
                      ),
                    ),
                  ),
                ))),
        GroupChatList(
          GroupCreated: GroupCreated,
          GroupImages: GroupImages,
          GroupKeys: GroupKey,
          mobileNumber: mobileNumber,
          senderName: senderName,
          GroupNames: GroupNames,
          //time: DateTime.now().millisecondsSinceEpoch.,
          onTap: () {},
          profIcon: Icon(Icons.group),
          msgText: null,
          msgdte$tme: Text(''),
          ntfctnCnt: Text(''),
          contactName: Text(
            'MySkillTree Developement',
          ),
          ItmCnt: 50,
        )
      ],
    );
  }
}
