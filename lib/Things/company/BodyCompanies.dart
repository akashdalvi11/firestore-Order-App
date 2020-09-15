import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/Things/OrderList/orderListProvider.dart';
import 'package:orderapp/services/CompanyIndexProvider.dart';

class BodyCompanies extends StatelessWidget {
  final List<dynamic> products;

  const BodyCompanies({Key key, this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OrderListProvider orderListProvider =
        Provider.of<OrderListProvider>(context, listen: false);
    var companyIndexProvider =
        Provider.of<CompanyIndexProvider>(context, listen: false);

    Future<bool> _onWillPop() async {
      if (Scaffold.of(context).isDrawerOpen) {
        Navigator.pop(context);
        return Future.value(false);
      }
      return (await showDialog(
              context: context,
              builder: (context) {
                int lengthoflist = orderListProvider.orderList.length;
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    'Are you sure?',
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    lengthoflist > 0
                        ? 'Do you want to exit the App?\n (Order list is not empty)'
                        : 'Do you want to exit the App?',
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
              })) ??
          false;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(
                  products[index]['company'],
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                trailing: products[index]['divisions'].length == 1
                    ? Icon(
                        Icons.assistant,
                        color: Theme.of(context).accentColor,
                      )
                    : Icon(
                        Icons.list,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  if (products[index]['divisions'].length == 1) {
                    companyIndexProvider.change(subcompany: 0, company: index);

                    Navigator.pushNamed(context, '/ScaffoldItems');
                  } else {
                    companyIndexProvider.change(company: index);
                    Navigator.pushNamed(context, '/ScaffoldSubCompanies');
                  }
                },
              ));
            }));
  }
}
