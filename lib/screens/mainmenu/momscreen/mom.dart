// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:linkus/screens/Login%20Files/login_textfield.dart';
import 'package:linkus/screens/chatscreen%20Files/NewGroup.dart';

class MOM extends StatefulWidget {
  const MOM({super.key});

  @override
  State<MOM> createState() => _MOMState();
}

class _MOMState extends State<MOM> {
  var conclus = TextEditingController();
  var discus = TextEditingController();
  var agenda = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          leadingWidth: 35,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.arrow_back,
                  size: 25,
                ),
              )),
//changed Something
          backgroundColor: Color.fromRGBO(1, 123, 255, 1),
          title: Text(
            " Minutes Of Meeting",
            style: TextStyle(letterSpacing: 1),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Meeting Called by :",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Text(
                          "Please Select",
                          style: TextStyle(
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewGroup()));
                        },
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Text(
                        "Agenda :",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: MasterTextField(
                          Controller: agenda,
                          PrefixIcon: null,
                          hintText: '',
                          focusedborder: InputBorder.none,
                          keyboardType: null,
                          contentPadding: null,
                          enabledborder: InputBorder.none,
                          filled: false,
                          fillColor: null,
                          obscureText: false,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Text(
                        "Attendees :",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Text(
                          "Please Select",
                          style: TextStyle(
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewGroup()));
                        },
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Text(
                        "Discussion :",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: MasterTextField(
                          Controller: discus,
                          PrefixIcon: null,
                          hintText: '',
                          focusedborder: InputBorder.none,
                          keyboardType: null,
                          contentPadding: null,
                          enabledborder: InputBorder.none,
                          filled: false,
                          fillColor: null,
                          obscureText: false,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Conclusion :",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: MasterTextField(
                          Controller: conclus,
                          PrefixIcon: null,
                          hintText: '',
                          focusedborder: InputBorder.none,
                          keyboardType: null,
                          contentPadding: null,
                          enabledborder: InputBorder.none,
                          filled: false,
                          fillColor: null,
                          obscureText: false,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.blue;
                                }
                                return Colors.blue;
                              },
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "ADD",
                            style: TextStyle(letterSpacing: 1),
                          )),
                      SizedBox(
                        width: 7,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.green;
                                }
                                return Colors.green;
                              },
                            ),
                          ),
                          child: const Text(
                            "SAVE & SHARE",
                            style: TextStyle(
                                letterSpacing: 1, color: Colors.white),
                          )),
                    ],
                  )
                ]))));
  }
}
