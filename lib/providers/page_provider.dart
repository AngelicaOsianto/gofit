import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  int _currentIndex = 0; // Default: 0 (Home)

  int get currentIndex => _currentIndex;

  void setPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}