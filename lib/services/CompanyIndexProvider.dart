import 'package:flutter/material.dart';

class CompanyIndexProvider with ChangeNotifier {
  int _companyIndex, _subcompanyIndex;
  int get companyIndex => _companyIndex;
  int get subcompanyIndex => _subcompanyIndex;
  void change({int company, int subcompany}) {
    if (company != null) _companyIndex = company;
    if (subcompany != null) _subcompanyIndex = subcompany;
    notifyListeners();
  }
}
