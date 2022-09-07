// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class PersonelOwnCard extends StatefulWidget {
  const PersonelOwnCard({
    super.key,
    required this.path,
    required this.sentByMe,
    required this.time,
  });
  final String path;
  final bool sentByMe;
  final String time;

  @override
  State<PersonelOwnCard> createState() => _PersonelOwnCardState();
}

class _PersonelOwnCardState extends State<PersonelOwnCard> {
  @override
  Widget build(BuildContext context) {
    print("ddddd-----------${widget.path}");
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 1.5,
              width: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 15, top: 3, left: 3, right: 3),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.height / 4,
                  child: Card(
                      child: Image.network(
                    'https://prod.herbie.ai:8153/uploadFiles/${widget.path}',
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                          child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null));
                    },
                    fit: BoxFit.fitWidth,
                  )),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              // left: 5,
              right: 2,
              child: Container(
                width: 65,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PersonelReplyFileCard extends StatefulWidget {
  const PersonelReplyFileCard(
      {super.key, required this.path, required this.time});
  final String path;
  final String time;
  @override
  State<PersonelReplyFileCard> createState() => _PersonelReplyFileCardState();
}

class _PersonelReplyFileCardState extends State<PersonelReplyFileCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 1.5,
              width: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.green),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 15, top: 3, left: 3, right: 3),
                child: Card(
                    child:
                        //   Text(
                        // "${widget.path.toString()}",
                        Image.network(
                  'https://prod.herbie.ai:8153/uploadFiles/${widget.path}',
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                        child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null));
                  },
                  fit: BoxFit.fitWidth,
                )),
              ),
            ),
            Positioned(
              bottom: 4,
              // left: 5,
              right: 6,
              child: Container(
                width: 65,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
