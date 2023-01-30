import 'package:bercaretailpos/screens/sales/reprint_receipt_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../utils/themes.dart';
import '../login_screen.dart';
import 'package:http/http.dart' as http;
class ReprintReceipt extends StatefulWidget {
  final List user;

  ReprintReceipt({
    required this.user,
  });

  @override
  State<ReprintReceipt> createState() => _ReprintReceiptState();
}

class _ReprintReceiptState extends State<ReprintReceipt> {
  var search = TextEditingController();
  var _visible = false;
  var isEmptySearch = true;
  var salesOrderList = [];
  var salesOrderParentList = [];

  @override
  void initState() {
    super.initState();
    // search.text = "LG09O001160602001";
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Reprint Receipt'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  'Find Sales Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.green),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: (!isEmptySearch)
                                ? Colors.green[50]
                                : Colors.grey[200],
                            border: Border.all(
                                color: (!isEmptySearch)
                                    ? Colors.green
                                    : Colors.grey,
                                width: 2),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: search,
                                keyboardType: TextInputType.text,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Input Site Key',
                                ),
                                onChanged: (val) {
                                  if (val.isEmpty) {
                                    setState(() {
                                      isEmptySearch = true;
                                    });
                                  } else {
                                    setState(() {
                                      isEmptySearch = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(2)),
                              child: InkWell(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  if (!isEmptySearch) {
                                    getAllSalesBySiteKey();
                                  } else {
                                    toast('Please input Site key!');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    /// LOADING INDIKATOR
                    (_visible)
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Visibility(
                        visible: _visible,
                        child: SpinKitRipple(
                          color: Colors.green,
                        ),
                      ),
                    )
                        : Container(),

                    (!_visible)
                        ? Container(
                      height: MediaQuery.of(context).size.height * 0.64,
                      child: ListView.builder(
                        itemCount: salesOrderParentList.length,
                        itemBuilder: (context, index) {
                          var f = new NumberFormat.currency(
                              locale: "id_ID", symbol: "Rp ", decimalDigits: 0);
                          return Column(
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 16,
                                      top: 16,
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: InkWell(
                                      onTap: () {
                                        var sendDataList = [];
                                        salesOrderList.forEach((element) {
                                          if(element["salesOrderNumber"] == salesOrderParentList[index]["salesOrderNumber"]) {
                                            sendDataList.add(element);
                                          }
                                        });

                                        Route route = MaterialPageRoute(
                                            builder: (context) => ReprintReceiptPreviewScreen(
                                                user: widget.user,
                                                sendDataList: sendDataList
                                            ));
                                        Navigator.push(context, route);

                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            'Preview',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: (Colors.green[200])!,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    "Document Number:",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  Text(
                                                    "Total:",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        0.33,
                                                    child: Text(
                                                      "${salesOrderParentList[index]["salesOrderNumber"]} ",
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                  ),
                                                  Text(
                                                    f.format(
                                                        salesOrderParentList[
                                                        index]
                                                        ["docTotal"]),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAllSalesBySiteKey() async {
    try {
      setState(() {
        _visible = true;
      });
      var url = Uri.parse(
          "https://training.bercaretail.com/erpapi/api/pos/GetSalesAll?site=${search.text}");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> products = jsonData['Data'];

        salesOrderList.clear();
        salesOrderParentList.clear();
        for (var product in products) {
          Object parent = {
            'salesOrderNumber': product['SalesOrderNumber'],
            'docTotal': int.parse(product['DocTotal']
                .toString()
                .substring(0, product['DocTotal'].toString().indexOf("."))),
          };

          Object data = {
            'salesOrderNumber': product['SalesOrderNumber'],
            'docTotal': int.parse(product['DocTotal']
                .toString()
                .substring(0, product['DocTotal'].toString().indexOf("."))),
            'lineNo': product['lineno'].toString(),
            'productCode': product['ProductCode'],
            'productName': product['ProductName'],
            'lineTotal': int.parse(product['linetotal']
                .toString()
                .substring(0, product['linetotal'].toString().indexOf("."))),
          };

          bool containsValue = salesOrderParentList.any((object) =>
          object["salesOrderNumber"] == product['SalesOrderNumber']);
          if (!containsValue) {
            salesOrderParentList.add(parent);
          }
          salesOrderList.add(data);
        }

        setState(() {
          _visible = false;
        });
      } else {
        setState(() {
          _visible = false;
        });
        toast('No Sales Order Found');
      }
    } catch (e) {
      setState(() {
        _visible = false;
      });
      print("Error $e");
    }
  }
}
