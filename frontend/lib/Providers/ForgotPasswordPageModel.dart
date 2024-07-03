import 'package:flutter/material.dart';

class ForgotPasswordPageModel with ChangeNotifier{

  bool _emailIsValid = false;

  bool getemailIsValid() { 
    return _emailIsValid;
  }

  void setemailIsValid(bool new_emailIsValid) {
    _emailIsValid = new_emailIsValid;
    notifyListeners();
  }

}