import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/Things/OrderList/orderListProvider.dart';
import 'package:orderapp/services/FireStoreProvider.dart';
import 'package:orderapp/services/SharedPrefProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderListProvider orderListProvider =
        Provider.of<OrderListProvider>(context, listen: false);
    FireStoreProvider fireStoreProvider =
        Provider.of<FireStoreProvider>(context, listen: false);
    SharedPrefProvider sharedPrefProvider =
        Provider.of<SharedPrefProvider>(context);
    String name = sharedPrefProvider.name;
    Future<bool> syncingDialog() async {
      return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    'Are you sure?',
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    'Syncing will clear the order list.',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('No'),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: new Text('Yes'),
                    ),
                  ],
                );
              }) ??
          false;
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GettingName(
                        fromDrawer: true,
                      ),
                    ));
              },
              child: Container(
                  height: 200,
                  color: Colors.purple,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          child: Text(
                            name[0].toUpperCase(),
                            style: TextStyle(fontSize: 40),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple,
                        ),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ]))),
          Card(
              child: ListTile(
                  leading: Icon(
                    Icons.business_center,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    'About Us',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/AboutUs');
                  })),
          Card(
              child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    'Order',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/OrderList');
                  })),
          Card(
              child: ListTile(
                  leading: Icon(
                    Icons.sync,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    'Sync Products',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () async {
                    if (orderListProvider.orderList.isEmpty) {
                      Navigator.pop(context);
                      fireStoreProvider.refresh();
                    } else if (await syncingDialog()) {
                      orderListProvider.clearOrder();
                      Navigator.pop(context);

                      fireStoreProvider.refresh();
                    }
                  })),
          sharedPrefProvider.version == 1000
              ? Card(
                  child: ListTile(
                      leading: Icon(
                        Icons.update,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Update Available',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        launch(
                            "https://play.google.com/store/apps/details?id=whatever");
                      }))
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
