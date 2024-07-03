import 'package:flutter/material.dart';
import 'package:action_slider/action_slider.dart';
import '../model/task.dart';
import 'package:intl/intl.dart';
import '../http/APIs.dart' as API;
import '../style/style.dart' as style;
import 'package:awesome_dialog/awesome_dialog.dart';

class TaskDetailEdit extends StatelessWidget {

TaskDetailEdit({Key? key, required this.task});

final Task task;
Color screenColor = Color(0xFF081245);

@override
Widget build(BuildContext context) { 

  Size screenSize = MediaQuery.of(context).size;
  int taskId = task.gettaskId();
  String taskName = task.gettaskName();
  String taskDescription = task.gettaskDescription();
  int taskStatus = task.gettaskstatus();
  String reversetaskStatus_String = taskStatus == 0 ? "Done" : "Active";
  String boardName = task.getboardName();
  String timeLeft = formatDuration(DateTime.now(),task.gettaskcreationDate()).toString();
  int nbrAssignedto = task.getAssignedToUsers().length;
  List<dynamic> assignedTo_ListUsers = task.getAssignedToUsers();
  DateTime taskCreatedDate = task.gettaskcreationDate();
  Color taskColor = task.gettaskColor();
  String taskCreatedBy_username =  task.getboardUserCreator()[0]['userName'];
  String taskCreatedBy_photo = task.getboardUserCreator()[0]['photoPath'];

  return Scaffold(
  resizeToAvoidBottomInset: true,
  backgroundColor:taskColor,
  body: Container(
  height: screenSize.height,
  width: screenSize.width,
  child: Column(
  children: [
  // ********************* Drop down icon and delete icon ***************************
  // ROw 1 : (Drop down icon and delete icon)
  SizedBox(height: 30),
  Container(
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Row(children: [
  Container(
  child:IconButton(icon: Icon(Icons.cancel,size:40,color:Colors.black),onPressed: () {
    print("return to main page");
    Navigator.of(context).pushReplacementNamed('tasksboardsList');
  })
  ),
  Spacer(),
  Container(
  child:IconButton(icon: Icon(Icons.delete_forever,size:40,color: Color.fromARGB(255, 232, 136, 112).withOpacity(0.6)),
  onPressed: () {
    print("delete this task");
    style.popUpWidget(context, "Delete Task", "Are your sure to delete this task ?", DialogType.info,onOkPress: () {
    API.deleteTaskById(taskId);
  });
  })
  ),
  ])
  ),
  // ROW 2 = {Board_Name}
  Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Container(
  margin: EdgeInsets.only(top:screenSize.height*0.01,bottom: screenSize.height*0.01,right: screenSize.height*0.01,left:screenSize.height*0.01+20),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  border: Border.all(
  color: Colors.black,
  width: 2.0,
  )),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: FittedBox( 
  fit: BoxFit.contain,
  child: Text(boardName,style: TextStyle(color: Colors.black,fontSize: 15,fontFamily:'Expressway'))
  )
  )
  ],),
  // ROW 3 = {Task_Name}
  Container(
  alignment: Alignment.centerLeft,
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Container(child:Text(taskName,style: TextStyle(color: Colors.black ,fontSize: 32,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),  
  ]),
  ),

  // ROW 4 = Time left & assigned to (for the task)
  Container(
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(child:Text("Time Left",style: TextStyle(color: Colors.black.withOpacity(0.3) ,fontSize: 12,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),
  Container(child:Text(timeLeft,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),  
  ]) , 
  Spacer(),
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(child:Text("Assigned to",style: TextStyle(color: Colors.black.withOpacity(0.6) ,fontSize: 12,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),
  Container(
  height: 50,
  width: 100,
  child: SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  for(int i=0;i<nbrAssignedto;i++)
  Align(
  widthFactor: 0.5,
  child:Padding(
  padding: EdgeInsets.only(left:13),
  child: CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImage( API.serverPath + assignedTo_ListUsers[i]['photoPath'] ),                            
  ))
  )
  ]),
  ) 
  )
  ])
  ]),
  ),
  // ROW 5 : additional task description 
  Container(
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(child:Text("Additional Description",style: TextStyle(color: Colors.black.withOpacity(0.3) ,fontSize: 12,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),
  Container(child:Text(taskDescription,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),  
  ]) , 
  ]),
  ),
  // ROW 6 : Create by & date
  Container(
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(children: [
  Container(child:Text("Created by  ",style: TextStyle(color: Colors.black.withOpacity(0.3),fontSize: 12,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),
  Container(child:Text(taskCreatedBy_username,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),  
  ]),
  Row(children: [
  Container(child:Text("at  ",style: TextStyle(color: Colors.black.withOpacity(0.3) ,fontSize: 12,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),
  Container(child:Text(formatDate(taskCreatedDate),style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),
  ])
  ]) ,
  Spacer(),
  Align(
  widthFactor: 0.5,
  child:Padding(
  padding: EdgeInsets.only(right:screenSize.height*0.03),
  child: CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImage(API.serverPath +taskCreatedBy_photo),                            
  ))
  )
  ]),
  ),
  // ROW 6 : edit the status of the task
  Container(
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  ActionSlider.standard(
  sliderBehavior: SliderBehavior.stretch,
  width: 300.0,
  backgroundColor: Colors.white,
  toggleColor: taskColor,
  action: (controller) async {
  controller.loading(); //starts loading animation
  await Future.delayed(const Duration(seconds: 3));
  controller.success(); //starts success animation
  await Future.delayed(const Duration(seconds: 1));
  controller.reset(); //resets the slider
  print("change the status of the task here");
  print("old task status = "+taskStatus.toString());
  await API.reverseTaskStatus(taskId);
  await Future.delayed(const Duration(seconds: 1));
  Navigator.of(context).pushReplacementNamed('tasksboardsList');
  },
  child: Text("Set As "+reversetaskStatus_String,style: TextStyle(color: Colors.black ,fontSize: 16,fontWeight: FontWeight.bold,fontFamily:'Expressway')),
  ),
  ]),
  ),
  ]
  ) , 
  ),
  );
}
}

String formatDuration(DateTime startTime, DateTime endTime) {
  Duration difference = endTime.difference(startTime);
  String formattedDuration = '${difference.inDays}d ${difference.inHours.remainder(24)}h ${difference.inMinutes.remainder(60)}min';
  return formattedDuration;
}

String formatDate(DateTime date) {
  String formattedDate = DateFormat('dd MMM yyyy', 'fr').format(date);
  return formattedDate;
}

