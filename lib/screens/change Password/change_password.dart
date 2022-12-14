// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:linkus/screens/Login%20Files/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../variables/Api_Control.dart';
import '../Login Files/login_textfield.dart';
import 'package:http/http.dart' as http;
//123456789

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var oldPassword = TextEditingController();
  var newPassword = TextEditingController();
  var cnfrmPassword = TextEditingController();
  var number;
  @override
  void initState() {
    Data();
    super.initState();
  }

  Data() async {
    final prefs = await SharedPreferences.getInstance();
    number = prefs.getString('mobileNumber');
    oldpwd = prefs.getString('password');
    print("yyyyy----$oldpwd");
    print('mobileNumber:::::$number');
  }

//////////////////////
  var oldpwd;
  new_pwrd() async {
    Map data = {
      "password": cnfrmPassword.text,
      "mobile": number,
    };
    print(data);
    String body = json.encode(data);
    print(body);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (bc) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    var response = await http.post(
      Uri.parse(new_password),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    );
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                  title: const Text(
                    'Password Updated Successfully',
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  content: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "OK",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              const LoginScreen(),
                        ),
                        (route) => false,
                        //if you want to disable back feature set to false
                      );
                      oldPassword.clear();
                      newPassword.clear();
                      cnfrmPassword.clear();
                    },
                  )));
        });

    // var res = jsonDecode(response.body);
    print("ans---------${response.body}");
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 123, 255, 1),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _form,
          child: Column(
            children: [
              MasterTextField(
                hintText: "Old Password",
                Controller: oldPassword,
                PrefixIcon: const Icon(
                  Icons.key,
                  color: Colors.grey,
                ),
                obscureText: true,
                keyboardType: null,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                enabledborder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: null,
                filled: false,
                focusedborder: null,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              MasterTextField(
                  hintText: "New Password",
                  Controller: newPassword,
                  PrefixIcon: const Icon(
                    Icons.key,
                    color: Colors.grey,
                  ),
                  obscureText: true,
                  keyboardType: null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  enabledborder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  fillColor: null,
                  filled: false,
                  focusedborder: null,
                  Validate: (val) {
                    if (val.isEmpty) {
                      return "Please Enter Confirm Password";
                    } else {
                      return null;
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              MasterTextField(
                  hintText: "Confirm Password",
                  Controller: cnfrmPassword,
                  PrefixIcon: const Icon(
                    Icons.key_rounded,
                    color: Colors.grey,
                  ),
                  obscureText: true,
                  keyboardType: null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  enabledborder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  fillColor: null,
                  filled: false,
                  focusedborder: null,
                  Validate: (val) {
                    if (val != newPassword) {
                      return "Password must be same as above";
                    } else {
                      return null;
                    }
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color(0xff2b3d6b);
                              }
                              return const Color(0xff2b3d6b);
                            },
                          ),
                        ),
                        onPressed: () {
                          if (oldPassword.text == '' &&
                              newPassword.text == '' &&
                              cnfrmPassword.text == '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                          title: const Text(
                                            'Please Enter  Your Password',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          content: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )));
                                });
                          } else if (oldPassword.text != '' &&
                              newPassword.text == '' &&
                              cnfrmPassword.text == '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                          title: const Text(
                                            'Please Enter  New Password',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          content: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )));
                                });
                          } else if (oldPassword.text != '' &&
                              newPassword.text != '' &&
                              cnfrmPassword.text == '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                          title: const Text(
                                            'Please Enter  Confirm Password',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          content: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )));
                                });
                          } else if (oldPassword.text != '' &&
                              newPassword.text == '' &&
                              cnfrmPassword.text != '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                          title: const Text(
                                            'Please Enter  New Password',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          content: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )));
                                });
                          } else if (oldPassword.text == '' &&
                              newPassword.text != '' &&
                              cnfrmPassword.text != '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                          title: const Text(
                                            'Please Enter  Your Old Password',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          content: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )));
                                });
                          } else if (oldPassword.text == '' &&
                              newPassword.text != '' &&
                              cnfrmPassword.text == '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                          title: const Text(
                                            'Please Enter Your Password',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          content: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )));
                                });
                          } else if (oldPassword.text == '' &&
                              newPassword.text == '' &&
                              cnfrmPassword.text != '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                          title: const Text(
                                            'Please Enter your Password',
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          content: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )));
                                });
                          } else if (oldPassword.text != '' &&
                              newPassword.text != '' &&
                              cnfrmPassword.text != '') {
                            print("xxxx----$oldpwd");
                            if (oldPassword.text == oldpwd) {
                              if (newPassword.text == cnfrmPassword.text) {
                                new_pwrd();
                              } else {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WillPopScope(
                                          onWillPop: () async => false,
                                          child: AlertDialog(
                                              title: const Text(
                                                'Password Mismatch',
                                                style: TextStyle(
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                              content: TextButton(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: const [
                                                    Text(
                                                      "OK",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )));
                                    });
                              }
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                        onWillPop: () async => false,
                                        child: AlertDialog(
                                            title: const Text(
                                              ' Invalid Old Password ',
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16),
                                            ),
                                            content: TextButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: const [
                                                  Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )));
                                  });
                            }
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
