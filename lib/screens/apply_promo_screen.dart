import 'package:bercaretailpos/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class ApplyPromoScreen extends StatefulWidget {
  List user = [];
  List productList = [];
  List salesmanList = [];
  List orderOwned = [];

  ApplyPromoScreen({
    required this.user,
    required this.productList,
    required this.salesmanList,
    required this.orderOwned,
  });

  @override
  State<ApplyPromoScreen> createState() => _ApplyPromoScreenState();
}

class _ApplyPromoScreenState extends State<ApplyPromoScreen> {
  var barcodeStr = "";
  var _barcode = TextEditingController();
  var _quantity = TextEditingController();
  var _memberID = TextEditingController();
  var f = new NumberFormat.currency(locale: "id_ID", symbol: "Rp ");
  int groupVal = 0;
  List<String> answerOptions = [
    'LRB18DISC29X - LRB18 GET DISC 20',
    'OP21DK30P - OP21 Diskon Karyawan 30%',
    'MY22BMSM - MY22 Buy More Save More',
    'ID22BMSML1 - ID22 Merdeka 15%'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Apply Promo'),
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skip Promo Detail',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 2),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2)),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                'Off',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Select Promo Detail (applicable to each item)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                for (int i = 0; i < answerOptions.length; i++)
                  Container(
                    child: QuizRadioButton(
                        label: answerOptions[i],
                        onChanged: (value) {
                          setState(() {
                            groupVal = value;
                          });
                        },
                        index: i,
                        groupVal: groupVal),
                  ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.blue),
                      padding: EdgeInsets.all(7),
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
                              'Apply',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.yellow),
                        padding: EdgeInsets.all(7),
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
                                'Go To Payment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            Route route = MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                  user: widget.user,
                                  productList: widget.productList,
                                  salesmanList: widget.salesmanList,
                                  orderOwned: widget.orderOwned),
                            );
                            Navigator.push(context, route);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.red),
                      padding: EdgeInsets.all(7),
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.remove_circle_outline_rounded,
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
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class QuizRadioButton extends StatefulWidget {
  final String label;
  final void Function(dynamic) onChanged;
  int index, groupVal;

  QuizRadioButton(
      {required this.label,
      required this.groupVal,
      required this.onChanged,
      required this.index,
      Key? key})
      : super(key: key);

  @override
  _QuizRadioButtonState createState() => _QuizRadioButtonState();
}

class _QuizRadioButtonState extends State<QuizRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<int>(
          value: widget.index,
          groupValue: widget.groupVal,
          onChanged: widget.onChanged,
        ),
        Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
