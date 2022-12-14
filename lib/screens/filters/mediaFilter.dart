// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';

import '../mainmenu/calendar/date_time.dart';

class FileFilter extends StatefulWidget {
  const FileFilter({super.key});

  @override
  State<FileFilter> createState() => _FileFilterState();
}

class _FileFilterState extends State<FileFilter> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Media'),
        ),
        body: Container(
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    // height: MediaQuery.of(context).size.height / 2,
                    child: CalenderWidget(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        hintText: "",
                        icon: Icons.arrow_drop_down,
                        firstDate: DateTime.now(),
                        LastDate: DateTime.now()),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    // height: MediaQuery.of(context).size.height / 2,
                    child: CalenderWidget(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        hintText: "",
                        icon: Icons.arrow_drop_down,
                        firstDate: DateTime.now(),
                        LastDate: DateTime.now()),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 90, left: 20),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: 'Search'),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      iconSize: 40,
                    )
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
