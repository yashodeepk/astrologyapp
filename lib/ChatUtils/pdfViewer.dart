import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfViewerPage extends StatefulWidget {
  String url;
  PdfViewerPage({Key? key, required this.url})
      : super(
          key: key,
        );

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text(
            "File Viewer",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: .0,
          centerTitle: true,
        ),
        body: Container(
            child: SfPdfViewer.network(
          widget.url,
          enableDocumentLinkAnnotation: false,
        )));

    // WebView(
    //   initialUrl: widget.url,
    // )
  }
}
