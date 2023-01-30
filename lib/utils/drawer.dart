import 'package:bercaretailpos/screens/create_sales_order.dart';
import 'package:bercaretailpos/screens/exchange_shift_screen.dart';
import 'package:bercaretailpos/screens/login_screen.dart';
import 'package:bercaretailpos/screens/master/product_screen.dart';
import 'package:bercaretailpos/screens/master/promotion_schedule_screen.dart';
import 'package:bercaretailpos/screens/sales/print_settlement_screen.dart';
import 'package:bercaretailpos/screens/sales/reprint_receipt_screen.dart';
import 'package:bercaretailpos/screens/sales/sales_exchange_screen.dart';
import 'package:bercaretailpos/screens/sales/void_sales_order_screen.dart';
import 'package:bercaretailpos/utils/colors.dart';
import 'package:flutter/material.dart';

class Drawers extends StatefulWidget {
  final List user;

  Drawers({required this.user});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  var isOpen1 = false;
  var isOpen2 = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Image.asset(
            'assets/logo.jpg',
            width: 150,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 50,
          ),
          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.work,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Master',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            initiallyExpanded: isOpen1,
            children: [
              ListTile(
                title: Text(
                  'Promotion Schedule',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => PromotionSchedule( ));
                  Navigator.push(context, route);
                },
              ),
              ListTile(
                title: Text(
                  'Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ProductScreen(
                        user: widget.user,
                      ));
                  Navigator.push(context, route);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Sales',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            initiallyExpanded: isOpen1,
            children: [
              ListTile(
                title: Text(
                  'Reprint Receipt',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ReprintReceipt(
                        user: widget.user,
                      ));
                  Navigator.push(context, route);
                },
              ),
              ListTile(
                title: Text(
                  'Create Sales Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => CreateSalesOrder(
                            user: widget.user,
                          ));
                  Navigator.push(context, route);
                },
              ),
              ListTile(
                title: Text(
                  'Sales Exchange',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => SalesExchangeScreen(
                        user: widget.user,
                      ));
                  Navigator.push(context, route);
                },
              ),
              ListTile(
                title: Text(
                  'Void Sales Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => VoidSalesOrderScreen(
                        user: widget.user,
                      ));
                  Navigator.push(context, route);
                },
              ),
              ListTile(
                title: Text(
                  'Print Settlement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => PrintSettlementScreen(
                        user: widget.user,
                      ));
                  Navigator.push(context, route);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            initiallyExpanded: isOpen2,
            children: [
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                title: Text(
                  'Change Shift',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ExchangeShiftScreen(
                        user: widget.user,
                      ));
                  Navigator.push(context, route);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
