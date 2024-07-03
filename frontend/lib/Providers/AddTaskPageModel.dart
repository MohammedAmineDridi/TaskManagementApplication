import 'package:flutter/material.dart';

class AddTaskPageModel with ChangeNotifier {

  String? _selectedBoardNameItem;
  String _dateChoosen = DateTime.now().toString().substring(0,10);
  String _timeChoosen = DateTime.now().hour.toString()+":"+DateTime.now().minute.toString();
  late String _dateTimeChoosen = _dateChoosen+" "+_timeChoosen;

  String getDate() { 
    return _dateChoosen;
  }

  String getTime() { 
    return _timeChoosen;
  }

  String getDateTime(){
    return _dateTimeChoosen;
  }

  String? getSelectedBoardNameItem() {
    return _selectedBoardNameItem;
  }

  void setDate(String newDate) {
    _dateChoosen = newDate;
    _dateTimeChoosen = newDate+" "+_timeChoosen;
    notifyListeners();
  }

  void setTime(String newTime) {
    _timeChoosen = newTime;
    _dateTimeChoosen = _dateChoosen+" "+newTime;
    notifyListeners();
  }

  void setDateTime(String newDateTime){
    _dateTimeChoosen = newDateTime;
    notifyListeners();
  }

  void setSelectedBoardNameItem(String newBoardNameSelected) {
    _selectedBoardNameItem = newBoardNameSelected;
    notifyListeners();
  }

}