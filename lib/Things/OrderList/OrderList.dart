import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shree/Things/OrderList/orderListProvider.dart';
import 'package:shree/services/FireStoreProvider.dart';

import 'SendOverlay.dart';
import 'orderListCard.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderListProvider orderListProvider =
        Provider.of<OrderListProvider>(context);
    List<dynamic> products =
        Provider.of<FireStoreProvider>(context, listen: false).products;

    int lengthoflist = orderListProvider.orderList.length;
    bool anybodySelected = orderListProvider.anybodySelected;

    return Scaffold(
        bottomNavigationBar: lengthoflist == 0
            ? null
            : BottomAppBar(
                child: Padding(
                child: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 30,
                    child: IconButton(
                        color: Colors.white,
                        iconSize: 35,
                        icon: Icon(
                          Icons.done,
                        ),
                        onPressed: !anybodySelected
                            ? () {
                                if (orderListProvider.quantities.contains('')) {
                                  Fluttertoast.showToast(
                                      msg: "Enter the quantities please...");
                                  return;
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) => SendOverlay(
                                          products: products,
                                        ),
                                    barrierDismissible: true);
                              }
                            : null)),
                padding: EdgeInsets.symmetric(vertical: 10),
              )),
        appBar: AppBar(
          leading: anybodySelected
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () => orderListProvider.clearSelection())
              : null,
          backgroundColor: anybodySelected ? Colors.blue[500] : null,
          title: Text(anybodySelected
              ? '${orderListProvider.noOfSelected()} selected'
              : 'Order ($lengthoflist)'),
          actions: anybodySelected
              ? <Widget>[
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => orderListProvider.removeSelected()),
                  IconButton(
                      icon: Icon(Icons.select_all),
                      onPressed: () => orderListProvider.selectAll()),
                ]
              : null,
        ),
        body: lengthoflist == 0
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 200, horizontal: 20),
                child: Text(
                  'Nothing in the order list :( \nAdd some Items.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
              )
            : Column(children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  itemCount: lengthoflist,
                  itemBuilder: (context, index) {
                    TextEditingController controller = TextEditingController();
                    controller.text = orderListProvider.quantities[index];
                    return OrderListCard(
                      products: products,
                      controller: controller,
                      index: index,
                    );
                  },
                )),
              ]));
  }
}
