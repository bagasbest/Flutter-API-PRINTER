import 'dart:convert';
import 'dart:io';

import 'package:bercaretailpos/screens/open_shift/open_shift_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    checkIsCheckedOrNot();
    getBarerToken();
    getIncrement();
  }

  getLoginUser(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      print("Bearer: $token");

      var url = Uri.parse(
          "https://training.bercaretail.com/erpapi/api/pos/Username?username=$username");
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
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
          String accessToken = json['access_token'];
          setTokenToPrefs("token", accessToken);
        }
      });
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
                            BorderSide(color: Colors.green, width: 2.0),
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
                            BorderSide(color: Colors.green, width: 2.0),
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

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Text('Remember username and password', style: TextStyle(fontSize: 16),)
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                /// LOADING INDIKATOR
                Visibility(
                  visible: _visible,
                  child: const SpinKitRipple(
                    color: Colors.green,
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
                            color: Colors.green),
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
                          if (user.isNotEmpty) {
                            setState(
                              () {
                                _visible = false;
                              },
                            );

                            if(_isChecked) {
                              await setCheckBox("checked", true);
                              await setTokenToPrefs("username", _email.text);
                              await setTokenToPrefs("password", _password.text);
                            } else {
                              await setCheckBox("checked", false);
                              await setTokenToPrefs("username", "");
                              await setTokenToPrefs("password", "");
                            }


                            if(user[0]["isOpen"] == "true") {
                              /// MASUK KE HOMEPAGE JIKA SUKSES LOGIN
                              Route route = MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    user: user,
                                  ));
                              Navigator.push(context, route);
                            } else {
                              /// MASUK KE OPEN SHIFT JIKA SUKSES LOGIN
                              Route route = MaterialPageRoute(
                                  builder: (context) => OpenShiftScreen(
                                    user: user,
                                  ));
                              Navigator.push(context, route);
                            }

                            // Route route = MaterialPageRoute(
                            //     builder: (context) => HomeScreen(
                            //       user: user,
                            //     ));
                            // Navigator.push(context, route);
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

  // Function to get an integer value from shared preferences
  Future<String?> getFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  getIncrement() async {
    String? myIntValue = await getFromPrefs("increment");
    if (myIntValue == null) {
      setIntToPrefs("increment", 0);
    }
  }

  // Function to save an integer value to shared preferences
  Future<void> setIntToPrefs(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    String leadingZeroInt = value.toString().padLeft(3, '0');
    prefs.setString(key, leadingZeroInt);
  }

  // Function to save an integer value to shared preferences
  Future<void> setTokenToPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // Function to save an integer value to shared preferences
  Future<void> setCheckBox(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }


  checkIsCheckedOrNot() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if(prefs.getBool("checked") == true) {
        _email.text = prefs.getString("username")!;
        _password.text = prefs.getString("password")!;
        _isChecked = true;
      }

      setState(() {});
    }catch(e) {}

  }
}

/// CUSTOM TOAST
void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}
