// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class BirthdayModel extends StatefulWidget {
  final profIcon;
  final msgText;
  final contactName;
  final ntfctnCnt;
  final msgdte$tme;
  final ItmCnt;
  final onTap;
  final btdy;

  const BirthdayModel({
    Key? key,
    required this.profIcon,
    required this.msgText,
    required this.contactName,
    required this.ntfctnCnt,
    required this.msgdte$tme,
    required this.ItmCnt,
    required this.onTap,
    required this.btdy,
  }) : super(key: key);

  @override
  State<BirthdayModel> createState() => _BirthdayModelState();
}

class _BirthdayModelState extends State<BirthdayModel> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: EmployeeModels.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  onTap: widget.onTap,
                  leading: CircleAvatar(
                    // radius: 25,
                    child: widget.profIcon,
                  ),
                  title: Text(EmployeeModels[index].Name),
                  subtitle: Text(EmployeeModels[index].btdy),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider()),
    );
  }
}

class EmployeeModel {
  int id;
  String Name;
  // am adding a field here to check the state of EmployeeModel object
  bool isChecked;
  String btdy;
  EmployeeModel({
    required this.id,
    required this.Name,
    required this.btdy,
    required this.isChecked,
  });
}

List<EmployeeModel> EmployeeModels = [
  EmployeeModel(id: 1, Name: 'Fazil', btdy: '18/8/98', isChecked: false),
  EmployeeModel(id: 2, Name: 'Ramiz', btdy: '18/8/94', isChecked: false),
  EmployeeModel(id: 3, Name: 'Muthu', btdy: '18/8/93', isChecked: false),
  EmployeeModel(id: 4, Name: 'Jeyaram', btdy: '18/8/91', isChecked: false),
  EmployeeModel(id: 5, Name: 'Prakash', btdy: '18/8/98', isChecked: false),
  EmployeeModel(id: 1, Name: 'Fazil', btdy: '18/8/98', isChecked: false),
  EmployeeModel(id: 2, Name: 'Ramiz', btdy: '18/8/94', isChecked: false),
  EmployeeModel(id: 3, Name: 'Muthu', btdy: '18/8/93', isChecked: false),
  EmployeeModel(id: 4, Name: 'Jeyaram', btdy: '18/8/91', isChecked: false),
  EmployeeModel(id: 1, Name: 'Fazil', btdy: '18/8/98', isChecked: false),
  EmployeeModel(id: 2, Name: 'Ramiz', btdy: '18/8/94', isChecked: false),
  EmployeeModel(id: 3, Name: 'Muthu', btdy: '18/8/93', isChecked: false),
  EmployeeModel(id: 4, Name: 'Jeyaram', btdy: '18/8/91', isChecked: false),
  EmployeeModel(id: 5, Name: 'Prakash', btdy: '18/8/98', isChecked: false),
];
