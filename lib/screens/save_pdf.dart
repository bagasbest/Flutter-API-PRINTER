import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/themes.dart';

class Laporan extends StatefulWidget {
  final List user;
  final List sendDataList;
  final String increment;
  final int rounding;
  final double totalChanges;
  final double grandPrice;
  final List paymentList;

  Laporan({
    required this.user,
    required this.sendDataList,
    required this.increment,
    required this.rounding,
    required this.totalChanges,
    required this.grandPrice,
    required this.paymentList,
  });

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
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
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
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
                                            color:
                                                PdfColor.fromInt(0xff000000)),
                                        textAlign: pw.TextAlign.center,
                                      ),
                                      pw.Text(
                                        '              NPWP: 01.554.599.9-071.000              ',
                                        style: pw.TextStyle(
                                            fontSize: 12,
                                            color:
                                                PdfColor.fromInt(0xff000000)),
                                        textAlign: pw.TextAlign.center,
                                      ),
                                      pw.SizedBox(
                                        height: 16,
                                      ),
                                      pw.Text(
                                        widget.user[0]["SiteName"],
                                        style: pw.TextStyle(
                                            fontSize: 12,
                                            color:
                                                PdfColor.fromInt(0xff000000)),
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
                                      'Code: ${widget.sendDataList[index]['code']}',
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          color: PdfColor.fromInt(0xff000000)),
                                    ),
                                    pw.Text(
                                      'Name: ${widget.sendDataList[index]['name']}',
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          color: PdfColor.fromInt(0xff000000)),
                                    ),
                                    pw.Text(
                                      'Price: ${f.format(widget.sendDataList[index]['price'])} x ${widget.sendDataList[index]['qty']} = ${f.format(widget.sendDataList[index]["price_total"] - widget.sendDataList[index]["discount"])}',
                                      style: pw.TextStyle(
                                          fontSize: 12,
                                          color: PdfColor.fromInt(0xff000000)),
                                    ),
                                    pw.SizedBox(height: 16),
                                    (index == widget.sendDataList.length - 1)
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
                                                    'Total Qty: ${getTotalQty()}',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    'Sub Total: ${getSalesAmount()}',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    'Total Disc: ${getTotalDisc()}',
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
                                                    'Grand Total: ${getSalesAmount()}',
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
                                                pw.Text('Payment By: ',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.ListView.builder(
                                                    itemCount: widget
                                                        .sendDataList.length,
                                                    itemBuilder:
                                                        (context, indexx) {
                                                      try {
                                                        return pw.Column(
                                                            crossAxisAlignment: pw
                                                                .CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              (widget.paymentList[
                                                                              indexx]
                                                                          [
                                                                          "type"] ==
                                                                      "CARD")
                                                                  ? pw.Text(
                                                                      "${widget.paymentList[indexx]['cardType']}: ${f.format(widget.paymentList[indexx]['amount'])}",
                                                                      style: pw
                                                                          .TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: PdfColor.fromInt(
                                                                            0xff000000),
                                                                      ),
                                                                      textAlign: pw
                                                                          .TextAlign
                                                                          .center)
                                                                  : pw.Text(
                                                                      "${widget.paymentList[indexx]['type']}: ${f.format(widget.paymentList[indexx]['amount'])}",
                                                                      style: pw
                                                                          .TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: PdfColor.fromInt(
                                                                            0xff000000),
                                                                      ),
                                                                      textAlign: pw
                                                                          .TextAlign
                                                                          .center),
                                                            ]);
                                                      } catch (err) {}
                                                      return pw.Container();
                                                    }),
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
                                                    'Rounding: ${widget.rounding}',
                                                    style: pw.TextStyle(
                                                      fontSize: 12,
                                                      color: PdfColor.fromInt(
                                                          0xff000000),
                                                    ),
                                                    textAlign:
                                                        pw.TextAlign.center),
                                                pw.Text(
                                                    'Change: ${f.format(widget.totalChanges)}',
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
                          (index == widget.sendDataList.length - 1)
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

                                  (widget.grandPrice > 500000.0 && widget.sendDataList.length > 1) ?
                                      pw.Column(
                                        children: [
                                          pw.Text('Selamat!',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                color: PdfColor.fromInt(0xff000000),
                                              ),
                                              textAlign: pw.TextAlign.center),
                                          pw.Text('Anda mendapat hadiah Voucher',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                color: PdfColor.fromInt(0xff000000),
                                              ),
                                              textAlign: pw.TextAlign.center),
                                          pw.Text('Untuk pembelian produk LEAGUE',
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
                                          pw.Text('-- Voucher Payment --',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                color: PdfColor.fromInt(0xff000000),
                                              ),
                                              textAlign: pw.TextAlign.center),
                                          pw.Text('Selamat!',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                color: PdfColor.fromInt(0xff000000),
                                              ),
                                              textAlign: pw.TextAlign.center),
                                          pw.Text('Gunakan Saat Pembayaran',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                color: PdfColor.fromInt(0xff000000),
                                              ),
                                              textAlign: pw.TextAlign.center),
                                        ])
                                            : pw.Text("")
                                ])
                              : pw.Container(),
                        ]);
                  }),
            ]));

    return doc.save();
  }

  getSalesAmount() {
    var result = 0.0;
    widget.sendDataList.forEach((element) {
      result += element["price_total"] - element["discount"];
    });

    var curr = f.format(result);
    return curr;
  }

  getTotalQty() {
    var result = 0;
    widget.sendDataList.forEach((element) {
      result += int.parse(element["qty"].toString());
    });
    return result.toString();
  }

  getTotalDisc() {
    var result = 0;
    widget.sendDataList.forEach((element) {
      result += int.parse(element["discount"].toString());
    });
    return result.toString();
  }

  String getTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyy');
    return formatter.format(now);
  }
}
