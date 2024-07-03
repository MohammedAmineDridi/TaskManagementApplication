import 'package:flutter/material.dart';
class Board {

  late int _boardId;
  late String _boardName;
  late List<dynamic> _taskList;
  late List<dynamic> _createdBy;
  late List<dynamic> _assignedTo;
  late Color _boardColor;

  Board(int boardId, String boardName, List<dynamic> taskList, List<dynamic> createdBy, List<dynamic> assignedTo,Color boardColor) {
    _boardId = boardId;
    _boardName = boardName;
    _taskList = taskList;
    _createdBy = createdBy;
    _assignedTo = assignedTo;
    _boardColor = boardColor;
  }
  
  int getboardId() {
    return _boardId;
  }

  String getboardName() {
    return _boardName;
  }

  List<dynamic> gettaskList() {
    return _taskList;
  }

  List<dynamic> getcreatedBy() {
    return _createdBy;
  }

  List<dynamic> getassignedTo() {
    return _assignedTo;
  }

  Color getboardColor() {
    return _boardColor;
  }

  void setboardId(int boardId) {
    _boardId = boardId;
  }

  void setboardName(String boardName) {
    _boardName = boardName; 
  }

  void settaskList(List<dynamic> listTasks) {
    _taskList = listTasks;
  }

  void setcreatedBy(List<dynamic> user) {
    _createdBy = user;
  }
  
  void setassignedTo(List<int> userIds) {
    _assignedTo = userIds;
  }

  void setboardColor(Color newBoardColor) {
    _boardColor = newBoardColor;
  }

}