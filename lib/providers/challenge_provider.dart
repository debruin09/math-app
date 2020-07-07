import 'package:flutter/material.dart';

class Challenge with ChangeNotifier {
  String _paper;
  int _duration;
  String _question;

  set paper(val) {
    _paper = val;
    notifyListeners();
  }

  set duration(val) {
    _duration = val;
    notifyListeners();
  }

  set question(val) {
    _question = val;
    notifyListeners();
  }

  String get paper => _paper;
  int get duration => _duration;
  String get question => _question;
}
