import 'package:bercaretailpos/screens/create_sales_order.dart';
import 'package:bercaretailpos/screens/login_screen.dart';
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
          SizedBox(height: 50,),
          Image.asset('assets/logo.jpg', width: 150, height: 100, fit: BoxFit.cover,),
          SizedBox(height: 50,),

          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: AppColors.green,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Sales',
                      style: TextStyle(
                        color: AppColors.green,
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
                title: Text('Create Sales Order',style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
                onTap: () {
                  Route route =
                  MaterialPageRoute(builder: (context) => CreateSalesOrder(user: widget.user,));
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
                      color: AppColors.green,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: AppColors.green,
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
                title: Text('Logout', style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
