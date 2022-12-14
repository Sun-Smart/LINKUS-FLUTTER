// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Dropdown_gender extends StatefulWidget {
  var marital_status;
  Dropdown_gender({Key? key, this.marital_status}) : super(key: key);

  @override
  State<Dropdown_gender> createState() => _Dropdown_genderState();
}

class _Dropdown_genderState extends State<Dropdown_gender> {
  var item = [
    'Married',
    'Unmarried',
    'Single',
    'Divorced',
  ];
  String? dropdownvalue;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height/5,
      width: MediaQuery.of(context).size.width / 2.5,
      height: MediaQuery.of(context).size.height / 20,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black38,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(3))),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton(
          underline: const SizedBox(),
          // underline:Container(),
          //  validator: (value)=>value==null?'field required':null,
          dropdownColor: Colors.white,
          isExpanded: true,

          ///
          value: dropdownvalue,
          hint: Text(
            widget.marital_status ?? '',
            style: const TextStyle(color: Colors.black45, fontSize: 15),
          ),
          icon: const InkWell(
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black45,
            ),
          ),
          items: item.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
            });
          },
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
