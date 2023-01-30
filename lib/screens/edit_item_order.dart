import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../utils/colors.dart';
import 'api/api.dart';
import 'login_screen.dart';
import 'model/data.dart';

class EditItemOrder extends StatefulWidget {
  List productList = [];
  List salesmanList = [];
  int index;

  EditItemOrder(
      {required this.productList,
      required this.index,
      required this.salesmanList});

  @override
  State<EditItemOrder> createState() => _EditItemOrderState();
}

class _EditItemOrderState extends State<EditItemOrder> {
  var percentStr = "";
  var amountStr = "";
  var salesman = "";
  var _searchText = TextEditingController();
  var isAmountActive = true;
  var isPercentActive = true;
  var percent = TextEditingController();
  var amount = TextEditingController();
  var price = TextEditingController();
  var remark = TextEditingController();
  var comment = TextEditingController();
  var qty = TextEditingController();
  var f = new NumberFormat.currency(locale: "id_ID", symbol: "Rp ", decimalDigits: 0);
  var reason = "Discount Manual";
  var isEnable = false;
  var idx = -1;
  var salesmanList = [];

  @override
  void initState() {
    super.initState();
    idx = widget.index;
    price.text = f.format(widget.productList[idx]["price"]);
    qty.text = widget.productList[idx]["qty"].toString();
    if (widget.productList[idx]["salesman"] != "") {
      salesman = widget.productList[idx]["salesman"];
      _searchText.text = salesman;
      setState(() {});
    }

    var discType = widget.productList[idx]["discount_type"];
    var disc = widget.productList[idx]["discount_value"];
    print("sadasadasada" + discType.toString());
    if (discType != "") {
      if (discType == "amount") {
        amountStr = disc.toString();
        percentStr = "";
        amount.text = disc.toString();
        percent.clear();
        isAmountActive = true;
        isPercentActive = false;
      } else {
        amountStr = "";
        percentStr = disc.toString();
        amount.clear();
        percent.text = disc.toString();
        isAmountActive = false;
        isPercentActive = true;
      }
      isEnable = true;
      var remarks = widget.productList[idx]["remark"];
      var reasons = widget.productList[idx]["reason"];
      remark.text = remarks.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Sales Line ${idx + 1}: ${widget.productList[idx]["code"]}'),
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discount Manual',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isEnable = !isEnable;

                    if (!isEnable) {
                      amountStr = "";
                      percentStr = "";
                      amount.clear();
                      percent.clear();
                      isAmountActive = true;
                      isPercentActive = true;
                    }
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: (!isEnable) ? Colors.orange : Colors.red),
                  padding: EdgeInsets.all(16),
                  child: InkWell(
                      child: Text(
                    (!isEnable) ? 'Enable' : 'Disable',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (isEnable)
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: (isPercentActive)
                                  ? Colors.white
                                  : Colors.grey[300],
                            ),
                            child: Padding(
                              padding: (!isPercentActive)
                                  ? EdgeInsets.symmetric(horizontal: 10)
                                  : EdgeInsets.only(top: 0),
                              child: TextFormField(
                                controller: percent,
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: (isPercentActive) ? true : false,
                                decoration: InputDecoration(
                                  hintText: 'Percent',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (percentStr.isNotEmpty)
                                            ? Colors.green
                                            : Colors.grey,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != "") {
                                      setState(() {
                                        isAmountActive = false;
                                        isPercentActive = true;
                                      });
                                    } else {
                                      setState(() {
                                        isAmountActive = true;
                                        isPercentActive = true;
                                      });
                                    }
                                    percentStr = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '%',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: (isAmountActive)
                                  ? Colors.white
                                  : Colors.grey[300],
                            ),
                            child: Padding(
                              padding: (!isAmountActive)
                                  ? EdgeInsets.symmetric(horizontal: 10)
                                  : EdgeInsets.only(top: 0),
                              child: TextFormField(
                                controller: amount,
                                keyboardType: TextInputType.number,
                                enabled: (isAmountActive) ? true : false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (amountStr.isNotEmpty)
                                            ? Colors.green
                                            : Colors.grey,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != "") {
                                      setState(() {
                                        isPercentActive = false;
                                        isAmountActive = true;
                                      });
                                    } else {
                                      setState(() {
                                        isPercentActive = true;
                                        isAmountActive = true;
                                      });
                                    }
                                    amountStr = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Amount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Salesman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    hintText: 'Choose Salesman',
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.toString()),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => CityPage(city: suggestion),
                  //   ),
                  // );
                  setState(() {
                    salesman = suggestion.toString();
                    _searchText.text = suggestion.toString();
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: price,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  maxLines: 1,
                  controller: qty,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Input Quantity",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    if (val != "" && int.parse(val) > 0) {
                      var totalPrice =
                          int.parse(val) * widget.productList[idx]["price"];
                      price.text = f.format(totalPrice);
                      setState(() {});
                    } else {
                      price.text =
                          f.format(widget.productList[idx]["price"] * 1);
                      setState(() {});
                    }
                  },
                ),
              ),
              (percentStr.isNotEmpty || amountStr.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Reason',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            width: MediaQuery.of(context)
                                .size
                                .width, //untuk width full
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.circular(5) //untuk border
                                ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: reason,
                                onChanged: (newValue) {
                                  setState(() {
                                    reason = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Discount Manual',
                                  'Bonus Buy Belum Update',
                                  'Harga Belum Update',
                                  'Buy More Save More',
                                  'Exchange Manual Discount'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Remark',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                    )
                  : Container(),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (percentStr.isNotEmpty) {
                          if (reason != "" && remark.text != "") {
                            var percent = double.parse(percentStr) / 100.0;
                            var totalPrice = int.parse(qty.text) *
                                widget.productList[idx]["price"];
                            var discount = (totalPrice * percent).floor();


                            Object data = {
                              'name': widget.productList[idx]["name"],
                              'code': widget.productList[idx]["code"],
                              'qty': qty.text,
                              'size': widget.productList[idx]["size"],
                              'price': widget.productList[idx]["price"],
                              'price_total': totalPrice,
                              'remark': remark.text,
                              'reason': reason,
                              'salesman': salesman,
                              'discount': int.parse(
                                  discount.toString().replaceAll(".0", "")),
                              'discount_type': 'percent',
                              'discount_value': int.parse(percentStr)
                            };

                            Object value1 = data;
                            int value2 = idx;
                            Navigator.pop(
                                context,
                                DataObject(
                                    value1: value1,
                                    value2: value2,
                                    value3: false));
                          } else {
                            toast('Please input Reason and Remark');
                          }
                        } else if (amountStr.isNotEmpty) {
                          if (reason != "" && remark.text != "") {
                            var totalPrice = int.parse(qty.text) *
                                widget.productList[idx]["price"];

                            Object data = {
                              'name': widget.productList[idx]["name"],
                              'code': widget.productList[idx]["code"],
                              'qty': qty.text,
                              'size': widget.productList[idx]["size"],
                              'price': widget.productList[idx]["price"],
                              'price_total': totalPrice,
                              'remark': remark.text,
                              'reason': reason,
                              'salesman': salesman,
                              'discount': int.parse(amountStr),
                              'discount_type': 'amount',
                              'discount_value': int.parse(amountStr)
                            };

                            Object value1 = data;
                            int value2 = idx;
                            Navigator.pop(
                                context,
                                DataObject(
                                    value1: value1,
                                    value2: value2,
                                    value3: false));
                          } else {
                            toast('Please input Reason and Remark');
                          }
                        } else {
                          if (qty.text.isEmpty && int.parse(qty.text) > 0) {
                            toast('Please insert Quantity');
                          } else if (salesman.isEmpty) {
                            toast('Please choose Salesman');
                          } else {
                            var totalPrice = int.parse(qty.text) *
                                widget.productList[idx]["price"];
                            Object data = {
                              'name': widget.productList[idx]["name"],
                              'code': widget.productList[idx]["code"],
                              'qty': qty.text,
                              'size': widget.productList[idx]["size"],
                              'price': widget.productList[idx]["price"],
                              'price_total': totalPrice,
                              'remark': "",
                              'reason': "",
                              'salesman': salesman,
                              'discount': int.parse("0"),
                              'discount_type': '',
                              'discount_value': 0
                            };

                            Object value1 = data;
                            int value2 = idx;
                            Navigator.pop(
                                context,
                                DataObject(
                                    value1: value1,
                                    value2: value2,
                                    value3: false));
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue),
                        padding: EdgeInsets.all(16),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Ok',
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
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        Object value1 = {};
                        int value2 = idx;
                        Navigator.pop(
                            context,
                            DataObject(
                                value1: value1, value2: value2, value3: true));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red),
                        padding: EdgeInsets.all(16),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Delete',
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
                  ],
                ),
              ),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> getSuggestions(String pattern) async {
    // Replace this with a call to your own API or data source
    return widget.salesmanList
        .where((city) => city.toLowerCase().startsWith(pattern.toLowerCase()))
        .toList();
  }
}
