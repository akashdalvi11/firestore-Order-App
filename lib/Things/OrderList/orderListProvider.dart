import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrderListProvider with ChangeNotifier {
  List<List<int>> orderList = [];
  List<bool> selectedList = [];
  List<String> quantities = [];
  bool anybodySelected = false;
  void tellEveryBody() {
    notifyListeners();
  }

  void updateAnybodySelected() => selectedList.contains(true)
      ? anybodySelected = true
      : anybodySelected = false;
  int noOfSelected() {
    int count = 0;
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) count += 1;
    }
    return count;
  }

  void clearOrder() {
    orderList = [];
    selectedList = [];
    quantities = [];
    updateAnybodySelected();
  }

  addToOrder(int company, int subcompany, int item, String quantity) {
    orderList.add([company, subcompany, item]);
    quantities.add(quantity);
    selectedList.add(false);
    notifyListeners();
  }

  removeFromOrder(int index) {
    orderList.removeAt(index);
    quantities.removeAt(index);
    selectedList.removeAt(index);
    notifyListeners();
  }

  searchInOrder(int company, int subcompany, int item) {
    for (int i = 0; i < orderList.length; i++) {
      if (orderList[i][0] == company &&
          orderList[i][1] == subcompany &&
          orderList[i][2] == item) {
        return i;
      }
    }
    return null;
  }

  void selectAll() {
    for (int i = 0; i < selectedList.length; i++) {
      selectedList[i] = true;
    }
    notifyListeners();
  }

  void removeSelected() {
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) {
        orderList[i] = null;
        quantities[i] = null;
      }
    }
    while (true) {
      if (selectedList.contains(true)) {
        selectedList.remove(true);
      } else if (orderList.contains(null)) {
        int index = orderList.indexOf(null);
        orderList.removeAt(index);
        quantities.removeAt(index);
      } else {
        break;
      }
    }
    updateAnybodySelected();
    notifyListeners();
  }

  void clearSelection() {
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) {
        selectedList[i] = false;
      }
    }
    updateAnybodySelected();
    notifyListeners();
  }
}
