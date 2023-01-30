import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';
import '../login_screen.dart';


class ProductScreen extends StatefulWidget {
  final List user;

  ProductScreen({
    required this.user,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var searchBy = "Product Name";
  List<String> searchByItem = ['Product Name', 'Barcode', 'Article'];
  var isEmptySearchField = true;
  var _searchController = TextEditingController();
  var _visible = false;
  var accessToken = "";
  List productList = [];

  @override
  void initState() {
    super.initState();
    getBarerToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Product Maintenance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search By',
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
                padding: EdgeInsets.only(left: 16, right: 16),
                width: MediaQuery.of(context).size.width, //untuk width full
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5) //untuk border
                    ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: searchBy,
                    onChanged: (newValue) {
                      setState(() {
                        searchBy = newValue!;
                      });
                    },
                    items: searchByItem
                        .map<DropdownMenuItem<String>>((String value) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.57,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      child: TextFormField(
                        controller: _searchController,
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: (!isEmptySearchField)
                                    ? Colors.green
                                    : Colors.red,
                                width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          ),
                        ),
                        onChanged: (val) {
                          if (val.isEmpty) {
                            setState(() {
                              isEmptySearchField = true;
                            });
                          } else {
                            setState(() {
                              isEmptySearchField = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    if (!isEmptySearchField) {
                      if (searchBy == "Product Name") {
                        getProduct(
                            _searchController.text.toString().toLowerCase(),
                            "",
                            "");
                      } else if (searchBy == "Barcode") {
                        getProduct("", _searchController.text.toString(), "");
                      } else {
                        getProduct("", "", _searchController.text.toString());
                      }
                    } else {
                      toast('Please fill column search');
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff4473a3)),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Confirm',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// LOADING INDIKATOR
            (_visible) ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Visibility(
                visible: _visible,
                child: SpinKitRipple(
                  color: Colors.green,
                ),
              ),
            ) : Container(),
            (!_visible)
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.64,
                    child: ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        var f = new NumberFormat.currency(
                            locale: "id_ID", symbol: "Rp ", decimalDigits: 0);
                        return Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16, top: 16,),
                                    margin: EdgeInsets.only(top: 16),
                                    child: Text(
                                      'Code: ${productList[index]["code"]}',
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Name:",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "Barcode:",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "Price:",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    child: Text(
                                                      "${productList[index]["name"]} ",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Text(
                                                    (productList[index]
                                                                ["barcode"] !=
                                                            "null")
                                                        ? productList[index]
                                                            ["barcode"]
                                                        : "-",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    f.format(productList[index]
                                                        ["price"]),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
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
    );
  }

  getProduct(String productName, String barcode, String article) async {
    try {
      setState(() {
        _visible = true;
      });
      var siteKey = widget.user[0]["Site"];
      var url = Uri.parse(
          "https://training.bercaretail.com/erpapi/api/pos/GetProduct?article=$article&barcode=$barcode&name=$productName&sitekey=$siteKey");
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> products = jsonData['Data'];

        productList.clear();
        for (var product in products) {
          print(product);
          Object data = {
            'name': product['Name'],
            'code': product['Code'],
            'price': product['Value'],
            'barcode': product['Barcode'].toString(),
          };
          productList.add(data);
        }

        setState(() {
          _visible = false;
        });
      } else {
        setState(() {
          _visible = false;
        });
        toast('No Product Found');
      }
    } catch (e) {
      setState(() {
        _visible = false;
      });
      print("Error $e");
    }
  }

  getBarerToken() async {
    try {
      String url = Api.authentication;
      Map<String, String> headers = {
        "Content-type": "application/x-www-form-urlencoded"
      };
      String body =
          "grant_type=password&username=interfaceservice&password=P@ssw0rd123";

      await http
          .post(Uri.parse(url), headers: headers, body: body)
          .then((response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);
          accessToken = json['access_token'];
        }
      });
    } catch (e) {
      print("error $e");
    }
  }
}
