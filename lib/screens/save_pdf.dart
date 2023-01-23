import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/themes.dart';

class Laporan extends StatefulWidget {
  List user = [];
  List productList = [];
  List salesmanList = [];
  List orderOwned = [];

  Laporan({
    required this.user,
    required this.productList,
    required this.salesmanList,
    required this.orderOwned,
  });

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  var image;

  ////FITUR INI BELUM SELESAI KARENA ADA ERROR

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Download Recipant'),
        ),
        body: PdfPreview(
          // maxPageWidth: 1000,
          // useActions: false,
          // canChangePageFormat: true,
          canChangeOrientation: false,
          // pageFormats:pageformat,
          canDebug: false,

          build: (format) => generateDocument(
            format,
          ),
        ),
      ),
    );
  }

  getImage() async {
    image =
        (await rootBundle.load('assets/icon.jpg')).buffer.asUint8List();
  }


  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    // for (int i = 0; i < widget.reportList.length; i++) {
    doc.addPage(pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 32,
            marginLeft: 40,
            marginRight: 32,
            marginTop: 32,
          ),
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font2,
          ),
        ),
        build: (context) => <pw.Widget>[
         pw.Column(
           crossAxisAlignment: pw.CrossAxisAlignment.start,
           children: [
             pw.Image(
               pw.MemoryImage(image),
               height: 200,
               width: 200,
             ),
           ]
         )
        ]));
    // }

    return doc.save();
  }
}
