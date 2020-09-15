import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/services/FireStoreProvider.dart';
import 'package:orderapp/Things/SearchThing.dart';
import 'package:orderapp/services/CompanyIndexProvider.dart';
import 'ItemCard.dart';

class ScaffoldItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<dynamic> products = Provider.of<FireStoreProvider>(context).products;
    var companyIndexProvider = Provider.of<CompanyIndexProvider>(context);
    int companyRightNow = companyIndexProvider.companyIndex;
    int subCompanyRightNow = companyIndexProvider.subcompanyIndex;
    Widget topNameTile() {
      return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.deepPurpleAccent, width: 0.2)),
          child: ListTile(
            title: Text(
              products[companyRightNow]['divisions'][subCompanyRightNow]
                  ['division'],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ));
    }

    void navigationTask() {
      if (products[companyRightNow]['divisions'].length == 1) {
        Navigator.popUntil(context, ModalRoute.withName('/ScaffoldCompanies'));
      } else {
        Navigator.pop(context);
      }
    }

    return WillPopScope(
        onWillPop: () {
          navigationTask();
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchThing(
                              fromItems: true,
                            ),
                          ));
                    }),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.pushNamed(context, '/OrderList'),
                ),
              ],
              title: Text('Items'),
            ),
            body: Column(
              children: <Widget>[
                topNameTile(),
                Expanded(
                    child: ListView.builder(
                        itemCount: products[companyRightNow]['divisions']
                                [subCompanyRightNow]['items']
                            .length,
                        itemBuilder: (context, index) {
                          return ItemCard(
                            company: companyRightNow,
                            subCompany: subCompanyRightNow,
                            item: index,
                          );
                        }))
              ],
            )));
  }
}
