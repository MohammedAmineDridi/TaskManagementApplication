import 'package:flutter/material.dart';
import '../http/APIs.dart' as API;

class AddBoardPageModel with ChangeNotifier {

  String _userNameFilter = "all";
  Future<List<bool>> _userscheckboxes = API.getListUsers().then((users) {
    List<bool> checkboxes = List<bool>.filled(users.length, false);
    return checkboxes;
  });

  Future<List<bool>> getAllUsersCheckboxsesValues() async {
    return await _userscheckboxes;
  }

  Future<bool> getUserCheckboxValue(int index) async {
    List<bool> checkboxes = await _userscheckboxes;
    return checkboxes[index];
  }

  String getuserNameFilter() {
    return _userNameFilter;
  }

  void reverseUserCheckboxValue(int index) async {
    List<bool> checkboxes = await _userscheckboxes;
    checkboxes[index] = !checkboxes[index];
    notifyListeners();
  }

  void setUserCheckboxValue(int index, bool newvalue) async {
    List<bool> checkboxes = await _userscheckboxes;
    checkboxes[index] = newvalue;
    notifyListeners();
  }

  Future<void> setUserCheckboxValues(List<bool> newValues) async {
    _userscheckboxes = Future.value(newValues);
    notifyListeners();  
  }
  
  void setuserNameFilter(String newUserNameFilter) {
    _userNameFilter = newUserNameFilter;
    notifyListeners();
  }

}