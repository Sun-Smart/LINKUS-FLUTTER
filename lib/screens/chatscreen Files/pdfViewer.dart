// ignore_for_file: file_names, avoid_print, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenPdf extends StatefulWidget {
  final String PdfPath;
  OpenPdf({super.key, required this.PdfPath});

  @override
  State<OpenPdf> createState() => _OpenPdfState();
}

class _OpenPdfState extends State<OpenPdf> {
  @override
  Widget build(BuildContext context) {
    print("+***+*+*+*+*+*+*+*+*+*+*+*+**+*+*+*+*+*+*+*+*+${widget.PdfPath}");
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ]),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: SfPdfViewer.network(
              'https://prod.herbie.ai:8153/uploadFiles/${widget.PdfPath.toString()}'),
        ),
      ),
    );
  }
}
