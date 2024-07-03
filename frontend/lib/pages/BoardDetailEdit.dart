import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../Providers/BoardDetailPageModel.dart';
import '../model/board.dart';
import '../model/task.dart';
import '../http/APIs.dart' as API;
import '../style/style.dart' as style;
import 'package:awesome_dialog/awesome_dialog.dart';

TextEditingController taskNameController = TextEditingController();
TextEditingController taskStartDateController = TextEditingController();
TextEditingController taskEndDateController = TextEditingController();
DateTime current_date = DateTime.now();

class BoardDetailEdit extends StatelessWidget {

  BoardDetailEdit({Key? key, required this.board});

  Color screenColor = Color(0x081245);
  final Board board;

  @override
  Widget build(BuildContext context) {

  String boardName = board.getboardName();
  Color boardColor = board.getboardColor();
  int boardId = board.getboardId();
  Size screenSize = MediaQuery.of(context).size;
  return ChangeNotifierProvider(
  create: (_) => BoardDetailPageModel(),
  child: Scaffold(
  resizeToAvoidBottomInset: true,
  backgroundColor:boardColor,
  body: SingleChildScrollView(child:Container(
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
    print("delete this board");
    style.popUpWidget(context, "Delete Board", "Are your sure to delete this board ?", DialogType.info,onOkPress: () {
    API.deleteBoardById(boardId);
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
  // ROW 3 = filter tasks by (taskStatus / Task CreationDate / taskName )
  Container(
  alignment: Alignment.center,
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Icon(Icons.filter_alt_sharp,color:Colors.black),
  SizedBox(width:10),
  // filter : task status
  Selector<BoardDetailPageModel, bool>(
  selector: (context, model) => model.gettaskStatus_selected(),
  builder: (context, statusFilter, _) {
  return GestureDetector(child: Container(
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(color: context.watch<BoardDetailPageModel>().gettaskStatus_selected() ?Color(0xFF7195EE):null,borderRadius: BorderRadius.circular(30)) ,   
  child:Center(child:Text("Task Status",style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.black)))
  ),
  onTap: () {
    print("enable task filtred by status (reverse task filter)");
    context.read<BoardDetailPageModel>().reverseTaskStatus_selected();
    // reset active/done if StatusFilter is not set
    if (  context.read<BoardDetailPageModel>().gettaskStatus_selected() == false ) {
      context.read<BoardDetailPageModel>().setStatusFilter([false,false]);
    }
  },
  );
  }),
  // fitler : task date
  SizedBox(width:10),
  Selector<BoardDetailPageModel, bool>(
  selector: (context, model) => model.gettaskCreationDate_selected(),
  builder: (context, statusFilter, _) {
  return GestureDetector(child: Container(
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(color: context.watch<BoardDetailPageModel>().gettaskCreationDate_selected() ?Color(0xFF7195EE):null,borderRadius: BorderRadius.circular(30)) ,   
  child:Center(child:Text("Task Date",style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.black)))
  ),
  onTap: () {
    print("enable task filtred by date (reverse task date)");
    context.read<BoardDetailPageModel>().reverseTaskCreationDate_selected();
    // reset taskName if taskNameFilter is not selected
    if (context.read<BoardDetailPageModel>().gettaskCreationDate_selected() == false) {
      context.read<BoardDetailPageModel>().resetDate([" "," "]);
    }
    taskStartDateController.text = " ";
    taskEndDateController.text = " ";
  },
  );
  }),
  // filter : task name
  SizedBox(width:10),
  Selector<BoardDetailPageModel, bool>(
  selector: (context, model) => model.gettaskName_selected(),
  builder: (context, statusFilter, _) {
  return GestureDetector(child: Container(
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(color: context.watch<BoardDetailPageModel>().gettaskName_selected() ?Color(0xFF7195EE):null,borderRadius: BorderRadius.circular(30)) ,   
  child:Center(child:Text("Task Name",style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.black)))
  ),
  onTap: () {
    print("enable task filtred by taskName (reverse task name)");
    context.read<BoardDetailPageModel>().reverseTaskName_selected();
    // reset taskName if taskNameFilter is not selected
    if (context.read<BoardDetailPageModel>().gettaskName_selected() == false) {
      taskNameController.text = "";
    }
  },
  );
  })
  ]),
  ),
  // ROW 4 = filter container (textfield for taskname' / date picker for 'taskdate' / circles for 'task status')
  Container(
  alignment: Alignment.centerLeft,
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  // filter task name bloc
  Selector<BoardDetailPageModel, bool>(
  selector: (context, model) => model.gettaskName_selected(),
  builder: (context, statusFilter, _) {
  return context.watch<BoardDetailPageModel>().gettaskName_selected() ? Container (
  padding: EdgeInsets.only(bottom:15),
  child:Row(children: [
  Text("Task Name ",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
  SizedBox(width: 12),
  Expanded(child:TextField(
  controller: taskNameController,
  cursorColor: Colors.black,
  style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.black),
  decoration: InputDecoration(
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.black, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.black, width: 2.0)),
  hintText: "Task Name" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.black) , 
  prefixIcon: Icon(Icons.task,color: Colors.black)
  ),
  onChanged: (newtaskName) {
    if (newtaskName == "") {
      newtaskName = " ";
    }
    print("new task name = "+newtaskName.toString());
    context.read<BoardDetailPageModel>().settaskName(newtaskName);
  },
  )),
  ])) : SizedBox(height:2);
  }),
  // filter task status bloc
  Selector<BoardDetailPageModel, bool>(
  selector: (context, model) => model.gettaskStatus_selected(),
  builder: (context, statusFilter, _) {
  return context.watch<BoardDetailPageModel>().gettaskStatus_selected() ? Container(
  padding: EdgeInsets.only(bottom:15),
  child:Row(children: [
  Text("Task Status ",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
  SizedBox(width:10),
  Selector<BoardDetailPageModel, List<bool>>(
  selector: (context, model) => model.getStatusFilter(),
  builder: (context, statusFilter, _) {
  return GestureDetector(child: Container(
  width: 90,
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(color:context.watch<BoardDetailPageModel>().getStatusFilter()[0]?Color(0xFF7195EE):null,borderRadius: BorderRadius.circular(30)) ,   
  child:Center(child:Text("Active",style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.black)))
  ),
  onTap: () {
    context.read<BoardDetailPageModel>().reverseStatusActive();
    if (context.read<BoardDetailPageModel>().getStatusFilter()[0]) {
      print("filter status : active is set");
      context.read<BoardDetailPageModel>().settaskStatus("0");
    } else {
      print("filter status : active is not set");
      context.read<BoardDetailPageModel>().settaskStatus(" ");
    }
  },
  );
  }),

  SizedBox(width:10),

  Selector<BoardDetailPageModel, List<bool>>(
  selector: (context, model) => model.getStatusFilter(),
  builder: (context, statusFilter, _) {
  return GestureDetector(child: Container(
  width: 90,
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(color:context.watch<BoardDetailPageModel>().getStatusFilter()[1]?Color(0xFF7195EE):null,borderRadius: BorderRadius.circular(30)) ,   
  child:Center(child:Text("Done",style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.black)))
  ),
  onTap: () {
    context.read<BoardDetailPageModel>().reverseStatusDone();
    if (context.read<BoardDetailPageModel>().getStatusFilter()[1]) {
      print("filter status : done is set");
      context.read<BoardDetailPageModel>().settaskStatus("1");
    } else {
      print("filter status : done is not set");
      context.read<BoardDetailPageModel>().settaskStatus(" ");
    }
  },
  );
  }),                   
  ])) : SizedBox(height:2);
  }),
  // filter task date bloc
  Selector<BoardDetailPageModel, bool>(
  selector: (context, model) => model.gettaskCreationDate_selected(),
  builder: (context, statusFilter, _) {
  return context.watch<BoardDetailPageModel>().gettaskCreationDate_selected() ? Container(
  padding: EdgeInsets.only(bottom:15),
  child:Row(children: [
  Text("Task Date ",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
  SizedBox(width:12),
  Selector<BoardDetailPageModel, List<String>>(
  selector: (context, model) => model.getDateFilter(),
  builder: (context, statusFilter, _) {
  return Expanded(
  child: Padding(
  padding: EdgeInsets.only(left:10),
  child: TextField(
  readOnly: true,
  controller: taskStartDateController,
  cursorColor: Colors.black,
  style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.black),
  decoration: InputDecoration(
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.black, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.black, width: 2.0)),
  hintText: "Start Date" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.black) , 
  prefixIcon: Icon(Icons.date_range_outlined,color: Colors.black)
  ),
  onTap: () async {
    final DateTime? dateTime = await showDatePicker(
    context: context, 
    initialDate: current_date,
    firstDate: DateTime(2000), 
    lastDate: DateTime(3000),
    builder: (BuildContext context, Widget? child) {
    return Theme(
    data: ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
    primary: Color(0xFF7195EE) , // Header background color
    onPrimary: Colors.black, // Header text color
    onSurface: Colors.black, // Body text color
    ),
    dialogBackgroundColor: Colors.black, 
    ),
    child: child!,
    );
    },
    );
    print("++++++ new start date = "+dateTime.toString().substring(0,19));
    context.read<BoardDetailPageModel>().setStartDate(dateTime.toString().substring(0,11));
    taskStartDateController.text = context.read<BoardDetailPageModel>().getDateFilter()[0];
  },
  )
  ));
  }),

  SizedBox(width:10),

  Selector<BoardDetailPageModel, List<String>>(
  selector: (context, model) => model.getDateFilter(),
  builder: (context, statusFilter, _) {
  return Expanded(
  child: Padding(
  padding: EdgeInsets.only(left:10),
  child: TextField(
  readOnly: true,
  controller: taskEndDateController,
  cursorColor: Colors.black,
  style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.black),
  decoration: InputDecoration(
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.black, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.black, width: 2.0)),
  hintText: "End Date" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.black) , 
  prefixIcon: Icon(Icons.date_range_outlined,color: Colors.black)
  ),
  onTap: () async {
    final DateTime? dateTime = await showDatePicker(
    context: context, 
    initialDate: current_date,
    firstDate: DateTime(2000), 
    lastDate: DateTime(3000),
    builder: (BuildContext context, Widget? child) {
    return Theme(
    data: ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
    primary: Color(0xFF7195EE) ,
    onPrimary: Colors.black,
    onSurface: Colors.black,
    ),
    dialogBackgroundColor: Colors.black,
    ),
    child: child!,
    );
    },
    );
    print("++++++ new end date = "+dateTime.toString().substring(0,19));
    context.read<BoardDetailPageModel>().setEndDate(dateTime.toString().substring(0,11));
    taskEndDateController.text = context.read<BoardDetailPageModel>().getDateFilter()[1];
  },
  )
  ));
  }),
  ])) : SizedBox(height:2);
  }),
  ]),
  ),
  // ROW 5 = List of tasks
  Expanded(
  child: ListView(
  shrinkWrap: true,
  children: CustomTasksCards(board,context)
  ),
  ),
  ]
  ) , 
  ),)
  )
  );
  }
}

