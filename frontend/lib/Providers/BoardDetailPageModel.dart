import 'package:flutter/material.dart';

class BoardDetailPageModel with ChangeNotifier {

  bool _taskStatus_selected = false;
  bool _taskCreationDate_selected = false;
  bool _taskName_selected = false;
  String _taskName = " ";
  String _statusFilterAPI = " ";
  List<bool> _statusFilter = [false,false];
  List<String> _dateFilter = [" "," "];

  String gettaskName() { 
    return _taskName; 
  }
   
  String gettaskStatus() { 
    return _statusFilterAPI; 
  }

  bool gettaskStatus_selected() {
    return _taskStatus_selected;
  }

  bool gettaskCreationDate_selected() { 
    return _taskCreationDate_selected;
  }

  bool gettaskName_selected() { 
    return _taskName_selected;
  }

  List<bool> getStatusFilter() { 
    return _statusFilter;
  }

  List<String> getDateFilter() { 
    return _dateFilter;
  }

  void settaskStatus_selected(bool newtaskStatus_selected) {
    _taskStatus_selected = newtaskStatus_selected;
    notifyListeners();
  }

  void settaskCreationDate_selected(bool newtaskCreationDate_selected) {
    _taskCreationDate_selected = newtaskCreationDate_selected;
    notifyListeners();
  }

  void settaskName_selected(bool newtaskName_selected) {
    _taskName_selected = newtaskName_selected;
    notifyListeners();
  }

  void settaskName(String newTaskName) {
    _taskName = newTaskName;
    notifyListeners();
  }

  void settaskStatus(String newTaskStatus) {
    _statusFilterAPI = newTaskStatus;
    notifyListeners();
  }
 
  void reverseTaskStatus_selected() {
    _taskStatus_selected = !_taskStatus_selected;
    notifyListeners();
  }
  
  void reverseTaskCreationDate_selected() {
    _taskCreationDate_selected = !_taskCreationDate_selected;
    notifyListeners();
  }

  void reverseTaskName_selected() {
    _taskName_selected = !_taskName_selected;
    notifyListeners();
  }

  void reverseStatusActive() {
    if (_statusFilter[1] == false) {
      _statusFilter[0] = !_statusFilter[0];
    }
    if (_statusFilter[1] == true) {
      _statusFilter[1] = !_statusFilter[1];
      _statusFilter[0] = !_statusFilter[0];
    }
    notifyListeners();
  }

  void reverseStatusDone() {
    if (_statusFilter[0] == false) {
      _statusFilter[1] = !_statusFilter[1];
    }
    if (_statusFilter[0] == true) {
      _statusFilter[0] = !_statusFilter[0];
      _statusFilter[1] = !_statusFilter[1];
    }
    notifyListeners();
  }

  void setStatusFilter(List<bool> newvalue) {
    _statusFilter = newvalue;
  }

  void setStartDate(String newStartDateFilter) {
    _dateFilter[0] = newStartDateFilter;
    notifyListeners();
  }

  void setEndDate(String newEndDateFilter) {
    _dateFilter[1] = newEndDateFilter;
    notifyListeners();
  }

  void resetDate(List<String> newDates) {
    _dateFilter = newDates;
    notifyListeners();
  }

}