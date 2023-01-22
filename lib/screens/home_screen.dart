import 'package:bercaretailpos/utils/colors.dart';
import 'package:bercaretailpos/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/themes.dart';

class HomeScreen extends StatefulWidget {
  final List user;

  HomeScreen({required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('HOME'),
        ),
        drawer: Drawers(user: widget.user,),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.green, borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Welcome, ${widget.user[0]["Name"]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Site Name : ${widget.user[0]["Code"]} - ${widget.user[0]["SiteName"]}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Business Date : ${convertDate()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  convertDate() {
    var date = widget.user[0]["BusinessDate"];
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }
}
