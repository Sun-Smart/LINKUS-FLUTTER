import 'package:flutter/material.dart';

class DropDownTone extends StatefulWidget {
  const DropDownTone({super.key});

  @override
  State<DropDownTone> createState() => _DropDownToneState();
}

class _DropDownToneState extends State<DropDownTone> {
  var item = ['Calling', 'Flame', 'Hello', 'Lumia'];
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

          value: dropdownvalue,
          hint: const Text(
            '-Select-',
            style: TextStyle(color: Colors.black45, fontSize: 15),
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
