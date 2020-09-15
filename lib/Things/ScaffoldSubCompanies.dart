import 'package:orderapp/services/FireStoreProvider.dart';
import 'package:orderapp/services/CompanyIndexProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScaffoldSubCompanies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<dynamic> products = Provider.of<FireStoreProvider>(context).products;
    var companyIndexProvider = Provider.of<CompanyIndexProvider>(context);
    int companyRightNow = companyIndexProvider.companyIndex;
    Widget topNameTile() {
      return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.deepPurpleAccent, width: 0.2)),
          child: ListTile(
            title: Text(
              products[companyRightNow]['company'],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Divisions'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, '/SearchThing');
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/OrderList');
              },
            )
          ],
        ),
        body: Column(children: <Widget>[
          topNameTile(),
          Expanded(
              child: ListView.builder(
                  itemCount: products[companyIndexProvider.companyIndex]
                          ['divisions']
                      .length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                            trailing: Icon(
                              Icons.assistant,
                              color: Theme.of(context).accentColor,
                            ),
                            onTap: () {
                              companyIndexProvider.change(subcompany: index);
                              Navigator.pushNamed(context, '/ScaffoldItems');
                            },
                            title: Text(
                              products[companyRightNow]['divisions'][index]
                                  ['division'],
                              style: Theme.of(context).textTheme.bodyText2,
                            )));
                  }))
        ]));
  }
}
