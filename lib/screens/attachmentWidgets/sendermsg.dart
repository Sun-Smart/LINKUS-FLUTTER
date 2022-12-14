import 'package:flutter/material.dart';

class SenderMessageItem extends StatefulWidget {
  const SenderMessageItem(
      {required this.sentByMe,
      required this.message,
      this.path,
      required this.senttime,
      required this.MsgSeen,
      required this.sndBy,
      required this.MobileNumber})
      : super();
  final bool sentByMe;
  final String message;
  final String senttime;
  final String? path;
  final String? sndBy;
  final MobileNumber;
  final MsgSeen;

  @override
  State<SenderMessageItem> createState() => _SenderMessageItemState();
}

class _SenderMessageItemState extends State<SenderMessageItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 100, right: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding: EdgeInsets.only(bottom: 0, top: 5, left: 10, right: 5),
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: (Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "${widget.message.toString()}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 3,
                      // right: 5,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${widget.senttime}",
                          style: TextStyle(
                              fontSize: 10,
                              color: (widget.sentByMe
                                      ? Colors.white
                                      : Colors.white)
                                  .withOpacity(0.7)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        // widget.MsgSeen
                        // ?
                        Icon(
                          Icons.done_all,
                          color: Colors.white,
                          size: 14,
                        )
                        // : Icon(
                        //     Icons.done,
                        //     size: 14,
                        //     color: Colors.black,
                        //   )
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
