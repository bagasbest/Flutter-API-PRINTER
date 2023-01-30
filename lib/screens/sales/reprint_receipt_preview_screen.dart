import 'package:bercaretailpos/screens/sales/reprint_receipt_pdf.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/themes.dart';
import '../login_screen.dart';

class ReprintReceiptPreviewScreen extends StatefulWidget {
  final List user;
  final List sendDataList;

  ReprintReceiptPreviewScreen({required this.user, required this.sendDataList});


  @override
  State<ReprintReceiptPreviewScreen> createState() =>
      _ReprintReceiptPreviewScreenState();
}

class _ReprintReceiptPreviewScreenState
    extends State<ReprintReceiptPreviewScreen> {

  var docNumber = TextEditingController();
  var docTotal = TextEditingController();
  var increment = "";

  ///Dependency Baru
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  int? bluetoothState;

  var f = new NumberFormat.currency(locale: "id_ID", symbol: "Rp ", decimalDigits: 0);


  @override
  void initState() {
    super.initState();
    docNumber.text = widget.sendDataList[0]["salesOrderNumber"];
    docTotal.text = f.format(widget.sendDataList[0]["docTotal"]);
    /// Fungsi untuk cek bluetooth ponsel menyala atau mati
    initPlatformState();
    getIncrement();
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
        appBar: AppBar(
          title: Text('Reprint Sales Order'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Reprint Sales Order',
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
                    color: (Colors.green),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Document Number',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    color: Colors.grey[300]),
                                child: TextFormField(
                                  controller: docNumber,
                                  keyboardType: TextInputType.number,
                                  enabled: false,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    color: Colors.grey[300]),
                                child: TextFormField(
                                  controller: docTotal,
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
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
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 120,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.print,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Reprint',
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
                              ),
                              SizedBox(width: 16,),
                              InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) => ReprintReceiptPDF(
                                          user: widget.user,
                                          sendDataList: widget.sendDataList,
                                          increment: increment
                                      ));
                                  Navigator.push(context, route);
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 120,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Save PDF',
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.sendDataList.length,
                              itemBuilder: (context, index) {
                                var f = new NumberFormat.currency(
                                    locale: "id_ID", symbol: "Rp ", decimalDigits: 0);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                          top: 16,
                                        ),
                                        child: Text(
                                          'Code: ${widget.sendDataList[index]["productCode"]}',
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
                                        margin: EdgeInsets.only(bottom: 16),
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
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        "No:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                      Text(
                                                        "Name:",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                      Text(
                                                        "Total: ",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
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
                                                      Text(
                                                        "${widget.sendDataList[index]["lineNo"]}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.4,
                                                        child: Text(
                                                          "${widget.sendDataList[index]["productName"]} ",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                      ),
                                                      Text(
                                                        f.format(
                                                            widget.sendDataList[
                                                            index]
                                                            ["lineTotal"]),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
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
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
          var incrementInc = int.parse(increment.toString().replaceAll(".0", ""));
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
          bluetooth.printCustom("[RESTRUCT]", 0, 0);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom(
              "RECEIPT NO: ${widget.user[0]["Code"]}${getTodayDate()}$increment",
              0,
              0);
          bluetooth.printCustom('----------------------------------', 0, 1);

          /// Body Struk
          for (int i = 0; i < widget.sendDataList.length; i++) {
            bluetooth.printCustom(
                'Code: ' + widget.sendDataList[i]['productCode'], 0, 0);
            bluetooth.printCustom(
                'Name: ' + widget.sendDataList[i]['productName'], 0, 0);
            bluetooth.printCustom(
                'Price: ${f.format(widget.sendDataList[i]['lineTotal'])}',
                0,
                0);
            bluetooth.printNewLine();
            bluetooth.printNewLine();
          }
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Sub Total: ${f.format(widget.sendDataList[0]['docTotal'])}", 0, 0);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Grand Total:${f.format(widget.sendDataList[0]['docTotal'])}", 0, 0);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom("Cashier: ${widget.user[0]['UserName']}", 0, 0);
          bluetooth.printNewLine();
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom('Garansi produk tidak berlaku', 0, 1);
          bluetooth.printCustom('untuk produk sepatu promo', 0, 1);
          bluetooth.printCustom('Special Price (SP) dengan harga', 0, 1);
          bluetooth.printCustom('Rp 199.000 kebawah', 0, 1);
          bluetooth.printCustom('----------------------------------', 0, 1);
          bluetooth.printCustom('-- Terima Kasih --', 0, 1);
          bluetooth.printCustom('Harga termasuk PPN', 0, 1);
          bluetooth.printCustom('Special Price (SP) dengan harga', 0, 1);
          bluetooth.printCustom('Barang yang sudah dibeli', 0, 1);
          bluetooth.printCustom('Tidak dapat Dikembalikan/Ditukar', 0, 1);
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

  getIncrement() async {
    String? myIntValue = await getIntFromPrefs("increment");
    if (myIntValue != null) {
      increment = myIntValue;
    }
  }

  // Function to get an integer value from shared preferences
  Future<String?> getIntFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Function to save an integer value to shared preferences
  Future<void> setIntToPrefs(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    String leadingZeroInt = value.toString().padLeft(3, '0');
    prefs.setString(key, leadingZeroInt);
  }

}
