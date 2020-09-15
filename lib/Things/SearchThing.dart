import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/Things/Item/ItemCard.dart';
import 'package:orderapp/services/FireStoreProvider.dart';
import 'package:orderapp/services/CompanyIndexProvider.dart';

class SearchThing extends StatefulWidget {
  final bool fromItems;

  const SearchThing({Key key, this.fromItems}) : super(key: key);
  @override
  _SearchThingState createState() => _SearchThingState();
}

class _SearchThingState extends State<SearchThing> {
  TextEditingController textEditingControllerSearch = TextEditingController();
  List<List<int>> subCompanySuggestionList;
  List<List<int>> itemsuggestionList;
  List<List<int>> fSubCompanySuggestionList(
      List<dynamic> products, String query) {
    if (query == '') {
      return null;
    }
    List<List<int>> mylist = [];
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < products[i]['divisions'].length; j++) {
        List<bool> doesContainSubQuery = [];
        for (int x = 0; x < query.split(" ").length; x++) {
          if (products[i]['divisions'][j]['division']
              .toLowerCase()
              .startsWith((query.split(" ")[x]).toLowerCase())) {
            doesContainSubQuery.add(true);
          } else {
            doesContainSubQuery.add(false);
          }
        }
        if (!doesContainSubQuery.contains(false)) {
          mylist.add([i, j]);
        }
      }
    }
    return mylist;
  }

  List<List<int>> fItemSuggestionList(List<dynamic> products, String query) {
    if (query == '') {
      return null;
    }
    List<List<int>> myTitleList = [];
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < products[i]['divisions'].length; j++) {
        for (int k = 0; k < products[i]['divisions'][j]['items'].length; k++) {
          List<bool> doesContainSubQuery = [];
          for (int x = 0; x < query.split(" ").length; x++) {
            if (products[i]['divisions'][j]['items'][k]['name']
                .toLowerCase()
                .startsWith((query.split(" ")[x]).toLowerCase())) {
              doesContainSubQuery.add(true);
            } else {
              doesContainSubQuery.add(false);
            }
          }
          if (!doesContainSubQuery.contains(false)) {
            myTitleList.add([i, j, k]);
          }
        }
      }
    }
    return myTitleList;
  }

  @override
  Widget build(BuildContext context) {
    var companyIndexProvider =
        Provider.of<CompanyIndexProvider>(context, listen: false);
    List<dynamic> products = Provider.of<FireStoreProvider>(context).products;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      textEditingControllerSearch.text = '';
                      subCompanySuggestionList = null;
                      itemsuggestionList = null;
                    });
                  },
                )
              ],
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Items',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Tab(
                      child: Text(
                    'Companies',
                    style: Theme.of(context).textTheme.headline1,
                  ))
                ],
              ),
              title: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Search Anything...',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                    )),
                style: Theme.of(context).textTheme.headline2,
                controller: textEditingControllerSearch,
                onChanged: (String s) {
                  setState(() {
                    subCompanySuggestionList =
                        fSubCompanySuggestionList(products, s);
                    itemsuggestionList = fItemSuggestionList(products, s);
                  });
                },
              ),
            ),
            body: TabBarView(children: <Widget>[
              itemsuggestionList == null
                  ? Container(
                      child: Center(
                          child: Text(
                        'Nothing matches your search:-(',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: Colors.black45),
                      )),
                    )
                  : ListView.builder(
                      itemCount: itemsuggestionList.length,
                      itemBuilder: (context, index) {
                        int company = itemsuggestionList[index][0];
                        int subcompany = itemsuggestionList[index][1];
                        int item = itemsuggestionList[index][2];
                        return ItemCard(
                            fromsearch: true,
                            company: company,
                            subCompany: subcompany,
                            item: item);
                      },
                    ),
              subCompanySuggestionList == null
                  ? Container(
                      child: Center(
                          child: Text(
                        'Nothing matches your search:-(',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: Colors.black45),
                      )),
                    )
                  : ListView.builder(
                      itemCount: subCompanySuggestionList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                                trailing: Icon(
                                  Icons.assistant,
                                  color: Theme.of(context).accentColor,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  companyIndexProvider.change(
                                      company: subCompanySuggestionList[index]
                                          [0],
                                      subcompany:
                                          subCompanySuggestionList[index][1]);

                                  if (widget.fromItems != true) {
                                    Navigator.pushNamed(
                                        context, '/ScaffoldItems');
                                  }
                                },
                                title: Text(
                                  products[subCompanySuggestionList[index][0]]
                                              ['divisions']
                                          [subCompanySuggestionList[index][1]]
                                      ['division'],
                                  style: Theme.of(context).textTheme.bodyText2,
                                )));
                      },
                    ),
            ])));
  }
}
