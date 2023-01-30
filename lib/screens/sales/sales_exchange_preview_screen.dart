import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/themes.dart';

class SalesExchangePreviewScreen extends StatefulWidget {
  final List user;
  final List sendDataList;

  SalesExchangePreviewScreen({required this.user, required this.sendDataList});

  @override
  State<SalesExchangePreviewScreen> createState() =>
      _SalesExchangePreviewScreenState();
}

class _SalesExchangePreviewScreenState
    extends State<SalesExchangePreviewScreen> {
  var docNumber = TextEditingController();
  var docTotal = TextEditingController();
  var challenge = TextEditingController();
  var remark = TextEditingController();

  var isEmptyChallenge = true;
  var isEmptyRemark = true;

  var f = new NumberFormat.currency(locale: "id_ID", symbol: "Rp ", decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    docNumber.text = widget.sendDataList[0]["salesOrderNumber"];
    docTotal.text = f.format(widget.sendDataList[0]["docTotal"]);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Exchange Sales Order'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Exchange Sales Order',
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
                  border: Border.all(
                    width: 1,
                    color: (Colors.green),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Document Number',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    color: Colors.grey[300]),
                                child: TextFormField(
                                  controller: docNumber,
                                  keyboardType: TextInputType.number,
                                  enabled: false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    color: Colors.grey[300]),
                                child: TextFormField(
                                  controller: docTotal,
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                challenge.text = "";
                                remark.text = "";
                              });
                              showCustomDialog(context);
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.change_circle_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Exchange',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.sendDataList.length,
                              itemBuilder: (context, index) {
                                var f = new NumberFormat.currency(
                                    locale: "id_ID", symbol: "Rp ", decimalDigits: 0);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Column(
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
                                        child: Text(
                                          'Code: ${widget.sendDataList[index]["productCode"]}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
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
                                        margin: EdgeInsets.only(bottom: 16),
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
                                                        "No:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        "Name:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        "Total: ",
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
                                                      Text(
                                                        "${widget.sendDataList[index]["lineNo"]}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        child: Text(
                                                          "${widget.sendDataList[index]["productName"]} ",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
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
                                                            widget.sendDataList[
                                                                    index]
                                                                ["lineTotal"]),
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
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Exchange Sales Order ${widget.sendDataList[0]["salesOrderNumber"]}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Container(
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),

                  Text(
                    'Challenge Code: ${widget.sendDataList[0]["salesOrderNumber"].toString().substring(
                          widget.sendDataList[0]["salesOrderNumber"]
                                  .toString()
                                  .length -
                              5,
                        )}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        child: TextFormField(
                          controller: challenge,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Enter Key',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: (!isEmptyChallenge)
                                      ? Colors.green
                                      : Colors.red,
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                          onChanged: (val) {
                            print(challenge.text);
                            if (challenge.text.isEmpty) {
                              setState(() {
                                isEmptyChallenge = true;
                              });
                            } else {
                              setState(() {
                                isEmptyChallenge = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Remark',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextField(
                      maxLines: 5,
                      controller: remark,
                      decoration: InputDecoration(
                        hintText: "Input Remark",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              child: Container(
                child: Center(
                    child: Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5)),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
