import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orderapp/Things/OrderList/OrderList.dart';
import 'package:orderapp/Things/OrderList/orderListProvider.dart';
import 'package:orderapp/services/SharedPrefProvider.dart';
import 'services/FireStoreProvider.dart';
import 'services/CompanyIndexProvider.dart';
import 'package:orderapp/JustScreens/AboutUs.dart';
import 'package:orderapp/Things/ScaffoldSubCompanies.dart';
import 'package:orderapp/Things/SearchThing.dart';
import 'package:orderapp/Things/company/ScaffoldCompanies.dart';

import 'Things/Item/ScaffoldItems.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await FireStoreProvider.instance.initialise();
  await SharedPrefProvider.instance.initialize();
  runApp(MaterialHome());
}

class MaterialHome extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CompanyIndexProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FireStoreProvider.instance,
        ),
        Provider(create: (context) => SharedPrefProvider.instance)
      ],
      child: MaterialApp(
          title: "orderapp",
          theme: ThemeData(
              primarySwatch: Colors.purple,
              fontFamily: 'ebrima',
              cursorColor: Colors.white,
              inputDecorationTheme: InputDecorationTheme(),
              accentColor: Colors.blue[700],
              textTheme: TextTheme(
                  headline2: TextStyle(fontSize: 20, color: Colors.white),
                  bodyText1: TextStyle(fontSize: 20),
                  bodyText2: TextStyle(fontSize: 18),
                  headline1: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ))),
          initialRoute: '/ScaffoldCompanies',
          routes: {
            '/ScaffoldCompanies': (context) => ScaffoldCompanies(),
            '/ScaffoldSubCompanies': (context) => ScaffoldSubCompanies(),
            '/ScaffoldItems': (context) => ScaffoldItems(),
            '/SearchThing': (context) => SearchThing(),
            '/OrderList': (context) => OrderList(),
          }),
    );
  }
}
