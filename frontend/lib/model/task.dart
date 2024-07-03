import 'package:flutter/material.dart';
class Task {

  late int _taskId;
  late int _boardId;
  late String _boardName;
  late String _taskName;
  late String _taskDescription;
  late int _taskstatus;
  late DateTime _taskCreationDate;
  late List<dynamic> _usersList; // asssigned to 'task'
  late List<dynamic> _userBoardCreator; // board created by ...
  late Color _taskColor;

  Task(int taskId, int boardId, String boardName, String taskName, String taskDescription, int taskstatus, DateTime taskCreationDate, List<dynamic> usersList, List<dynamic> boardCreatedBy,Color taskColor) {
    _taskId = taskId;
    _boardId = boardId;
    _boardName = boardName;
    _taskName = taskName;
    _taskDescription = taskDescription;
    _taskstatus = taskstatus;
    _taskCreationDate = taskCreationDate;
    _usersList = usersList;
    _userBoardCreator = boardCreatedBy;
    _taskColor = taskColor;
  }

  int gettaskId() {
    return _taskId;
  }

  int getboardId() {
    return _boardId;
  }

  String getboardName() {
    return _boardName;
  }

  String gettaskName() {
    return _taskName;
  }

  String gettaskDescription() {
    return _taskDescription;
  }

  int gettaskstatus() {
    return _taskstatus;
  }

  DateTime gettaskcreationDate() {
    return _taskCreationDate;
  }

  List<dynamic> getAssignedToUsers() {
    return _usersList;
  }

  List<dynamic> getboardUserCreator() {
    return _userBoardCreator;
  }

  Color gettaskColor() {
    return _taskColor;
  }

  void settaskId(int taskId) {
    _taskId = taskId;
  }

  void setboardId(int boardId) {
    _boardId = boardId;
  }

  void setboardName(String boardName) {
    _boardName = boardName;
  }

  void settaskName(String taskName) {
    _taskName = taskName;
  }

  void settaskDescription(String taskDescription) {
    _taskDescription = taskDescription;
  }

  void settaskstatus(int taskStatus) {
    _taskstatus = taskStatus;
  }

  void settaskcreationDate(DateTime taskCreationDate) {
    _taskCreationDate = taskCreationDate;
  }

  void setAssignedToListUsers(List<dynamic> listUsers) {
    _usersList = listUsers;
  }
  
  void setBoardCreatedBy(List<dynamic> boardUserCreator) {
    _userBoardCreator = boardUserCreator;
  }

  void settaskColor(Color newTaskColor) {
    _taskColor = newTaskColor;
  }

}
