import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';


class indexess extends StatefulWidget {
  const indexess({super.key});

  @override
  State<indexess> createState() => _indexessState();
}

class _indexessState extends State<indexess> {
  final _channelController = TextEditingController();
  bool _validateError =false;
  ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}