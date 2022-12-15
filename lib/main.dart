// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:linkus/screens/Landing%20Files/LandingScreen.dart';
import 'package:linkus/screens/Login%20Files/loginscreen.dart';
import 'package:linkus/screens/chatscreen%20Files/cameraPage.dart';
import 'package:linkus/variables/Api_Control.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Status(String status) async {
    Map data = {"compid": "1", "status": status};
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
  }

  var data;
  dataCheck() async {
    final prefs = await SharedPreferences.getInstance();
    data = prefs.getString('mobileNumber');
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Status("online");
    } else {
      Status("offline");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Link Us',
        home: data == null ? const LoginScreen() : const landingPage());
  }
}
