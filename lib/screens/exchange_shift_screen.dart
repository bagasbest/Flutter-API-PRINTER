import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/themes.dart';
import 'login_screen.dart';

class ExchangeShiftScreen extends StatefulWidget {
  final List user;

  ExchangeShiftScreen({
    required this.user,
  });

  @override
  State<ExchangeShiftScreen> createState() => _ExchangeShiftScreenState();
}

class _ExchangeShiftScreenState extends State<ExchangeShiftScreen> {
  var openingBalance = TextEditingController();
  var closingBalance = TextEditingController();
  var actualClosingBalance = TextEditingController();
  var remark = TextEditingController();
  var isEmptyActualClosingBalance = true;
  var isEmptyRemark = true;
  var _isChecked = false;

  @override
  void initState() {
    super.initState();
    openingBalance.text = "100005";
    closingBalance.text = "899006";
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('End Shift'),
        ),
        body: SingleChildScrollView(
          child: Container(
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
                    'End Shift',
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Text(
                          'Pretty Cash',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
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
                            color: (Colors.green[100])!,
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
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Opening Balance',
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                            color: Colors.grey[300]
                                        ),
                                        child: TextFormField(
                                          controller: openingBalance,
                                          keyboardType: TextInputType.number,
                                          enabled: false,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Closing Balance',
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          color: Colors.grey[300]
                                        ),
                                        child: TextFormField(
                                          controller: closingBalance,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Actual Closing Balance',
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        child: TextFormField(
                                          controller: actualClosingBalance,
                                          keyboardType: TextInputType.number,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            hintText: 'Input Actual Closing Balance',
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      (!isEmptyActualClosingBalance)
                                                          ? Colors.green
                                                          : Colors.red,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                          ),
                                          onChanged: (val) {
                                            if (val.isEmpty) {
                                              setState(() {
                                                isEmptyActualClosingBalance =
                                                    true;
                                              });
                                            } else {
                                              setState(() {
                                                isEmptyActualClosingBalance =
                                                    false;
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: TextField(
                                      maxLines: 5,
                                      controller: remark,
                                      decoration: InputDecoration(
                                        hintText: "Input Remark",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _isChecked = value!;
                                          });
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Close Sales Period ',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            convertDate(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (!isEmptyActualClosingBalance &&
                                          remark.text != "") {
                                        toast('Confirmed');
                                      } else {
                                        toast(
                                            'Please fill Actual Closing Balance and Remark!');
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xff4473a3)),
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            'Confirm',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertDate() {
    var date = widget.user[0]["BusinessDate"];
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
    return formattedDate;
  }
}
