import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shree/services/SharedPrefProvider.dart';

class FireStoreProvider extends ChangeNotifier {
  List<dynamic> _products;
  List<dynamic> get products => _products;
  bool _notTried = true;
  bool _isConnected;
  bool syncingUI = false;
  DocumentReference _documentReference;
  DocumentReference _fieldsReference;
  FirebaseFirestore firebaseFirestore;
  SharedPrefProvider sharedPrefProvider;
  bool get notTried => _notTried;
  bool get isConnected => _isConnected;
  FireStoreProvider._private();

  static final FireStoreProvider _singleInstance = FireStoreProvider._private();
  static FireStoreProvider get instance => _singleInstance;

  Future<void> initialise() async {
    await Firebase.initializeApp();
    Connectivity().onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.none) {
        _isConnected = true;
      } else {
        _isConnected = false;
      }
    });
    sharedPrefProvider = SharedPrefProvider.instance;
    firebaseFirestore = FirebaseFirestore.instance;
    _documentReference = firebaseFirestore.collection('data').doc('products');
    _fieldsReference = firebaseFirestore.collection('data').doc('fields');
  }

  void getProducts() async {
    if (sharedPrefProvider.firstTime) {
      getProductsFirstTime();
    } else {
      if (_isConnected) {
        DocumentSnapshot documentSnapshot = await _fieldsReference.get();
        int currentVersion = documentSnapshot.data()['version'];
        sharedPrefProvider.version != currentVersion
            ? getProductsOnline(currentVersion)
            : getProductsOffline();
      } else {
        getProductsOffline();
      }
    }
    _notTried = false;
  }

  Future<void> getProductsFirstTime() async {
    if (!_isConnected) return;
    DocumentSnapshot documentSnapshot = await _documentReference.get();
    DocumentSnapshot fieldSnapshot = await _fieldsReference.get();
    await sharedPrefProvider.setVersion(fieldSnapshot.data()['version']);
    await sharedPrefProvider.setfirstTimeFalse();
    _products = convertMapToList(documentSnapshot.data());
    notifyListeners();
  }

  Future<void> getProductsOffline() async {
    DocumentSnapshot documentSnapshot =
        await _documentReference.get(GetOptions(source: Source.cache));
    _products = convertMapToList(documentSnapshot.data());
    notifyListeners();
  }

  Future<void> getProductsOnline(int currentVersion) async {
    syncingUI = true;
    notifyListeners();
    await firebaseFirestore.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(_documentReference);
      await _documentReference.get();
      _products = convertMapToList(documentSnapshot.data());
    });
    await sharedPrefProvider.setVersion(currentVersion);
    syncingUI = false;
    notifyListeners();
  }

  void refresh() {
    if (_isConnected) {
      _products = null;
      Fluttertoast.showToast(msg: "syncing:)");
      notifyListeners();
      getProducts();
      return;
    }
    Fluttertoast.showToast(msg: "you are offline:(");
  }

  List<dynamic> convertMapToList(Map<String, dynamic> m) {
    List<String> companies = m.keys.toList();
    companies.sort();
    List<dynamic> p = [];
    for (int i = 0; i < m.length; i++) {
      p.add({'company': companies[i], 'divisions': m['${companies[i]}']});
    }
    return p;
  }
}
