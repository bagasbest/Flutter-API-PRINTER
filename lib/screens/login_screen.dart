import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/colors.dart';
import '../utils/themes.dart';
import 'api/api.dart';
import 'home_screen.dart';
import 'model/token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _email = TextEditingController();
  var _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = true;
  bool _visible = false;
  List user = [];
  Object token = {};

  @override
  void initState() {
    super.initState();
    _email.text = "tri.budiman";
    _password.text = "abs";
    getBarerToken();
  }

  getLoginUser(String username) async {
    try {
      var url = Uri.parse(
          "https://training.bercaretail.com/erpapi/api/pos/Username?username=$username");
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        user = jsonDecode(response.body) as List;
      } else {
        throw Exception('Failed to load User');
      }
    } catch (e) {
      print("Error $e");
    }
  }

  getBarerToken() async {
    try {
      var url = Uri.parse("https://training.bercaretail.com/erpapi/api/authenticate");
      final response = await http.get(
        url,
        headers: {
         // "Content-Type": "application/x-www-form-urlencoded",
          'grant_type': 'password',
          'username': 'interfaceservice',
          'password': 'P@ssw0rd123',
        },
      );

      if (response.statusCode == 200) {
        token = jsonDecode(response.body) as Object;
        print(token);
      } else {
        print(response.statusCode);
        throw Exception('Failed to load token');
      }
    } catch (e) {
      print("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Berca Retail POS"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Image.asset(
                      'assets/logo.jpg',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    )),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'User Name',
                      prefixIcon: Icon(Icons.people),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.green, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "User Name must be filled";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    obscureText: _showPassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock_open_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.green, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(_showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password must be filled";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                /// LOADING INDIKATOR
                Visibility(
                  visible: _visible,
                  child: const SpinKitRipple(
                    color: AppColors.green,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                /// TOMBOL LOGIN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.green),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        /// CEK APAKAH EMAIL DAN PASSWORD SUDAH TERISI DENGAN FORMAT YANG BENAR
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _visible = true;
                          });

                          await getLoginUser(_email.text);
                          if(user.isNotEmpty) {
                            setState(
                                  () {
                                _visible = false;
                              },
                            );
                            /// MASUK KE HOMEPAGE JIKA SUKSES LOGIN
                            Route route = MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  user: user,
                                ));
                            Navigator.push(context, route);
                          } else {
                            setState(
                                  () {
                                _visible = false;
                              },
                            );
                            toast("Username or Password Wrong!");
                          }



                        } else {
                          setState(
                            () {
                              _visible = false;
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// CUSTOM TOAST
void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}
