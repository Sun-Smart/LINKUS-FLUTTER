// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, non_constant_identifier_names, file_names, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../chatscreen Files/dataList.dart';
import '../chatscreen Files/individualChat.dart';

class liveContacts extends StatefulWidget {
  final profIcon;
  final msgText;
  final contactName;
  final ntfctnCnt;
  final msgdte$tme;
  final ItmCnt;
  final onTap;
  const liveContacts({
    Key? key,
    this.profIcon,
    this.msgText,
    this.contactName,
    this.ntfctnCnt,
    this.msgdte$tme,
    this.ItmCnt,
    this.onTap,
  }) : super(key: key);

  @override
  State<liveContacts> createState() => _liveContactsState();
}

class _liveContactsState extends State<liveContacts> {
  final TextEditingController SearchController = TextEditingController();
  String searchString = "";
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
            child: TextFormField(
                controller: SearchController,
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    contentPadding: EdgeInsets.symmetric(vertical: 15))),
          ),
        ),
        Expanded(
          //flex: 1,
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: liveItems.length,
              itemBuilder: (BuildContext context, int index) {
                return liveItems[index]
                        .Name
                        .toString()
                        .toLowerCase()
                        .contains(searchString)
                    ? ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalChat(
                                   
                                    callback: (){},

                                        names: liveItems[index].Name,
                                        images: liveItems[index].photourl,
                                        status: liveItems[index].status, 
                                        
                                      )));
                        },
                        leading: CircleAvatar(
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: liveItems[index].photourl ?? "",
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
                        title: Text(liveItems[index].Name),
                        subtitle: Text(liveItems[index].jobProfile),
                        trailing: Column(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
              separatorBuilder: (BuildContext context, int index) {
                return liveItems[index]
                        .toString()
                        .toLowerCase()
                        .contains(searchString)
                    ? const Divider()
                    : Container();
              }),
        ),
      ],
    );
  }
}
