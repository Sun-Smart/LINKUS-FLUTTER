// ignore_for_file: camel_case_types, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class fileViewSender extends StatefulWidget {
  final String pathoffile;
  final String time;
  final Function OnDocssend;
  const fileViewSender(
      {super.key,
      required this.pathoffile,
      required this.OnDocssend,
      required this.time});

  @override
  State<fileViewSender> createState() => _fileViewSenderState();
}

class _fileViewSenderState extends State<fileViewSender> {
  openFie() {
    // print('pathoffile--pathoffile--$pathoffile');
    return Expanded(
      child: Text(
        widget.pathoffile,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

//  Future<void> _launchInWebViewOrVC(Uri url) async {
  @override
  Widget build(BuildContext context) {
    openFie();
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
          onTap: () {
            _launchInBrowser(Uri.parse(
              'https://prod.herbie.ai:8153/uploadFiles/${widget.pathoffile}',
            ));
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 60,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(children: [
                      const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.file_copy),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      openFie(),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.pathoffile.split(".").last.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.time,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class fileViewReciever extends StatefulWidget {
  final String pathoffile;
  final String time;
  final Function OnDocssend;
  const fileViewReciever({
    super.key,
    required this.pathoffile,
    required this.OnDocssend,
    required this.time,
  });

  @override
  State<fileViewReciever> createState() => _fileViewRecieverState();
}

class _fileViewRecieverState extends State<fileViewReciever> {
  openFie() {
    // print('pathoffile--pathoffile--$pathoffile');
    return Expanded(
      child: Text(
        widget.pathoffile,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

//  Future<void> _launchInWebViewOrVC(Uri url) async {
  @override
  Widget build(BuildContext context) {
    openFie();
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
          onTap: () {
            _launchInBrowser(Uri.parse(
              'https://prod.herbie.ai:8153/uploadFiles/${widget.pathoffile}',
            ));
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green),
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 60,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.file_copy,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        openFie(),
                      ]),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            widget.pathoffile.split(".").last.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            widget.time,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
