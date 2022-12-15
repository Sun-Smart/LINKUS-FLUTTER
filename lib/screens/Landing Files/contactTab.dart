// ignore_for_file: duplicate_import, camel_case_types, file_names, prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables, await_only_futures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:linkus/screens/chatscreen%20Files/dataList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linkus/variables/Api_Control.dart';
import 'allcontacts.dart';
import 'liveContacts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class contactsTab extends StatefulWidget {
  final mobileNumber;
  contactsTab({
    super.key,
    this.mobileNumber,
  });

  @override
  State<contactsTab> createState() => _contactsTabState();
}

class _contactsTabState extends State<contactsTab> {
  int index = 0;
  var buddyId = [];
  int listlength = 0;
  int length = 0;
  var companyid;

  @override
  void initState() {
    super.initState();

    Data();
    contactList.clear();
    liveItems.clear();
  }

  Data() async {
    final prefs = await SharedPreferences.getInstance();

    companyid = await prefs.getString('compid');
    Map data = {"compid": companyid};
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

    Contactmodel.add((jsonDecode(response.body)));
    var responseOfStatusCode1 = response.statusCode;
    print('{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{{}{}$responseOfStatusCode1');

    // print('++++++++++++++++++++++++++++++++++++>>>>>>>$responseOfStatusCode');
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      responseOfStatusCode = responseOfStatusCode1;
      print('++++++++++++++++++++++++++++++++++++>>>>>>>$responseOfStatusCode');
      buddyId.add(jsonDecode(response.body)[i]['mobile']);
      if (jsonDecode(response.body)[i]["status"] == "online" ||
          jsonDecode(response.body)[i]["status"] == "Offline" ||
          jsonDecode(response.body)[i]["status"] == "offline") {
        contactList.add(Employee(
          id: i + 1,
          Name: jsonDecode(response.body)[i]['username'] ?? "",
          jobProfile: jsonDecode(response.body)[i]['designation'] ?? "",
          photourl: jsonDecode(response.body)[i]["photourl"] ?? "",
          isChecked: false,
          status: jsonDecode(response.body)[i]["status"] ?? "",
        ));
      }
      if (jsonDecode(response.body)[i]["status"] == "online") {
        liveItems.add(Employee(
            id: i + 1,
            Name: jsonDecode(response.body)[i]['username'] ?? "",
            jobProfile: jsonDecode(response.body)[i]['designation'] ?? "",
            photourl: jsonDecode(response.body)[i]["photourl"] ?? "",
            isChecked: false,
            status: jsonDecode(response.body)[i]["status"] ?? "",
            responseOfStatusCode: responseOfStatusCode));

        print("res------$length");
      }

      // print("ans----$listlength");
      // print("xyz---$length");
    }

    setState(() {
      listlength = contactList.length;
      length = liveItems.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: TabBar(tabs: [
            SizedBox(
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'All contacts($listlength)',
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Live Contact($length)',
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            Tab(
              icon: allContacts(
                mobileNumber: widget.mobileNumber,
                buddyId: buddyId,
              ),
            ),
            const Tab(icon: liveContacts()),
          ],
        ),
      ),
    );
  }
}
