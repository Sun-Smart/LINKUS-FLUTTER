// ignore_for_file: prefer_const_constructors, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:linkus/screens/chatscreen%20Files/NewGroup.dart';

import 'widgets.dart';

class groupTab extends StatefulWidget {
  const groupTab({
    super.key,
  });

  @override
  State<groupTab> createState() => _groupTabState();
}

class _groupTabState extends State<groupTab> {
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
                  onTap: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => NewGroup(),
                      ),
                      (route) => true,
                      //if you want to disable back feature set to false
                    );
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
          onTap: () {},
          profIcon: Icon(Icons.group),
          msgText: null,
          msgdte$tme: Text(''),
          ntfctnCnt: Text(''),
          contactName: Text(
            'MySkillTree Developement',
          ),
          ItmCnt: 30,
        )
      ],
    );
  }
}
