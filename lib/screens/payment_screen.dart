import 'dart:convert';

import 'package:bercaretailpos/screens/save_pdf.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import 'api/api.dart';
import 'login_screen.dart';

class PaymentScreen extends StatefulWidget {
  List user = [];
  List productList = [];
  List salesmanList = [];
  List orderOwned = [];

  PaymentScreen({
    required this.user,
    required this.productList,
    required this.salesmanList,
    required this.orderOwned,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var salesman = "";
  var _searchText = TextEditingController();
  var transRefInput = TextEditingController();
  var paymentRefInput = TextEditingController();
  var cardNumber = TextEditingController();
  var amount = TextEditingController();
  var voucher = TextEditingController();
  var approvalCode = TextEditingController();
  var cardHolder = TextEditingController();
  var f = NumberFormat.currency(locale: "id_ID", symbol: "Rp ");
  var transRef = "OPCO";
  var paymentRef = "Trans Ref";
  var paymentMethod = "CASH";

  var edc = "BCA - BANK CENTRAL ASIA";
  var cardType = "AMEX BCA";
  var selectedValue13 = "Option 1";

  var voucherStr = "";
  var visibleProgress = true;

  var transRefStr = "";
  var paymentRefStr = "";
  var cardNumberRefStr = "";
  var approvalCodeRefStr = "";
  var cardHolderRefStr = "";
  var amountStr = "";
  List<String> transRefList = [];
  List<String> paymentRefList = [];
  List<String> paymentMethodList = [];
  List<String> bankList = [];
  var bankCompleteList = [];
  List<String> cardBankList = [];
  var cardBankCompleteList = [];
  var paymentList = [];
  var salesAmount = 0.0;
  var grandPrice = 0.0;
  var totalChanges = -1.0;
  var rounding = 0;
  var increment = "";

  ///Dependency Baru
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  int? bluetoothState;

  @override
  void initState() {
    super.initState();

    /// Fungsi untuk cek bluetooth ponsel menyala atau mati
    initPlatformState();

    getTransRef();
    getPaymentRef();
    getPaymentMethod();
    getBanks();
    getAllCardBank();
  }

  /// Fungsi untuk cek bluetooth ponsel menyala atau mati
  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {

        /// Bluetooth menyala pada ponsel
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            print('bluetooth ON');
          });
          break;

        /// Bluetooth mati
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            print('bluetooth OFF');
          });
          break;
        default:
          setState(() {
            bluetoothState = state;
          });
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          (visibleProgress)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    hintText: 'Search Salesman',
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
                height: 20,
              ),
              Text(
                'Trans.Ref',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
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
                      value: transRef,
                      onChanged: (newValue) {
                        setState(() {
                          transRef = newValue!;
                        });
                      },
                      items: transRefList
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        (transRefStr != "") ? Colors.green[200] : Colors.white,
                  ),
                  child: TextFormField(
                    controller: transRefInput,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Input Trans Ref',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (transRefStr.isNotEmpty)
                                ? AppColors.green
                                : AppColors.red,
                            width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        transRefStr = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Payment.Ref',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
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
                      value: paymentRef,
                      onChanged: (newValue) {
                        setState(() {
                          paymentRef = newValue!;
                        });
                      },
                      items: paymentRefList
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: (paymentRefStr != "")
                        ? Colors.green[200]
                        : Colors.white,
                  ),
                  child: TextFormField(
                    controller: paymentRefInput,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Input Payment Ref',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (paymentRefStr.isNotEmpty)
                                ? AppColors.green
                                : AppColors.red,
                            width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        paymentRefStr = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      value: paymentMethod,
                      onChanged: (newValue) {
                        setState(() {
                          paymentMethod = newValue!;
                        });
                      },
                      items: paymentMethodList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )),
              (paymentMethod == "CARD")
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'EDC',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 16,
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
                                value: edc,
                                onChanged: (newValue) {
                                  edc = newValue!;
                                  print(cardBankList.toString());
                                  cardBankList.clear();

                                  var id = -1;
                                  var stop = false;
                                  bankCompleteList.forEach((element) {
                                    if (stop) {
                                      return;
                                    }
                                    if (element['desc'] == edc) {
                                      stop = true;
                                      id = element['code'];
                                    }
                                  });

                                  stop = false;
                                  cardBankCompleteList.forEach((element) {
                                    if (element['code'] == id) {
                                      if (!stop) {
                                        cardType = element['desc'];
                                        stop = false;
                                      }
                                      cardBankList.add(element['desc']);
                                    }
                                  });
                                  print(cardBankList.toString());
                                  setState(() {});
                                },
                                items: bankList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Card Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 16,
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
                                value: cardType,
                                onChanged: (newValue) {
                                  setState(() {
                                    cardType = newValue!;
                                  });
                                },
                                items: cardBankList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Card Number (Max 16)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            child: TextFormField(
                              controller: cardNumber,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLength: 16,
                              decoration: InputDecoration(
                                hintText: 'Input Card Number',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: (cardNumberRefStr.isNotEmpty)
                                          ? AppColors.green
                                          : AppColors.red,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  cardNumberRefStr = value;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Approval Code',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: (approvalCodeRefStr != "")
                                  ? Colors.green[200]
                                  : Colors.white,
                            ),
                            child: TextFormField(
                              controller: approvalCode,
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'Input Approval Code',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: (approvalCodeRefStr.isNotEmpty)
                                          ? AppColors.green
                                          : AppColors.red,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  approvalCodeRefStr = value;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Card Holder',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: (cardHolderRefStr != "")
                                  ? Colors.green[200]
                                  : Colors.white,
                            ),
                            child: TextFormField(
                              controller: cardHolder,
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'Input Card Holder',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: (cardHolderRefStr.isNotEmpty)
                                          ? AppColors.green
                                          : AppColors.red,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  cardHolderRefStr = value;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    )
                  : (paymentMethod == "VOUCHER")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Voucher Code',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (voucherStr != "")
                                      ? Colors.green[200]
                                      : Colors.white,
                                ),
                                child: TextFormField(
                                  controller: voucher,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    hintText: 'Input Voucher',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: (voucherStr.isNotEmpty)
                                              ? AppColors.green
                                              : AppColors.red,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    voucherStr = val;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
              SizedBox(
                height: 20,
              ),
              (paymentMethod != "VOUCHER")
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: (amountStr != "")
                                  ? Colors.green[200]
                                  : Colors.white,
                            ),
                            child: TextFormField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'Input Amount',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: (amountStr.isNotEmpty)
                                          ? AppColors.green
                                          : AppColors.red,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  amountStr = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (totalChanges < 0) {
                        if (salesman.isEmpty) {
                          toast('Please choose Salesman');
                        } else if (transRef.isEmpty) {
                          toast('Please choose Trans.Ref');
                        } else if (transRefStr.isEmpty) {
                          toast('Please input Trans Ref column');
                        } else if (paymentRef.isEmpty) {
                          toast('Please choose Payment Ref');
                        } else if (paymentRefStr.isEmpty) {
                          toast('Please input Payment Ref column');
                        } else if (paymentMethod.isEmpty) {
                          toast('Please choose Payment Method');
                        } else {
                          if (paymentMethod == "CASH") {
                            if (amountStr.isEmpty) {
                              toast('Please input Amount');
                            } else if (int.parse(amountStr) > 0) {
                              Object data = {
                                'type': 'CASH',
                                'amount': int.parse(amountStr),
                                'cardType': '',
                              };
                              paymentList.add(data);
                              salesAmount = grandPrice;
                              print("Setelaj l;ok : $totalChanges");
                              getRemainingPayment();
                              toast('Payment Cash Successfully');
                              setState(() {});
                            } else {
                              toast('Please input Amount with correct number');
                            }
                          } else if (paymentMethod == "CARD") {
                            if (edc.isEmpty) {
                              toast('Please choose EDC');
                            } else if (cardType.isEmpty) {
                              toast('Please choose Card Type');
                            } else if (cardNumberRefStr.isEmpty) {
                              toast('Please input Card Number');
                            } else if (approvalCodeRefStr.isEmpty) {
                              toast('Please input Approval Code');
                            } else if (cardHolderRefStr.isEmpty) {
                              toast('Please input Card Holder');
                            } else if (amountStr.isEmpty) {
                              toast('Please input Amount');
                            } else if (int.parse(amountStr) > 0) {
                              Object data = {
                                'type': 'CARD',
                                'amount': int.parse(amountStr),
                                'cardType': cardType
                              };
                              paymentList.add(data);
                              salesAmount = grandPrice;
                              print("Setelaj l;ok : $totalChanges");
                              getRemainingPayment();
                              toast('Payment Card Successfully');
                              setState(() {});
                            } else {
                              toast('Please input Amount with correct number');
                            }
                          } else if (paymentMethod == "VOUCHER") {
                            if (voucherStr.isEmpty) {
                              toast('Please input Voucher Code');
                            } else if (int.parse(voucherStr) > 0) {
                              Object data = {
                                'type': 'VOUCHER',
                                'amount': int.parse(voucherStr),
                                'cardType': '',
                              };
                              paymentList.add(data);
                              salesAmount = grandPrice;
                              print("Setelaj l;ok : $totalChanges");
                              getRemainingPayment();
                              toast('Payment Voucher Successfully');
                              setState(() {});
                            } else {
                              toast('Please input Voucher with correct number');
                            }
                          }
                        }
                      } else {
                        toast(
                            'Payment Completed, give changes ${f.format(totalChanges)} to customer');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.green),
                      padding: EdgeInsets.all(11),
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              'Add',
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
                      if (totalChanges < 0) {
                        toast('Please complete payment before finish payment');
                      } else {
                        /// Klik tombol print
                        /// pertama kali program mengecek apakah sudah ada printer bluetooth yang terhubung do aplikasi Warung Makan ABG ini atau belum ada
                        /// Jika tidak ada printer yang terhubung, maka akan muncul semacam alert / toast yang mengatakan "Tidak ada printer terhubung"
                        /// Jika ada printer yang terhubung, maka tampilkan daftar printer tersebut, dan admin bisa memilih mau mencetak struk pakai printer yang tersedia
                        if (bluetoothState == 10) {
                          toast("Please turn on bluetooth from your device!");
                        } else if (_devices.isEmpty) {
                          toast("No one bluetooth printer available");
                        } else {
                          _showPrintDialog();
                        }
                      }
                      //    Route route = MaterialPageRoute(
                      //      builder: (context) => Laporan(
                      //          user: widget.user,
                      //          productList: widget.productList,
                      //          salesmanList: widget.salesmanList,
                      //          orderOwned: widget.orderOwned),
                      //    );
                      //    Navigator.push(context, route);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.blue),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'Finish Payment',
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
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.yellow),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        child: Row(
                          children: [
                            Text(
                              'Back',
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
              SizedBox(
                height: 30,
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(
                        top: 16,
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
                        border: Border.all(width: 1, color: AppColors.green),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          (widget.orderOwned.isNotEmpty)
                              ? Text(
                                  'Member Name : ${widget.orderOwned[0]["name"]}',
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
                                  borderRadius: BorderRadius.circular(6)),
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
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.productList.length,
                              itemBuilder: (context, index) {
                                var f = new NumberFormat.currency(
                                    locale: "id_ID", symbol: "Rp ");
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Card(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
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
                                                    "Code:",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "Size:",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "Quantity: ",
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
                                                  (widget.productList[index]
                                                              ["discount"] !=
                                                          0)
                                                      ? Text(
                                                          "Discount: ",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Container(),
                                                  (widget.productList[index]
                                                              ["discount"] !=
                                                          0)
                                                      ? Text(
                                                          "Remark: ",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Container(),
                                                  Text(
                                                    "Price Total: ",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
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
                                                      "${widget.productList[index]["name"]} ",
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
                                                    "${widget.productList[index]["code"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "${widget.productList[index]["size"]}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "${widget.productList[index]["qty"]}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    f.format(widget
                                                            .productList[index]
                                                        ["price"]),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  (widget.productList[index]
                                                              ["discount"] !=
                                                          0)
                                                      ? Text(
                                                          f.format(
                                                              widget.productList[
                                                                      index]
                                                                  ["discount"]),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Container(),
                                                  (widget.productList[index]
                                                              ["discount"] !=
                                                          0)
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child: Text(
                                                            widget.productList[
                                                                    index]
                                                                ["remark"],
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
                                                        )
                                                      : Container(),
                                                  Text(
                                                    f.format(widget
                                                            .productList[index]
                                                        ["price_total"]),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Sub-Total ${getSubTotal()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          (rounding > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16, bottom: 16),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "Rounding ${f.format(rounding)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
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
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                'Sales Amount: ${getSalesAmount()} ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          (paymentList.isNotEmpty)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "Payments By:",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: paymentList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: Colors.blue[50],
                                              padding: const EdgeInsets.all(7),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${paymentList[index]["type"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    f.format(paymentList[index]
                                                        ["amount"]),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      paymentList
                                                          .removeAt(index);
                                                      totalChanges = -1.0;

                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.clear_outlined,
                                                      color: AppColors.blue,
                                                    ),
                                                  )
                                                ],
                                              ));
                                        },
                                      ),
                                    ),
                                    (totalChanges >= 0.0)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.all(7),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "Changes",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        f.format(totalChanges),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  )),
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
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: Text(
                                                    'Total Changes ${f.format(totalChanges)}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 16,
                          ),
                          (totalChanges < 0.0)
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: AppColors.blue,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      'Remaining Payment: ${getSalesAmount2()}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
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
    );
  }

  void _showPrintDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: AppColors.green,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Choose Printer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 3,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      title: Text(
                        _devices[i].name!,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        _devices[i].address!,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        /// Admin menekan printer bluetooth yang tersedia
                        /// kemudian struk transaksi akan keluar
                        /// koneksikan printer bluetooth yang dipilih
                        bluetooth.connect(_devices[i]);
                        _startPrint(_devices[i]);
                      },
                    );
                  },
                ),
              )
            ],
          ),
          elevation: 10,
        );
      },
    );
  }

  /// Fungsi untuk mencetak struk transaksi
  Future<void> _startPrint(BluetoothDevice device) async {
    /// pastikan ada printer bluetooth yang terpilih oleh admin
    if (device.address != null) {
      /// koneksikan printer bluetooth yang dipilih
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == true) {
          var incrementInc = int.parse(increment);
          setIntToPrefs("increment", incrementInc++);
          //SIZE
          // 0- normal size text
          // 1- only bold text
          // 2- bold with medium text
          // 3- bold with large text
          //ALIGN
          // 0- ESC_ALIGN_LEFT
          // 1- ESC_ALIGN_CENTER
          // 2- ESC_ALIGN_RIGHT

          /// Judul Struk
          bluetooth.printNewLine();
          bluetooth.printImage('assets/icon.jpg');
          bluetooth.printCustom("PT. Berca Sportindo", 0, 1);
          bluetooth.printCustom("NPWP: 01.554.599.9-071.000", 0, 1);
          bluetooth.printNewLine();
          bluetooth.printCustom(widget.user[0]["SiteName"], 0, 1);
          bluetooth.printNewLine();
          bluetooth.printCustom(convertDates(), 0, 2);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom(
              "RECEIPT NO: ${widget.user[0]["Code"]}${getTodayDate()}$increment",
              0,
              0);
          bluetooth.printCustom('----------------------------------', 0, 1);

          /// Body Struk
          for (int i = 0; i < widget.productList.length; i++) {
            bluetooth.printCustom(
                'Code: ' + widget.productList[i]['code'], 0, 0);
            bluetooth.printCustom(
                'Name: ' + widget.productList[i]['name'], 0, 0);
            bluetooth.printCustom(
                'Price: ${widget.productList[i]['price']} x ${widget.productList[i]['qty']} = ${f.format(widget.productList[i]["price_total"] - widget.productList[i]["discount"])}',
                0,
                0);
            bluetooth.printNewLine();
            bluetooth.printNewLine();
          }
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Total Qty: ${getTotalQty()}", 0, 0);
          bluetooth.printCustom("Sub Total: ${getSalesAmount()}", 0, 0);
          bluetooth.printCustom("Total Disc: ${getTotalDisc()}", 0, 0);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Grand Total: ${getSalesAmount()}", 0, 0);
          bluetooth.printCustom("Payment By: ${getSalesAmount()}", 0, 0);
          for (int i = 0; i < paymentList.length; i++) {
            if (paymentList[i]["type"] == "CARD") {
              bluetooth.printCustom(
                  "${paymentList[i]['cardType']}: ${f.format(paymentList[i]['amount'])}",
                  0,
                  0);
            } else {
              bluetooth.printCustom(
                  "${paymentList[i]['type']}: ${f.format(paymentList[i]['amount'])}",
                  0,
                  0);
            }
            bluetooth.printNewLine();
          }
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Rounding: $rounding", 0, 0);
          bluetooth.printCustom("Change: ${f.format(totalChanges)}", 0, 0);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Cashier: ${widget.user[0]['UserName']}", 0, 0);
          bluetooth.printNewLine();
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom('Garansi produk tidak berlaku', 0, 1);
          bluetooth.printCustom('untuk produk sepatu promo', 0, 1);
          bluetooth.printCustom('Special Price (SP) dengan harga', 0, 1);
          bluetooth.printCustom('Rp 199.000 kebawah', 0, 1);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom('-- Terima Kasih', 0, 1);
          bluetooth.printCustom('Harga termasuk PPN', 0, 1);
          bluetooth.printCustom('Special Price (SP) dengan harga', 0, 1);
          bluetooth.printCustom('Barang yang sudah dibeli', 0, 1);
          bluetooth.printCustom('Tidak dapat Dikembalikan/Ditukar', 0, 1);

          /// Footer Struk
          bluetooth.printCustom('----------------------------------', 0, 1);
          if (grandPrice > 500000) {
            bluetooth.printCustom('Selamat!', 0, 1);
            bluetooth.printCustom('Anda mendapat hadiah Voucher', 0, 1);
            bluetooth.printCustom('Untuk pembelian produk LEAGUE', 0, 1);
            bluetooth.printCustom('----------------------------------', 0, 1);
            bluetooth.printCustom('-- Voucher Payment --', 0, 1);
            bluetooth.printCustom('Gunakan Saat Pembayaran', 0, 1);
            bluetooth.printQRcode("voucher", 200, 200, 1);
          }
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.paperCut();
        } else {
          toast(
              'There was an error when you wanted to print the receipt, make sure Bluetooth is on and you have selected the printer properly');
        }
      });
    }
  }

  String getTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyy');
    return formatter.format(now);
  }

  @override
  void dispose() {
    bluetooth.disconnect();
    super.dispose();
  }

  convertDates() {
    var date = widget.user[0]["BusinessDate"];
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMM yyyy HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  Future<List> getSuggestions(String pattern) async {
    // Replace this with a call to your own API or data source
    return widget.salesmanList
        .where((city) => city.toLowerCase().startsWith(pattern.toLowerCase()))
        .toList();
  }

  convertDate() {
    // if(paymentList.length > 0 && totalChanges < 0) {
    //   getRemainingPayment();
    // }
    var date = widget.user[0]["BusinessDate"];
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }

  getSalesAmount() {
    var result = 0.0;
    widget.productList.forEach((element) {
      result += element["price_total"] - element["discount"];
    });

    try {
      var clearDouble = int.parse(result.toString().replaceAll(".0", ""));
      int last3Digits = clearDouble % 1000;
      if (last3Digits > 500) {
        last3Digits = 1000 - last3Digits;
        result += last3Digits;
      } else {
        result -= last3Digits;
      }
      rounding = last3Digits;
    } catch (e) {
      rounding = 0;
    }

    salesAmount = result;
    grandPrice = result;
    var curr = f.format(result);
    return curr;
  }

  getSubTotal() {
    var result = 0.0;
    widget.productList.forEach((element) {
      result += element["price_total"];
    });
    salesAmount = result;
    var curr = f.format(result);
    return curr;
  }

  getTransRef() async {
    try {
      var url = Uri.parse(Api.getTransRef);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> transRef = jsonData['Data'];

        transRefList.clear();
        for (var ref in transRef) {
          transRefList.add(ref['Name']);
        }
        setState(() {});
      } else {
        toast('No Data Found');
      }
    } catch (e) {
      print("Error $e");
    }
  }

  getPaymentRef() async {
    try {
      var url = Uri.parse(Api.getPaymentRef);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> paymentRef = jsonData['Data'];

        paymentRefList.clear();
        for (var ref in paymentRef) {
          paymentRefList.add(ref['Name']);
        }
        setState(() {});
      } else {
        toast('No Data Found');
      }
    } catch (e) {
      print("Error $e");
    }
  }

  getPaymentMethod() async {
    try {
      var url = Uri.parse(Api.getPaymentMethod);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> paymentMethod = jsonData['Data'];

        paymentMethodList.clear();
        for (var ref in paymentMethod) {
          paymentMethodList.add(ref['Code']);
        }
        setState(() {});
      } else {
        toast('No Data Found');
      }
    } catch (e) {
      print("Error $e");
    }
  }

  getBanks() async {
    try {
      var url = Uri.parse(Api.getBanks);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> banks = jsonData['Data'];

        bankList.clear();
        bankCompleteList.clear();
        for (var bank in banks) {
          Object data = {
            'code': bank['Id'],
            'desc': '${bank['Code']} - ${bank['Name']}'
          };
          bankCompleteList.add(data);
          bankList.add('${bank['Code']} - ${bank['Name']}');
        }
        setState(() {});
      } else {
        toast('No Data Found');
      }
    } catch (e) {
      print("Error $e");
    }
  }

  getAllCardBank() async {
    try {
      var url = Uri.parse(Api.getAllCardBank);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token}'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> banks = jsonData['Data'];

        cardBankList.clear();
        cardBankCompleteList.clear();
        for (var bank in banks) {
          Object data = {
            'code': bank['Bank_BankID'],
            'desc': bank['Description']
          };
          cardBankList.add(bank['Description']);
          cardBankCompleteList.add(data);
        }
        visibleProgress = false;

        setState(() {});
      } else {
        toast('No Data Found');
      }
    } catch (e) {
      print("Error $e");
    }
  }

  getRemainingPayment() {
    paymentList.forEach((element) {
      salesAmount -= element["amount"];
      print("elemen : ${element["amount"]}");
      print("salesAmount : ${salesAmount}");
    });
    if (salesAmount <= 0) {
      totalChanges = salesAmount * -1.0;
    }
    setState(() {});

    // var curr = f.format(salesAmount);
    // return curr;
  }

  Widget dottedLine() {
    return DottedBorder(
      color: Colors.black,
      strokeWidth: 2,
      child: Container(
        width: double.infinity,
        height: 1.0,
      ),
    );
  }

  // Function to get an integer value from shared preferences
  Future<String?> getIntFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  getIncrement() async {
    String? myIntValue = await getIntFromPrefs("increment");
    if (myIntValue != null) {
      increment = myIntValue;
    }
  }

  // Function to save an integer value to shared preferences
  Future<void> setIntToPrefs(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    String leadingZeroInt = value.toString().padLeft(3, '0');
    prefs.setString(key, leadingZeroInt);
  }

  getTotalQty() {
    var result = 0;
    widget.productList.forEach((element) {
      result += int.parse(element["qty"]);
    });
    return result.toString();
  }

  getTotalDisc() {
    var result = 0;
    widget.productList.forEach((element) {
      result += int.parse(element["discount"]);
    });
    return result.toString();
  }

  getSalesAmount2() {
    paymentList.forEach((element) {
      salesAmount -= element["amount"];
    });

    var curr = f.format(salesAmount);
    return curr;
  }
}
