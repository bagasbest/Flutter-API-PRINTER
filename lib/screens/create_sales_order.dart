import 'dart:convert';

import 'package:bercaretailpos/screens/edit_item_order.dart';
import 'package:bercaretailpos/screens/login_screen.dart';
import 'package:bercaretailpos/utils/colors.dart';
import 'package:bercaretailpos/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'api/api.dart';
import 'apply_promo_screen.dart';
import 'model/data.dart';

class CreateSalesOrder extends StatefulWidget {
  final List user;

  CreateSalesOrder({required this.user});

  @override
  State<CreateSalesOrder> createState() => _CreateSalesOrderState();
}

class _CreateSalesOrderState extends State<CreateSalesOrder> {
  var barcodeStr = "";
  var _barcode = TextEditingController();
  var _quantity = TextEditingController();
  var _memberID = TextEditingController();
  var f = new NumberFormat.currency(locale: "id_ID", symbol: "Rp ");
  List productList = [];
  List orderOwned = [];
  List memberList = [];
  List salesmanList = [];
  var isClear = true;
  var _visible = false;
  var accessToken = "";

  @override
  void initState() {
    super.initState();
    // _barcode.text = "2457716400XS";
    // _memberID.text = "087781138787";
    getAllMember();
    getBarerToken();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () => Navigator.of(context).pop(),
          ),
          title: Text('Create Sales Order'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                          'Create Sales Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: AppColors.green),
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
                                  color: (barcodeStr != "")
                                      ? Colors.green[200]
                                      : Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _barcode,
                                  keyboardType: TextInputType.text,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    hintText: 'Input Barcode',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: (barcodeStr.isNotEmpty)
                                              ? AppColors.green
                                              : AppColors.red,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    suffixIcon: InkWell(
                                        child: Icon(
                                          Icons.qr_code,
                                          color: AppColors.green,
                                        ),
                                        onTap: () {
                                          toast(
                                              'Camera scanning will release soon');
                                        }),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      barcodeStr = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(
                                          color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _quantity,
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            enabled: false,
                                            border: InputBorder.none,
                                            hintText: 'Input Quantity',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: AppColors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(
                                          color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _memberID,
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Member / Phone / ID No',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: AppColors.green,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: InkWell(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Add Member',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () async {
                                            if (isClear) {
                                              toast(
                                                  'Please add product before you add member');
                                            } else {
                                              setState(() {
                                                _visible = true;
                                              });
                                              final regex = RegExp(r'^\d+$');
                                              if (regex
                                                  .hasMatch(_memberID.text)) {
                                                await getMember();
                                              } else {
                                                memberList.forEach((element) {
                                                  if (element["name"] ==
                                                      _memberID.text) {
                                                    orderOwned.clear();
                                                    orderOwned.add(element);
                                                  }
                                                });
                                                if (orderOwned.isEmpty) {
                                                  toast('Member Not Found');
                                                }
                                                setState(() {
                                                  _visible = false;
                                                });
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        if (_barcode.text.isNotEmpty) {
                                          setState(() {
                                            _visible = true;
                                          });
                                          await getProduct(_barcode.text);
                                        } else {
                                          toast("Please input barcode");
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: AppColors.blue),
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
                                        if (isClear) {
                                          toast(
                                              'Please add product before go to Payment!');
                                        } else {
                                          Route route = MaterialPageRoute(
                                              builder: (context) =>
                                                  ApplyPromoScreen(
                                                    user: widget.user,
                                                    productList: productList,
                                                    orderOwned: orderOwned,
                                                    salesmanList: salesmanList
                                                  ));
                                          Navigator.push(context, route);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: AppColors.green),
                                        padding: EdgeInsets.all(16),
                                        child: InkWell(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                'Payment',
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
                                        setState(() {
                                          productList.clear();
                                          isClear = true;
                                          toast('Success clear order');
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: AppColors.red),
                                        padding: EdgeInsets.all(16),
                                        child: InkWell(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .remove_circle_outline_rounded,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                'Clear',
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// LOADING INDIKATOR
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Visibility(
                    visible: _visible,
                    child: const SpinKitRipple(
                      color: AppColors.green,
                    ),
                  ),
                ),

                (isClear)
                    ? Container()
                    : Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                'Sales Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.green),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  (orderOwned.isNotEmpty)
                                      ? Text(
                                          'Member Name : ${orderOwned[0]["name"]}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: AppColors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(
                                        'Sales Period ${convertDate()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: productList.length,
                                      itemBuilder: (context, index) {
                                        var f = new NumberFormat.currency(
                                            locale: "id_ID", symbol: "Rp ");
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Card(
                                            color: Colors.grey[200],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Name:",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "Code:",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "Size:",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "Quantity: ",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "Price:",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          (productList[
                                                          index][
                                                          "discount"] != 0) ? Text(
                                                            "Discount: ",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ) : Container(),
                                                          (productList[
                                                          index][
                                                          "discount"] != 0) ? Text(
                                                            "Remark: ",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ) : Container(),
                                                          Text(
                                                            "Price Total: ",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )
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
                                                                0.4,
                                                            child: Text(
                                                              "${productList[index]["name"]} ",
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
                                                            "${productList[index]["code"]}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "${productList[index]["size"]}",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "${productList[index]["qty"]}",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            f.format(
                                                                productList[
                                                                        index]
                                                                    ["price"]),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          (productList[
                                                          index][
                                                          "discount"] != 0) ? Text(
                                                            f.format(productList[
                                                            index][
                                                            "discount"]),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ) : Container(),
                                                          (productList[
                                                          index][
                                                          "discount"] != 0) ? Container(
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width *
                                                                0.4,
                                                            child: Text(
                                                              productList[
                                                              index][
                                                              "remark"],
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                          ) : Container(),
                                                          (productList[
                                                          index][
                                                          "discount"] != 0) ? Text(
                                                            f.format(productList[
                                                                    index][
                                                                "price_total"] - productList[
                                                            index][
                                                            "discount"]),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ) : Text(
                                                            f.format(productList[
                                                            index][
                                                            "price_total"]),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Route route =
                                                        MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditItemOrder(
                                                        productList:
                                                            productList,
                                                        index: index,
                                                        salesmanList:
                                                            salesmanList,
                                                      ),
                                                    );
                                                    final result =
                                                        await Navigator.push(
                                                            context, route);

                                                    if (result is DataObject) {
                                                      productList.removeAt(result.value2);
                                                      if(!result.value3) {
                                                        productList.insert(result.value2, result.value1);
                                                      } else {
                                                        if(productList.length ==0) {
                                                          isClear = true;
                                                        }
                                                      }
                                                      setState((){});
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            5)),
                                                        color: AppColors.blue),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.edit_note,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Edit Order Item',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: AppColors.green,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(
                                        'Sales Amount: ${getSalesAmount()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

  getProduct(String barcode) async {
    try {
      var url = Uri.parse("${Api.getProduct}$barcode");
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> products = jsonData['Data'];

        for (var product in products) {
          Object data = {
            'name': product['Name'],
            'code': product['Code'],
            'qty': 1,
            'size': product['Size'],
            'price': product['Value'],
            'price_total': product['Value'],
            'remark': "",
            'reason': "",
            'salesman': "",
            'discount': 0,
            'discount_type': "",
            'discount_value': ""
          };
          productList.add(data);
        }

        setState(() {
          _visible = false;
          isClear = false;
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

  convertDate() {
    var date = widget.user[0]["BusinessDate"];
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }

  getMember() async {
    try {
      var url = Uri.parse("${Api.getMemberWithNumber}${_memberID.text}");
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> memberByNumber = jsonData['Data'];

        for (var member in memberByNumber) {
          Object data = {
            'memberId': member['MembershipId'],
            'name': member['MemberName'],
            'email': member['Email'],
            'phone': member['MobileNumber'],
            'point': member['Point'],
            'desc': member['Description'],
          };
          orderOwned.clear();
          orderOwned.add(data);
        }

        setState(() {
          _visible = false;
        });
      } else {
        setState(() {
          _visible = false;
        });
        toast('No Member Found');
      }
    } catch (e) {
      setState(() {
        _visible = false;
      });
      print("Error $e");
    }
  }

  getAllMember() async {
    try {
      var url = Uri.parse(Api.getMemberList);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        memberList = jsonDecode(response.body) as List;
        setState(() {
          _visible = false;
        });
      } else {
        setState(() {
          _visible = false;
        });
        toast('No Member Found');
      }
    } catch (e) {
      setState(() {
        _visible = false;
      });
      print("Error $e");
    }
  }

  getSalesAmount() {
    var result = 0.0;
    productList.forEach((element) {
      result += element["price_total"]-element["discount"];
    });
    var curr = f.format(result);
    return curr;
  }

  getSalesman() async {
    try {
      var url = Uri.parse(Api.getSalesman);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> salesmanData = jsonData['Data'];

        salesmanList.clear();
        for (var salesman in salesmanData) {
          salesmanList.add(salesman['fullname']);
        }

        print(salesmanList);
        setState(() {});
      }
    } catch (e) {
      print("Error $e");
    }
  }

  getBarerToken() async {
    try {
      String url = Api.authentication;
      Map<String, String> headers = {"Content-type": "application/x-www-form-urlencoded"};
      String body = "grant_type=password&username=interfaceservice&password=P@ssw0rd123";

      await http.post(Uri.parse(url), headers: headers, body: body).then((response) {
        if(response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);
          accessToken = json['access_token'];
          getSalesman();
        }
      });
    } catch (e) {
      print("error $e");
    }
  }
}
