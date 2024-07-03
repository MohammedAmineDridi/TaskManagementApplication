import 'package:flutter/material.dart';

class WelcomePageModel with ChangeNotifier {

  bool _emailIsValid = false;
  bool _passwordIsobscure = true;
  bool _checkboxStatus = false;

  bool getemailIsValid() {
     return _emailIsValid;
  }

  bool getpasswordIsobscure() { 
    return _passwordIsobscure;
  }

  bool getcheckboxStatus() { 
    return _checkboxStatus;
  }

  void setemailIsValid(bool newEmailIsValid) {
    _emailIsValid = newEmailIsValid;
    notifyListeners();
  }

  void setpasswordIsobscure() {
    _passwordIsobscure = !_passwordIsobscure;
    notifyListeners();
  }

  void reversecheckboxStatus() {
    _checkboxStatus = !_checkboxStatus;
    notifyListeners();
  }

}