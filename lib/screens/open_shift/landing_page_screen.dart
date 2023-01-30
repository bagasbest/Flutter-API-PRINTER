import 'package:flutter/material.dart';

import '../../utils/themes.dart';

class LandingPageScreen extends StatefulWidget {
  final List user;

  LandingPageScreen({
    required this.user
});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  String bullet = "\u2022 ";
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Landing Page'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Landing Page',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'InfiPOS version 2.3.0.0',
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Application Settings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '     $bullet Rounding Setting: 100',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '     $bullet Multiuser Mode: true',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '     $bullet Passkey Level: 0',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Registration',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '     $bullet Cash Register: 1001',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '     $bullet Sales Organization: BS00',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '     $bullet Site Code: ${widget.user[0]["Code"]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '     $bullet Site Name: ${widget.user[0]["SiteName"]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    '     $bullet Storage Location: 1001',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '     $bullet Company: PT. Berca Sportindo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '     $bullet NPWP: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Graha Pusat Niaga Lt.3, Kemayoran',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '@2018 PT.Berca Sportindo - IT Dept - version 2.3.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
