import 'package:bercaretailpos/screens/login_screen.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/themes.dart';

class PrintSettlementScreen extends StatefulWidget {
  final List user;

  PrintSettlementScreen({
    required this.user,
  });

  @override
  State<PrintSettlementScreen> createState() => _PrintSettlementScreenState();
}

class _PrintSettlementScreenState extends State<PrintSettlementScreen> {
  late String _formattedDate;
  DateTime _selectedDate = DateTime.now();

  ///Dependency Baru
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  int? bluetoothState;
  var _visible = false;
  var valueTotal = 0;
  var f = new NumberFormat.currency(
      locale: "id_ID", symbol: "Rp ", decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    _formattedDate = DateFormat('yyyy-MM-dd').format(now);
    /// Fungsi untuk cek bluetooth ponsel menyala atau mati
    initPlatformState();
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
        getDateFromApi();
      });
    }
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
    return Theme(
      data: Themes(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Print Settlement'),
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
                  'Print Settlement',
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
                          (!_visible)  ? Row(
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
                                  if (bluetoothState == 10) {
                                    toast("Please turn on bluetooth from your device!");
                                  } else if (_devices.isEmpty) {
                                    toast("No one bluetooth printer available");
                                  } else {
                                    _showPrintDialog();
                                  }
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
                                      Icon(Icons.print),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Print",
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
                          ) :Container(),
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
          backgroundColor: Colors.green,
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
                height: 300,
                width: 500,
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
          bluetooth.printCustom("Store: ${widget.user[0]["Code"]} - ${widget.user[0]["SiteName"]}", 0, 0);
          bluetooth.printCustom("Business Date: ${convertDate()}", 0, 0);
          bluetooth.printCustom("Print Date: ${convertDates()}", 0, 0);
          bluetooth.printCustom("Print By: ${widget.user[0]['UserName']}", 0, 0);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Total Cash: ${f.format(valueTotal)}", 0, 0);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Grand Total: ${f.format(valueTotal)}", 0, 0);
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

  convertDate() {
    var date = widget.user[0]["BusinessDate"];
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }

  String getTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyy');
    return formatter.format(now);
  }

  convertDates() {
    var date = widget.user[0]["BusinessDate"];
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMM yyyy HH:mm:ss').format(dateTime);
    return formattedDate;
  }


  @override
  void dispose() {
    bluetooth.disconnect();
    super.dispose();
  }

  getDateFromApi() async {
    try {
      setState(() {
        _visible = true;
      });
      var dates = DateFormat("yyyy-MM-dd").format(_selectedDate);
      var siteKey = widget.user[0]["Site"];

      var url = Uri.parse(
          "https://training.bercaretail.com/erpapi/api/pos/GetSalesSettlement?Docdate=$dates&site=$siteKey");
      print(url);
      final response = await http.get(
        url
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        List<dynamic> products = jsonData['Data'];

        valueTotal = 0;
        for (var product in products) {
          valueTotal += int.parse(product['SalesValue'].toString().replaceAll(".00", ""));
        }

        print(valueTotal);
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


}
