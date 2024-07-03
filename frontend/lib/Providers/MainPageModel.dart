import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../http/APIs.dart' as API;

class MainPageModel with ChangeNotifier{

  List<bool> _statusFilter = [false,false];
  List<String> _selectedDate_Status = [DateFormat('yyyy-MM-dd').format(DateTime.now()),"all"];
  Future<List<bool>> _userscheckboxes = API.getListUsers().then((users) {
    List<bool> checkboxes = List<bool>.filled(users.length, false);
    return checkboxes;
  });

  Future<List<dynamic>>? _listUsersPerBoard;

  Future<List<dynamic>>? getListUsersPerBoard(){
    return _listUsersPerBoard;
  }

  List<bool> getStatusFilter() { 
    return _statusFilter;
  }
  
  List<String> getselectedDate_Status() { 
    return _selectedDate_Status;
  }

  Future<bool> getUserCheckboxValue(int index) async {
    List<bool> checkboxes = await _userscheckboxes;
    return checkboxes[index];
  }

  void setListUsersPerBoard(Future<List<dynamic>>? usersList){
    _listUsersPerBoard = usersList;
    notifyListeners();
  }

  void reverseStatusActive() {
    if (_statusFilter[1] == false) {
      _statusFilter[0] = !_statusFilter[0];
    }
    if (_statusFilter[1] == true){
      _statusFilter[1] = !_statusFilter[1];
      _statusFilter[0] = !_statusFilter[0];
    }
    notifyListeners();
  }

  void reverseStatusDone() {
    if (_statusFilter[0] == false) {
      _statusFilter[1] = !_statusFilter[1];
    }
    if (_statusFilter[0] == true){
      _statusFilter[0] = !_statusFilter[0];
      _statusFilter[1] = !_statusFilter[1];
    }
    notifyListeners();
  }

  void setselectedDate_Status(String newDate, String newStatus) {
    _selectedDate_Status[0] = newDate;
    _selectedDate_Status[1] = newStatus;
    notifyListeners();
  }

  void reverseUserCheckboxValue(int index) async {
    List<bool> checkboxes = await _userscheckboxes;
    checkboxes[index] = !checkboxes[index];
    notifyListeners();
  }

}