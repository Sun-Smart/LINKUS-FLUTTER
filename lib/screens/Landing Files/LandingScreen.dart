// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, file_names, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:linkus/screens/mainmenu/Customization/custom_page.dart';
import 'package:linkus/screens/Landing%20Files/widgets.dart';
import 'package:linkus/screens/Login%20Files/loginscreen.dart';
import 'package:linkus/screens/mainmenu/calendar/mycalendar.dart';
import 'package:linkus/screens/mainmenu/momscreen/mom.dart';
import 'package:linkus/screens/mainmenu/project_milestone/project_page.dart';
import 'package:linkus/screens/mainmenu/shelf/shelf.dart';
import 'package:linkus/screens/mainmenu/starredscreen/starred.dart';
import 'package:linkus/screens/mainmenu/task/mytask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../variables/Api_Control.dart';
import '../birthday/birthday_page.dart';
import '../change Password/change_password.dart';
import '../profile/my_profile.dart';
import 'contactTab.dart';
import 'groupTab.dart';
import 'recentTab.dart';

class landingPage extends StatefulWidget {
  const landingPage({super.key});

  @override
  State<landingPage> createState() => _landingPageState();
}

//check now

// print(loadedData);

// var Userdata = data();

class _landingPageState extends State<landingPage> {
// var loadedData = [];
  var username;
  var designation;
  var profileImg;
  var userData;
  var mobileNumber;
  apiData() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('mobileNumber');
    print('mobileNumber:::::$mobileNumber');
    var password = prefs.getString('password');
    print('password:::::$password');
    username = prefs.getString('username');
    print('username:::::$username');
    designation = prefs.getString('designation');
    print('designation:::::$designation');
    profileImg = prefs.getString('profilepic');
    print(profileImg);
  }

  bool profImg = true;
  @override
  void initState() {
    apiData();
    // WidgetsBinding.instance.addPostFrameCallback((_) => apiData());

    super.initState();
  }

  updateStatus(
      String loginnumber, status, last_changed, deviceid) async {
    print("ssssssssssssssssssssssssss");
    var data = {
      "mobile": loginnumber.toString(),
      "status": status ?? "",
      "last_changed": last_changed.toString(),
      "deviceid": deviceid ?? ""
    };

    Response response = await post(Uri.parse(Statusupdate), body: data);
    var res = response.body;
    print("somethinng-----------------$res");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiData(),
        builder: (context, snapshot) {
          return SafeArea(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  // ignore: sort_child_properties_last
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                          backgroundColor: Color.fromRGBO(1, 123, 255, 1),
                          leading: Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 20, bottom: 10),
                            child: InkWell(
                              onTap: () async {
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        ProfilePage(apidata: apiData,),
                                  ),
                                  (route) => true,
                                  //if you want to disable back feature set to false
                                );

                                // print('********************************$UserData');
                              },
                              child: profileImg != null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: profileImg??"",
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.person,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  //show me the code
                                  //if i logout and ree login i wil get the data
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        semanticsLabel: 'Loading',
                                      ),
                                    ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  username != null
                                      ? Text(
                                          username??"".toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        )
                                      : Container(
                                          child: Text('Loading...'),
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  designation != null
                                      ? Text(
                                          designation.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        )
                                      : Container(
                                          child: Text('Loading...'),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                dividerTheme: DividerThemeData(
                                    color: Colors.black, thickness: 0.5),
                                iconTheme: IconThemeData(color: Colors.white),

                              ),
                              child: PopupMenuButton(
                                
                                  color: Color.fromRGBO(1, 123, 255, 1),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Column(children: [
                                            Container(
                                              // width:
                                              //     MediaQuery.of(context).size.width,
                                              // height: 20,
                                              child: Mainmenu(
                                                  value: 1,
                                                  text: "My Profile",
                                                  Icon: Icon(
                                                    Icons.person,
                                                    size: 15,
                                                  ),
                                                  height: 0,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator
                                                        .pushAndRemoveUntil<
                                                            dynamic>(
                                                      context,
                                                      MaterialPageRoute<
                                                          dynamic>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            ProfilePage(apidata:apiData,),
                                                      ),
                                                      (route) => true,
                                                      //if you want to disable back feature set to false
                                                    );
                                                  }),
                                            ),
                                            PopupMenuDivider(),
                                          ]),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                  value: 2,
                                                  text: "Change Password",
                                                  Icon: Icon(
                                                    Icons.key,
                                                    size: 15,
                                                  ),
                                                  height: 0,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator
                                                        .pushAndRemoveUntil<
                                                            dynamic>(
                                                      context,
                                                      MaterialPageRoute<
                                                          dynamic>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            ChangePassword(),
                                                      ),
                                                      (route) => true,
                                                      //if you want to disable back feature set to false
                                                    );
                                                  }),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 3,
                                                text: "My Calendar",
                                                Icon: Icon(
                                                  Icons.calendar_month,
                                                  size: 15,
                                                ),
                                                height: 0,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Calendar(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 4,
                                                text: "My Task",
                                                Icon: Icon(
                                                  Icons.task,
                                                  size: 15,
                                                ),
                                                height: 0.1,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MyTask(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 5,
                                                text: "My Shelf",
                                                Icon: Icon(
                                                  Icons.bookmark,
                                                  size: 15,
                                                ),
                                                height: 0,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ShelfPage(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 6,
                                                text: "MOM",
                                                Icon: Icon(
                                                  Icons.handshake_outlined,
                                                  size: 15,
                                                ),
                                                height: 0,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MOM(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 7,
                                                text: "Starred",
                                                Icon: Icon(
                                                  Icons.star,
                                                  size: 15,
                                                ),
                                                height: 0,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Starred(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 8,
                                                text: "Customization",
                                                Icon: Icon(
                                                  Icons.dashboard_customize,
                                                  size: 15,
                                                ),
                                                height: 0,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          CustomPage(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 9,
                                                text: "Birthday",
                                                Icon: Icon(
                                                  Icons.cake,
                                                  size: 15,
                                                ),
                                                height: 0,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          BirthdayPage(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                value: 10,
                                                text: "Project Milestone",
                                                Icon: Icon(
                                                  Icons.tornado,
                                                  size: 15,
                                                ),
                                                height: 0,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProjectPage(),
                                                    ),
                                                    (route) => true,
                                                    //if you want to disable back feature set to false
                                                  );
                                                },
                                              ),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                              Mainmenu(
                                                  value: 11,
                                                  text: "LogOut",
                                                  Icon: Icon(
                                                    Icons.logout,
                                                    size: 15,
                                                  ),
                                                  height: 0,
                                                  onTap: () {
                                                    

                                                    Navigator.pop(context);

                                                    showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return WillPopScope(
                                                            onWillPop:
                                                                () async =>
                                                                    false,
                                                            child: AlertDialog(
                                                              title: const Text(
                                                                'Are you sure to Logout?',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              actions: <Widget>[
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 90,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            124,
                                                                            123,
                                                                            123),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'CANCEL',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w800,
                                                                            fontSize: 15),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                      updateStatus(
                                                          mobileNumber,
                                                          "offline",
                                                          DateTime.now()
                                                              .millisecondsSinceEpoch,
                                                          "0");
                                                    });
                                                                    Navigator
                                                                        .pushAndRemoveUntil<
                                                                            dynamic>(
                                                                      context,
                                                                      MaterialPageRoute<
                                                                          dynamic>(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                LoginScreen(),
                                                                      ),
                                                                      (route) =>
                                                                          false,
                                                                      //if you want to disable back feature set to false
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 90,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            124,
                                                                            123,
                                                                            123),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w800,
                                                                            fontSize: 15),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  }),
                                              PopupMenuDivider(),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      
                            ),

                            // )
                          ],
                          bottom: const TabBar(tabs: [
                            Tab(
                                icon: Text(
                              'Recent',
                              style: TextStyle(fontSize: 18),
                            )),
                            Tab(
                                icon: Text(
                              'Contacts',
                              style: TextStyle(fontSize: 18),
                            )),
                            Tab(
                                icon: Text(
                              'Groups',
                              style: TextStyle(fontSize: 18),
                            )),
                          ])),
                      body: TabBarView(
                        children: [
                          Tab(icon: recentTab(name: username.toString(),
                         ),),
                          Tab(
                              icon: contactsTab(
                                  mobileNumber: mobileNumber.toString())),
                          Tab(icon: groupTab()),
                        ],
                      ),
                      bottomSheet: footer(),
                    ),
                  )));
        });
  }
}
