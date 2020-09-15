import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shree/Things/OrderList/orderListProvider.dart';

class OrderListCard extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final List<dynamic> products;
  const OrderListCard({
    Key key,
    this.controller,
    this.index,
    this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderListProvider orderListProvider =
        Provider.of<OrderListProvider>(context);
    return GestureDetector(
        onLongPress: () {
          FocusScope.of(context).unfocus();
          orderListProvider.selectedList[index] =
              !orderListProvider.selectedList[index];
          orderListProvider.updateAnybodySelected();
          orderListProvider.tellEveryBody();
        },
        onTap: () {
          if (orderListProvider.anybodySelected) {
            orderListProvider.selectedList[index] =
                !orderListProvider.selectedList[index];
            orderListProvider.updateAnybodySelected();
            orderListProvider.tellEveryBody();
          }
        },
        child: Card(
          color: orderListProvider.selectedList[index]
              ? Colors.blue[100]
              : Colors.white,
          child: Container(
              width: double.infinity,
              height: 80,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          products[orderListProvider.orderList[index][0]]
                                          ['divisions']
                                      [orderListProvider.orderList[index][1]]
                                  ['items']
                              [orderListProvider.orderList[index][2]]['name'],
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          products[orderListProvider.orderList[index][0]]
                                          ['divisions']
                                      [orderListProvider.orderList[index][1]]
                                  ['items']
                              [orderListProvider.orderList[index][2]]['value'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black38),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 150,
                      child: TextField(
                        cursorColor: Colors.purple,
                        maxLength: 20,
                        enableSuggestions: false,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            counter: SizedBox.shrink()),
                        enabled:
                            orderListProvider.anybodySelected ? false : true,
                        controller: controller,
                        keyboardType: TextInputType.text,
                        onChanged: (String s) {
                          orderListProvider.quantities[index] = s.trim();
                        },
                        onTap: () {
                          controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.text.length));
                        },
                      ))
                ],
              )),
        ));
  }
}
