import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/Things/OrderList/orderListProvider.dart';

class QuantityDialog extends StatefulWidget {
  final int orderListIndex, company, subcompany, item;
  QuantityDialog({
    Key key,
    this.orderListIndex,
    this.company,
    this.subcompany,
    this.item,
  }) : super(key: key);

  @override
  _LogoutOverlayState createState() => _LogoutOverlayState();
}

class _LogoutOverlayState extends State<QuantityDialog> {
  var textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderListProvider orderListProvider =
        Provider.of<OrderListProvider>(context);
    if (widget.orderListIndex != null) {
      textEditingController.text =
          orderListProvider.quantities[widget.orderListIndex];
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
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
                            cursorRadius: Radius.circular(10),
                            enableSuggestions: false,
                            controller: textEditingController,
                            autofocus: true,
                            maxLength: 20,
                            maxLengthEnforced: true,
                            style: Theme.of(context).textTheme.headline2,
                            decoration: InputDecoration(
                                counter: SizedBox.shrink(),
                                hintText: "Quantity?",
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
                        child: ButtonTheme(
                            height: 35.0,
                            minWidth: 110.0,
                            child: RaisedButton(
                              color: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              splashColor: Colors.white.withAlpha(40),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: ButtonTheme(
                              height: 35.0,
                              minWidth: 110.0,
                              child: RaisedButton(
                                color: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                splashColor: Colors.white.withAlpha(40),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (widget.orderListIndex != null) {
                                    orderListProvider
                                            .quantities[widget.orderListIndex] =
                                        textEditingController.text.trim();
                                  } else {
                                    orderListProvider.addToOrder(
                                        widget.company,
                                        widget.subcompany,
                                        widget.item,
                                        textEditingController.text.trim());
                                  }
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
