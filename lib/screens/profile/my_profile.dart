// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:linkus/variables/Api_Control.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dropdown.dart';
import 'dropdown_tone.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback apidata;
   ProfilePage({Key? key,required this.apidata}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => MyProfileData());
      super.initState();
    });
  }

  var name;
  var employee;
  var gender;
  var mobile;
  var email;
  var designation;
  var department;
  var branchname;
  var photourl;
  var marital;
  var mob;
   var profile_path;

  MyProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    mob = prefs.getString('mobileNumber');
    showDialog(
        context: context,
        builder: (bc) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });

    Map data = {
      "mobile": mob,
    };
    print(data);
    String body = json.encode(data);
    print(body);

    var response = await http.post(
      Uri.parse(MyProfile_Api),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    );
    print("result:${response.body}");

    if (response.statusCode == 200) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pop(context);
        var ProfileModel = json.decode(response.body);
        for (var i = 0; i < ProfileModel.length; i++) {
          employee = ProfileModel[i]["employee"].toString();

          name = ProfileModel[i]["username"].toString();
          gender = ProfileModel[i]["gender"].toString();
          mobile = ProfileModel[i]["mobile"].toString();
          email = ProfileModel[i]["email"] ?? ''.toString();
          designation = ProfileModel[i]["designation"].toString();
          department = ProfileModel[i]["department"].toString();
          branchname = ProfileModel[i]["branchname"].toString();
          photourl = ProfileModel[i]["photourl"].toString();
          marital = ProfileModel[i]["marital"].toString();
          if (marital == 'undefined') {
            marital = "select";
          } else {
            marital = marital;
          }
        }
        setState(() {});
      });
    }
  }

updateimage(String path,mobile)async {
print("-------path---------${path.split("/").last}");
    
 Map data= {
               "photourl":path,
                "mobile":mobile
            };
            print("datatatatat----$data");
              http.Response response = await http.post(Uri.parse(recentchatprofileupdate), body: data);
              print("response---------${response.body}");
              if(response.statusCode==200){
              http.Response response = await http.post(Uri.parse(updateuser_image), body: data);  
                print("response-111--------${response.body}");
                MyProfileData();
              }
              

}
 crypto(plainText) {
    var encoded1 = base64.encode(utf8.encode(plainText));
    return encoded1;
  }
  onImageSend(String path,String name ) async {
   
    var request = http.MultipartRequest('POST', Uri.parse(uploadImage));
    print("#######profile#################$request");
    request.files.add(await http.MultipartFile.
    fromBytes(
        "img", File(path).readAsBytesSync(),
        filename: path.split("/").last,
        
        // "img", path,
       
        )
        
        );
        var res = await request.send();
       
        updateimage("https://prod.herbie.ai:8153/uploadFiles/${name}", mob);
         
        }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          leadingWidth: 30,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
              ),
              onPressed: () {
                setState(() {
                   widget.apidata;
                });
             
                Navigator.pop(context);
              }),
          backgroundColor: const Color.fromRGBO(1, 123, 255, 1),
          title: const Text(" My Profile"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  CircleAvatar(
                   radius: 60,
                   
                    child: ClipOval(
                      child: CachedNetworkImage(
                           width: MediaQuery.of(context).size.width/2,
                           height: MediaQuery.of(context).size.height/2,
            fit: BoxFit.cover,
                        //  fit: BoxFit.fitWidth,
                        imageUrl: photourl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
               Positioned(
                left: 80,
                top: 90,
                child:InkWell(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(0.7)
                    ),
                    child: Icon(Icons.camera_alt,size: 15,color: Colors.white,),
                  ),
                  onTap: (){
  showAlertDialog(context) ;

                  
   } ),
                )
               
                ],
              ),
              // Center(
              //   child: CircleAvatar(
              //       radius: 60,
              //       backgroundColor: Colors.grey,
              //       backgroundImage: NetworkImage(photourl ?? '')),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                children: [
                  const Text(
                    "Employee Code :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    employee ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    "Name :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    name ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    "Gender :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    gender ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  Text(
                    "Marital Status :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Dropdown_gender(
                    marital_status: marital,
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    "Mobile :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    mobile ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    "Email :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    email ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    "Designation :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    designation ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    "Department :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    department ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    "Branch Name:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    branchname ?? ''.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: const [
                  Text(
                    "Change Tone :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  DropDownTone(),
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ],
          ),
        )));
  }
  showAlertDialog(BuildContext context) {  
  // Create button  
 
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
   shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    
    title: Column(
  
      children: [
        
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                InkWell(
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.camera_alt_rounded,
                    color: Colors.white,size: 20,),
                  ),
                  onTap: ()async{
           
         _pickFile(context);
        Navigator.pop(context);
         
       },
                ),
                 SizedBox(height: 10,),
                Text("Gallery",
                   style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),)
              ],
            ),
         
            Column(
              children: [
                InkWell(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.remove_circle_outline,
                    color: Colors.white,
                    size: 20,),
                  ),
                  onTap: (){
       
         
       },
                ),
                 SizedBox(height: 10,),
                Text("Remove",
                   style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),)
              ],
            ),
            Column(
              children: [
                InkWell(
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close,
                    color: Colors.white,
                    size: 20),
                  ),
                  onTap: ()async{
       
         Navigator.pop(context);
         
       },
                ),
                SizedBox(height: 10,),
                Text("Cancel",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
               )
              ],
            ),
           
          ],
        ),
    ],
    ),  
   // content: Text(""),  

  );  
  
  // show the dialog  
  showDialog(  
    barrierDismissible: false,
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
 
 Future _pickFile(BuildContext context) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false,
    );
     profile_path = result!.files.first.path;
    var name=result.files.first.name;

    print("-----path,,,,,name---------${profile_path},,,,,${name}");
     
onImageSend(profile_path,name);
  
    //updateimage(profile_path,mob);
   
  

    



    // final path =
    // join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (builder) => CameraViewPage(
    //       path: path.toString(),
    //       // result.path,
    //       OnImagesend: widget.onsentimage,
    //     ),
    //  ),
   // );
  }

}
