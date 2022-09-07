import 'package:flutter/material.dart';

class ShelfPage extends StatefulWidget {
  const ShelfPage({super.key});

  @override
  State<ShelfPage> createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 123, 255, 1),
        title: const Text(
          "My Shelf",
          style: TextStyle(letterSpacing: 1),
        ),
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}
