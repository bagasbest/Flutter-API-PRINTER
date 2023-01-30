import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../utils/themes.dart';
import 'package:flutter/services.dart';

class ReprintReceiptPDF extends StatefulWidget {
  final List user;
  final List sendDataList;
  final String increment;

  ReprintReceiptPDF(
      {required this.user,
      required this.sendDataList,
      required this.increment});

  @override
  State<ReprintReceiptPDF> createState() => _ReprintReceiptPDFState();
}

class _ReprintReceiptPDFState extends State<ReprintReceiptPDF> {
  final pdf = pw.Document();
  var image;
  var f = new NumberFormat.currency(
      locale: "id_ID", symbol: "Rp ", decimalDigits: 0);

  void initState() {
    getImage();
    super.initState();
  }

  getImage() async {
    image = (await rootBundle.load('assets/icon.jpg')).buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text('Save PDF'),
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
              pw.ListView.builder(
                  itemCount: widget.sendDataList.length,
                  itemBuilder: (context, index) {
                    return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          (index == 0)
                              ? pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                  pw.Image(
                                    pw.MemoryImage(image),
                                    height: 50,
                                    width: 50,
                                  ),
                                  pw.SizedBox(height: 16),
                                  pw.Text(
                                    'PT. Berca Sportindo',
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000)),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                  pw.Text(
                                    '              NPWP: 01.554.599.9-071.000              ',
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000)),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                  pw.SizedBox(
                                    height: 16,
                                  ),
                                  pw.Text(
                                    widget.user[0]["SiteName"],
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000)),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                  pw.SizedBox(
                                    height: 16,
                                  ),
                                ])
                              : pw.Container(),
                          pw.Container(
                              width: 250,
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    (index == 0)
                                        ? pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                                pw.Row(children: [
                                                  pw.Text(
                                                    '[RESTRUCK]',
                                                    style: pw.TextStyle(
                                                        fontSize: 12,
                                                        color: PdfColor.fromInt(
                                                            0xff000000)),
                                                  ),
                                                ]),
                                                pw.Text(
                                                    '--------------------------------------------------------------',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                  'RECEIPT NO: ${widget.user[0]["Code"]}${getTodayDate()}${widget.increment}',
                                                  style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000)),
                                                ),
                                                pw.Text(
                                                    '--------------------------------------------------------------',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                  'Description(s)',
                                                  style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000)),
                                                ),
                                                pw.Text(
                                                    '--------------------------------------------------------------',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                              ])
                                        : pw.Container(),
                                    pw.Text(
                                      'Code: ${widget.sendDataList[index]['productCode']}',
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          color: PdfColor.fromInt(0xff000000)),
                                    ),
                                    pw.Text(
                                      'Name: ${widget.sendDataList[index]['productName']}',
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          color: PdfColor.fromInt(0xff000000)),
                                    ),
                                    pw.Text(
                                      'Price: ${f.format(widget.sendDataList[index]['lineTotal'])}',
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          color: PdfColor.fromInt(0xff000000)),
                                    ),
                                    pw.SizedBox(height: 16),
                                    (index == widget.sendDataList.length-1)
                                        ? pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                                pw.Text(
                                                    '--------------------------------------------------------------',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    'Sub Total: ${f.format(widget.sendDataList[0]['docTotal'])}',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    '--------------------------------------------------------------',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    'Grand Total:${f.format(widget.sendDataList[0]['docTotal'])}',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    '--------------------------------------------------------------',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    'Cashier: ${widget.user[0]['UserName']}',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.SizedBox(height: 16),
                                              ])
                                        : pw.Container(),
                                  ])),
                          (index == widget.sendDataList.length-1)
                              ? pw.Column(children: [
                                  pw.Text(
                                      '--------------------------------------------------------------',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('Garansi produk tidak berlaku',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('untuk produk sepatu promo',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('Special Price (SP) dengan harga',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('Rp 199.000 kebawah',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text(
                                      '--------------------------------------------------------------',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('-- Terima Kasih --',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('Harga termasuk PPN',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('Special Price (SP) dengan harga',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('Barang yang sudah dibeli',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text('Tidak dapat Dikembalikan/Ditukar',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                  pw.Text(
                                      '--------------------------------------------------------------',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        color: PdfColor.fromInt(0xff000000),
                                      ),
                                      textAlign: pw.TextAlign.center),
                                ])
                              : pw.Container(),
                        ]);
                  }),
            ]));
    // }

    return doc.save();
  }

  String getTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyy');
    return formatter.format(now);
  }
}
