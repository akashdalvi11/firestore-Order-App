import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/Things/OrderList/orderListProvider.dart';
import 'package:orderapp/services/FireStoreProvider.dart';

import 'QuantityDialog.dart';

class ItemCard extends StatelessWidget {
  final int company, subCompany, item;
  final bool fromsearch;
  const ItemCard({
    Key key,
    this.company,
    this.subCompany,
    this.item,
    this.fromsearch,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<dynamic> products = Provider.of<FireStoreProvider>(context).products;
    OrderListProvider orderListProvider =
        Provider.of<OrderListProvider>(context);
    int orderListIndex =
        orderListProvider.searchInOrder(company, subCompany, item);
    return Card(
        child: ListTile(
      isThreeLine: fromsearch == true,
      title: Text(
        products[company]['divisions'][subCompany]['items'][item]['name'],
        style: Theme.of(context).textTheme.bodyText2,
      ),
      subtitle: Text(
        products[company]['divisions'][subCompany]['items'][item]['value'] +
            (fromsearch == true
                ? '\n' + products[company]['divisions'][subCompany]['division']
                : ''),
      ),
      trailing: orderListIndex != null
          ? Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => QuantityDialog(
                            company: company,
                            subcompany: subCompany,
                            item: item,
                            orderListIndex: orderListIndex,
                          ),
                        );
                      },
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.white,
                        onPressed: () {
                          orderListProvider.removeFromOrder(orderListIndex);
                        },
                      ))
                ],
              ))
          : Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
      onTap: () {
        if (orderListIndex == null) {
          showDialog(
            context: context,
            builder: (_) => QuantityDialog(
              company: company,
              subcompany: subCompany,
              item: item,
            ),
          );
        }
      },
    ));
  }
}
