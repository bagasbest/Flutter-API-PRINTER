import 'package:bercaretailpos/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/themes.dart';

class PromotionSchedule extends StatefulWidget {
  const PromotionSchedule({Key? key}) : super(key: key);

  @override
  State<PromotionSchedule> createState() => _PromotionScheduleState();
}

class _PromotionScheduleState extends State<PromotionSchedule> {
  late String _formattedDate;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    _formattedDate = DateFormat('yyyy-MM-dd').format(now);
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Promotion Schedule'),
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
                  'Promotion Schedule',
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
                    color: Colors.green,
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
                            'Available Promo At',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: (_selectedDate == null)
                                        ? Text(
                                            _formattedDate,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        : Text(
                                            "${DateFormat("yyyy-MM-dd").format(_selectedDate)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              InkWell(
                                onTap: () {
                                  toast('OK');
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.27,
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(width: 1, color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Search",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