String formatDuration(DateTime startTime, DateTime endTime) {
Duration difference = endTime.difference(startTime);
String formattedDuration = '${difference.inDays}d ${difference.inHours.remainder(24)}h ${difference.inMinutes.remainder(60)}min';
return formattedDuration;
}

List<Widget> CustomTasksCards(Board board, BuildContext context) {
  List<Widget> containers = [];
  String boardName = board.getboardName();
  int boardId = board.getboardId();
  containers.add(
  FutureBuilder<SharedPreferences>(
  future: SharedPreferences.getInstance(),
  builder: (context, userSnapshot) {
  if (userSnapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
  } else if (userSnapshot.hasError) {
    return Center(child: Text('Error: ${userSnapshot.error}'));
  } else if (userSnapshot.hasData) {
    SharedPreferences prefs = userSnapshot.data!;
    int? user_id = prefs.getInt("id");
    if (user_id == null) {
      return Center(child: Text('User ID not found'));
    }
    return Selector<BoardDetailPageModel, BoardDetailPageModel>(
    selector: (context, model) => model,
    builder: (context, boardDetailPageModel, _) {
    return FutureBuilder<List<dynamic>?>(
    future: API.getListTasksByBoardIdFilter(
    user_id,
    boardId,
    context.watch<BoardDetailPageModel>().gettaskName(),
    context.watch<BoardDetailPageModel>().gettaskStatus(),
    context.watch<BoardDetailPageModel>().getDateFilter()[0],
    context.watch<BoardDetailPageModel>().getDateFilter()[1],
    ),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData) {
      List<dynamic>? listTasksFiltered = snapshot.data;
      if (listTasksFiltered == null || listTasksFiltered.isEmpty) {
        return Center(child: Text(""));
    }
    int j =0;
    List<Widget> taskContainers = listTasksFiltered.map((taskData) {
    Task task = Task(
    taskData['id'],
    taskData['boardId'],
    boardName,
    taskData['taskName'],
    taskData['taskDescription'],
    taskData['taskStatus'],
    DateTime.parse(taskData['taskCreationDate']),
    board.getassignedTo(),
    board.getcreatedBy(),
    style.cardsColors()[j]
    );
    j++;
    String taskTimeLeft = formatDuration(
    DateTime.now(),
    task.gettaskcreationDate(),
    ).toString();
    return Container(
    margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
    padding: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
    decoration: BoxDecoration(color: board.getboardColor() == style.cardsColors()[j] ? style.cardsColors()[++j] : style.cardsColors()[j], borderRadius: BorderRadius.circular(20)),
    child: Column(children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Container(
    height: 50,
    width: 100,
    child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: board.getassignedTo().map<Widget>((user) {
    return Align(
    widthFactor: 0.5,
    child: Padding(
    padding: EdgeInsets.only(left: 13),
    child: CircleAvatar(
    radius: 30,
    backgroundImage: NetworkImage(API.serverPath + user['photoPath']),
    ),
    ),
    );
    }).toList(),
    ),
    ),
    ),
    SizedBox(width: 60),
    Container(
    margin: EdgeInsets.only(bottom: 20, right: 4),
    child: Text(taskTimeLeft, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Paul')),
    ),
    ],
    ),
    Spacer(),
    Container(
    margin: EdgeInsets.only(bottom: 20, right: 4),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
    child: task.gettaskstatus() == 1
    ? Icon(Icons.check)
    : SpinKitFadingCircle(
    color: Color(0xFF7195EE),
    size: 25,
    ),
    ),
    ],
    ),
    SizedBox(height: 8),
    Container(
    alignment: Alignment.centerLeft,
    child: Text(boardName, style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Expressway')),
    ),
    SizedBox(height: 2),
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Container(
    alignment: Alignment.centerLeft,
    child: Text(task.gettaskName(), style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Expressway')),
    ),
    Spacer(),
    GestureDetector(
    onTap: () {
    print("delete this task");
    style.popUpWidget(context, "Delete Task", "Are your sure to delete this task ?", DialogType.info,onOkPress: () {
    API.deleteTaskById(task.gettaskId());
    });
    },
    child: Icon(Icons.delete_forever, color: Color.fromARGB(255, 232, 136, 112).withOpacity(0.6)),
    ),
    ],
    ),
    SizedBox(height: 10),
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Container(
    alignment: Alignment.centerLeft,
    child: Text(task.gettaskDescription(), style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Expressway')),
    ),
    ],
    )
    ]),
    );
    }).toList();
    return Column(children: taskContainers);
    } else {
    return Center(child: Text('No data found'));
    }
    },
    );
    },
    );
    } else {
    return Center(child: Text('No data found'));
    }
    },
    )
    );
    return containers;
  }
