import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shree/Things/OrderList/orderListProvider.dart';
import 'package:shree/services/SharedPrefProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class SendOverlay extends StatelessWidget {
  final List<dynamic> products;
  const SendOverlay({Key key, this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String name = Provider.of<SharedPrefProvider>(context).name;
    TextEditingController textEditingController = TextEditingController();
    OrderListProvider orderListProvider =
        Provider.of<OrderListProvider>(context);
    void onTapForBoth(bool which) async {
      List<String> amounts = orderListProvider.quantities;
      List<String> items = [];
      for (int i = 0; i < orderListProvider.orderList.length; i++) {
        items.add(products[orderListProvider.orderList[i][0]]['divisions']
                [orderListProvider.orderList[i][1]]['items']
            [orderListProvider.orderList[i][2]]['name']);
      }
      List<String> subtitles = [];
      for (int i = 0; i < orderListProvider.orderList.length; i++) {
        subtitles.add(products[orderListProvider.orderList[i][0]]['divisions']
                [orderListProvider.orderList[i][1]]['items']
            [orderListProvider.orderList[i][2]]['value']);
      }
      String outputStringEmail = "";
      String outputStringText = "";
      for (int i = 1; i <= amounts.length; i++) {
        outputStringEmail +=
            "$i)%20${items[i - 1]}%20(${subtitles[i - 1]})%20-%20${amounts[i - 1]}<br>";
        outputStringText +=
            "$i) ${items[i - 1]} (${subtitles[i - 1]}) - ${amounts[i - 1]}\n";
      }
      if (which) {
        Share.share("Order By - $name\n" + outputStringText);
      } else {
        launch(
            "mailto:shreeagencies.baramati@gmail.com?subject=Order%20-%20by%20$name&body=" +
                outputStringEmail);
      }
      orderListProvider.tellEveryBody();
    }

    return Center(
      child: Material(
          color: Colors.transparent,
          child: Container(
              margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
              height: 180,
              decoration: ShapeDecoration(
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: TextField(
                            controller: textEditingController,
                            cursorRadius: Radius.circular(10),
                            enableSuggestions: false,
                            autofocus: true,
                            maxLength: 25,
                            maxLengthEnforced: true,
                            style: Theme.of(context).textTheme.headline2,
                            decoration: InputDecoration(
                                labelText: "* optional",
                                labelStyle: TextStyle(color: Colors.white60),
                                counter: SizedBox.shrink(),
                                hintText: name,
                                hintStyle: TextStyle(color: Colors.white38),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue[50])),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ))),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                iconSize: 30,
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  onTapForBoth(true);
                                  Navigator.pop(context);
                                },
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red,
                              child: IconButton(
                                iconSize: 30,
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  onTapForBoth(false);
                                  Navigator.pop(context);
                                },
                              ))),
                    ],
                  ))
                ],
              ))),
    );
  }
}
