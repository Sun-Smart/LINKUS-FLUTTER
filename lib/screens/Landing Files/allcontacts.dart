// ignore_for_file: prefer_const_constructors, camel_case_types, unused_import, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:linkus/screens/chatscreen%20Files/dataList.dart';

import '../chatscreen Files/individualChat.dart';
import 'widgets.dart';

class allContacts extends StatefulWidget {
  final buddyId;
  final mobileNumber;
  const allContacts({
    super.key,
    this.buddyId,
    this.mobileNumber,
  });

  @override
  State<allContacts> createState() => _allContactsState();
}

class _allContactsState extends State<allContacts> {
  @override
  Widget build(BuildContext context) {
    
    return allContactsList(
      buddyId: widget.buddyId,
      mobileNumber: widget.mobileNumber,
      profIcon: Icon(Icons.person),
      msgText: null,
      msgdte$tme: Text(''),
      ntfctnCnt: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.red),
      ),
      contactName: Text(
        'Developer',
      ),
      ItmCnt: 30,
    );
  }
}
