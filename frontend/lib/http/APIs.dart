/******************************************************** APIs LIB ******************************************************* */

import 'package:dio/dio.dart';
import 'dart:io';
import 'package:my_app1/model/user.dart';

Dio dio = Dio();

bool httpConfiguration = true;

String serverPath = "http://192.168.100.115:3000/taskManagerApplication/images/users/";  

void HttpConfig(String serverName, int port) {
  dio.options.baseUrl = "http://"+serverName+":"+port.toString();
  print("BASE URL CONFIG : "+dio.options.baseUrl.toString());
  dio.options.connectTimeout = Duration(seconds: 5);
  dio.options.receiveTimeout = Duration(seconds: 5);
  httpConfiguration = false;
}

/********************************************** WELCOME PAGE APIs *********************************************** */

Future<List<dynamic>> login(String email, String password) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/login/'+email+"/"+password);
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> tasksDonePercentage(int userId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getPercentageTasksDone/'+userId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> nbrActiveTasks(int userId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getNbrActiveTasks/'+userId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> nbrActiveTasksBoard(int userId, int boardId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getNbrActiveTasks_Board/'+userId.toString()+"/"+boardId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

/********************************************** CREATE ACCOUNT PAGE APIs *********************************************** */

Future<void> addUser(User user, File userImage) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    String imageName = userImage.path.split('/').last;
    FormData formData = FormData.fromMap({
      'userName': user.getuserName(),
      'email': user.getemail(),
      'password': user.getpassword(),
      'phoneNumber': user.getphoneNumber(),
      // Assuming you have the photo file to send
      'Photo': await MultipartFile.fromFile(userImage.path, filename: imageName),
    });
    Response response = await dio.post(
      '/addUser',
      data: formData,
    );
    if (response.statusCode == 200) {
      print('User added successfully');
      print(response.data);
    } else {
      print('Failed to add user');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

/********************************************** FORGOT PASSWORD PAGE APIs *********************************************** */

Future<List<dynamic>> resetPassword(String email) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/resetUserPassword/'+email);
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> sendEmail(String to,String subject,String message) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/sendmail/'+to+"/"+subject+"/"+message);
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getUserById(int userId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/users/'+userId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

/********************************************** MAIN PAGE APIs *********************************************** */


Future<List<dynamic>> getUserImage(String userImage) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/taskManagerApplication/images/users/'+userImage);
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getListUsers() async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/users');
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}


Future<List<dynamic>> getAllUsersExcept(int userId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/usersExcept/'+userId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getListTasks(int userId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getListTasks/'+userId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getListTasksByBoardId(int userId, int boardId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getListTasksByBoardId/'+userId.toString()+"/"+boardId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getListTasksFilter(int userId, String taskCreationDate, String taskStatus) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getListTasksFilter/'+userId.toString()+"/"+taskCreationDate.toString()+"/"+taskStatus.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getListBoards(int userId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getListBoards/'+userId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getListUsersBoards(int boardId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getListUsers_Boards/'+boardId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getNOTListUsersBoards(int boardId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/get_NOT_ListUsers_Boards/'+boardId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

/********************************************** ADD TASK PAGE APIs *********************************************** */

Future<void> addTask(int boardId, String taskName, String taskDescription, int taskStatus, String taskCreationDate) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Map<String,dynamic> formDataAddTask = {
      'boardId': boardId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskStatus': taskStatus,
      'taskCreationDate': taskCreationDate,
    };
    Response response = await dio.post(
      '/addTask',
      data: formDataAddTask,
    );
    if (response.statusCode == 200) {
      print('Task added successfully');
      print(response.data);
      // get task_id of that task added new
      String taskId = await getLastTaskId();
      // if task is added directly here (update taskslist 'append taskid' column in boards table 'add this task to board x')
      updateBoard_addTaskToBoard(boardId,taskId);
    } else {
      print('Failed to add task');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

/********************************************** ADD BOARD PAGE APIs *********************************************** */

Future<List<dynamic>> getUserFilterByUserName(int userId, String userName) async {
  String url = "";
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    if (userName == "all") { 
    url = "/usersExcept/"+userId.toString();
    } else if (userName != "all") {
    url ="/usersFilterByUserName/"+userId.toString()+"/"+userName;
    }
    Response response = await dio.get(url);
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<void> addBoard(String boardName, int createdBy, String assignedTo) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Map<String,dynamic> formDataAddBoard = {
      'name': boardName,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
    };
    Response response = await dio.post(
      '/addBoard',
      data: formDataAddBoard,
    );
    if (response.statusCode == 200) {
      print('Board added successfully');
      print(response.data);
    } else {
      print('Failed to add board');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<List<dynamic>> updateBoard_addTaskToBoard(int boardId, String TaskId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/updateBoard_addTaskToBoard/'+boardId.toString()+"/"+TaskId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> updateBoard_addUserToBoard(int boardId, int userId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/updateBoard_addUserToBoard/'+boardId.toString()+"/"+userId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<String> getLastTaskId() async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getLastTaskId');
    print((response.data)[0]['id'].toString());
    return ( (response.data)[0]['id'].toString() );
  } catch (e) {
    print("Error occurred: $e");
    return "";
  }
}

/********************************************** TASK DETAIL PAGE APIs *********************************************** */

Future<List<dynamic>> getBoardCreatorUser(int boardId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getBoardCreatorUser/'+boardId.toString());
    print(response.data);
    return (response.data);
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> reverseTaskStatus(int tasKId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/reverseTaskStatus/'+tasKId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> deleteTaskById(int taskId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/deleteTask/'+taskId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> deleteBoardById(int boardId) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/deleteBoard/'+boardId.toString());
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}

Future<List<dynamic>> getListTasksByBoardIdFilter(int userId, int boardId, String taskName, String taskStatus, String taskDateMin, String taskDateMax) async {
  if (httpConfiguration) {
    HttpConfig("192.168.100.115",3000);
  }
  try {
    Response response = await dio.get('/getListTasksByBoardId_Filter/'+userId.toString()+"/"+boardId.toString()+"/"+taskName+"/"+taskStatus+"/"+taskDateMin+"/"+taskDateMax);
    print(response.data);
    return response.data;
  } catch (e) {
    print("Error occurred: $e");
    return [];
  }
}