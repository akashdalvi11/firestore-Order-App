import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/Things/company/BodyCompanies.dart';
import 'package:orderapp/Things/company/MainDrawer.dart';
import 'package:orderapp/services/FireStoreProvider.dart';
import 'package:orderapp/services/SharedPrefProvider.dart';

class ScaffoldCompanies extends StatelessWidget {
  Widget loading({bool timeConsuming}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text('Loading data...'),
        ),
        timeConsuming ? Text('this might take a while...') : SizedBox.shrink()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    FireStoreProvider fireStoreProvider =
        Provider.of<FireStoreProvider>(context);
    SharedPrefProvider sharedPrefProvider =
        Provider.of<SharedPrefProvider>(context);
    if (fireStoreProvider.notTried) fireStoreProvider.getProducts();
    return Scaffold(
        appBar: fireStoreProvider.products == null
            ? null
            : AppBar(
                title: Text('Companies'),
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
                  ),
                ],
              ),
        drawer: fireStoreProvider.products == null ? null : MainDrawer(),
        body: fireStoreProvider.products == null
            ? sharedPrefProvider.firstTime
                ? Center(
                    child: fireStoreProvider.isConnected
                        ? loading(timeConsuming: true)
                        : Offline(
                            tryAgain: fireStoreProvider.refresh,
                          ))
                : Center(
                    child: fireStoreProvider.syncingUI
                        ? loading(timeConsuming: true)
                        : loading(timeConsuming: false),
                  )
            : BodyCompanies(
                products: fireStoreProvider.products,
              ));
  }
}

class Offline extends StatelessWidget {
  final Function tryAgain;
  const Offline({Key key, this.tryAgain}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(icon: Icon(Icons.replay), onPressed: tryAgain),
        Padding(
            padding: EdgeInsets.only(top: 20), child: Text('you are offline:('))
      ],
    );
  }
}
