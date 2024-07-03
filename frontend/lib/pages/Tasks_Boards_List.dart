import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/board.dart';
import '../model/task.dart';
import 'package:intl/intl.dart';
import 'package:my_app1/pages/TaskDetailEdit.dart';
import 'package:my_app1/pages/BoardDetailEdit.dart';
import '../Providers/MainPageModel.dart';
import '../http/APIs.dart' as API;
import '../style/style.dart' as style;
import 'package:awesome_dialog/awesome_dialog.dart';

List<int> selectedUsersBoard = [];
List<bool> statusFilter = [false,false];
Future<int?> _getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("id");
}
String currentDateFilterInit = DateFormat('yyyy-MM-dd').format(DateTime.now());
TextEditingController userNameController = TextEditingController();
String selectedDate_filter = currentDateFilterInit;
String selectedStatus_filter = "all";
List<bool> checkbox_selection_value = [];
List<bool> init_checkbox_users = [];
Color screenColor = Color(0xFF081245);

class TasksBoardsList extends StatelessWidget {

  TasksBoardsList({super.key});

  TextEditingController emailController = TextEditingController();
  String currentDate = DateFormat('MMMM d , y').format(DateTime.now());
  String currentDay = DateFormat('EEEE').format(DateTime.now());
  int? userId;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
    create: (_) => MainPageModel(),
    child: Scaffold(
    resizeToAvoidBottomInset: true,
    backgroundColor:screenColor,
    body: SingleChildScrollView(
    child:Container(
    height: screenSize.height,
    width: screenSize.width,
    child: Column(
    children: [
    // ********************* Image user , Notification & Add Board Icon (+) ***************************
    // Container 1 = ROw of (Image + notification + add Board Icon)
    SizedBox(height: 30),
    Container(
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.all(20),
    child: Row(children: [
    FutureBuilder<int?>(
    future: _getUserId(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData) {
    int? userId = snapshot.data;
    if (userId == null) {
      return Center(child: Text('No user ID found'));
    }
    return FutureBuilder<List<dynamic>>(
    future: API.getUserById(userId),
    builder: (context, userSnapshot) {
    if (userSnapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (userSnapshot.hasError) {
      return Center(child: Text('Error: ${userSnapshot.error}'));
    } else if (userSnapshot.hasData) {
    List<dynamic> user = userSnapshot.data!;
    print("user ===="+user.toString());
    return ClipOval(
    child: Image.network(
    API.serverPath + user[0]['photoPath'], 
    width: 50,
    height: 50,
    fit: BoxFit.cover, 
    ),
    );
    } else {
    return Center(child: Text('No user data found'));
    }
    },
    );
    } else {
    return Center(child: Text('No data found'));
    }
    },
    ),

    Spacer(),
    SizedBox(width: 10),
    Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(shape:BoxShape.circle,color:Colors.white.withOpacity(0.2)),
    child:GestureDetector(
    child: Image.asset(
    "assets/images/add_task_image_icon.png",
    width: 50,
    height: 50,
    fit: BoxFit.cover,
    ) , 
    onTap: () {
      print("add task");
      Navigator.of(context).pushReplacementNamed('addtask');
    },
    )
    ),
    SizedBox(width: 10),
    Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(shape:BoxShape.circle,color:Colors.white.withOpacity(0.2)),
    child:GestureDetector(
    child: Image.asset(
    "assets/images/add_board_image_icon.png",
    width: 50,
    height: 50,
    fit: BoxFit.cover,
    ) , 
    onTap: () {
      print("add board");
      Navigator.of(context).pushReplacementNamed('addboard');
    },
    )
    ),
    SizedBox(width: 10),
    FutureBuilder<int?>(
    future: _getUserId(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData) {
    int? userId = snapshot.data;
    if (userId == null) {
    return Center(child: Text('No user ID found'));
    }
    return FutureBuilder<List<dynamic>>(
    future: API.nbrActiveTasks(userId),
    builder: (context, userSnapshot) {
    if (userSnapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (userSnapshot.hasError) {
      return Center(child: Text('Error: ${userSnapshot.error}'));
    } else if (userSnapshot.hasData) {
      List<dynamic> nbrActiveTasks = userSnapshot.data!;
      print("nbr active tasks ===="+nbrActiveTasks.toString());
      return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
      Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white.withOpacity(0.2)),
      child:IconButton(icon:Icon(Icons.notifications_none_outlined,color:Colors.black) , onPressed:() async {
        print("notification clicked !");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = prefs.getInt("id");
        List<dynamic> user = await API.getUserById(userId!);
        String userName = user[0]['userName'];
        style.popUpWidget(context,"Tasks Notification",'Hi '+userName+' , you have '+nbrActiveTasks[0]['nbrActiveTasks'].toString()+' active tasks',DialogType.info); 
      })),
      Positioned(
      bottom: -4,
      child: Container(
      height: 15,
      width: 30,
      decoration:BoxDecoration(color:Color(0xFF7195EE),borderRadius: BorderRadius.circular(30)) ,   
      child:Center(child:Text(nbrActiveTasks[0]['nbrActiveTasks'].toString(),style:TextStyle(fontSize: 10,fontWeight: FontWeight.bold)))
      ))
      ]);
      } else {
      return Center(child: Text('No user data found'));
      }
      },
      );
    } else {
    return Center(child: Text('No data found'));
    }
    },
    ),
    ])
    ),
    // Container 2 = Good Morning
    Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(child:Text("Good Morning",style: TextStyle(color: Color(0xFF7195EE),fontSize: 40,fontFamily:'Expressway'))),
    ])
    ),
    // Container 3 = Today's date & tasks done percentage (%)
    Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.all(20),
    child: Row(children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(child:Text("Today's "+currentDay,style: TextStyle(color: Colors.white ,fontSize: 15,fontWeight: FontWeight.bold,fontFamily:'Expressway'))),
    Container(child:Text(currentDate.toString(),style: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 15,fontFamily:'Expressway'))),
    ]),
    Spacer(),


    FutureBuilder<int?>(
    future: _getUserId(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData) {
      int? userId = snapshot.data;
      if (userId == null) {
      return Center(child: Text('No user ID found'));
      }
    return FutureBuilder<List<dynamic>>(
    future: API.tasksDonePercentage(userId),
    builder: (context, userSnapshot) {
    if (userSnapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (userSnapshot.hasError) {
      return Center(child: Text('Error: ${userSnapshot.error}'));
    } else if (userSnapshot.hasData) {
      List<dynamic> tasksDonePercentage = userSnapshot.data!;
      print("task percentage ==== " +tasksDonePercentage.toString());
      return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      Container(child:Text(tasksDonePercentage[0]['percentage'] == null ? "0%" : tasksDonePercentage[0]['percentage'].toString()+"%",style: TextStyle(color: Colors.white ,fontSize: 15,fontWeight:FontWeight.bold,fontFamily:'Expressway'))),
      Container(child:Text("Done",style: TextStyle(color: Colors.white.withOpacity(0.3) ,fontSize: 15,fontFamily:'Expressway'))),
      ]);
    } else {
      return Center(child: Text('No percentage data found'));
    }
    },
    );
    } else {
     return Center(child: Text('No data found'));
    }
    },
    ),
    ]),
    ),
    // Container 4 = TabBar for tasks & board
    Container(
    padding: const EdgeInsets.all(8),
    margin: EdgeInsets.all(screenSize.height*0.01),
    height: 360,
    child: ContainedTabBarView(
    tabBarProperties: TabBarProperties(indicatorColor: Color(0xFF7195EE),labelColor: Color(0xFF7195EE),unselectedLabelColor: Color(0xFF7195EE)),
    tabs: [
    // Tasks title bar
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [ 
    Container(
    height: 30,
    width: 40,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(color: Color(0xFF7195EE),borderRadius: BorderRadius.circular(30)),  
    child: FutureBuilder<int?>(
    future: _getUserId(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData) {
      int? userId = snapshot.data;   
      return FutureBuilder<List<dynamic>?>(
      future: API.getListTasks(userId!),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        List<dynamic>? listTasks = snapshot.data;
        return Center(child:Text(listTasks!.length.toString(),style: TextStyle(color: Colors.white ,fontSize: 15,fontFamily:'Expressway')));
      } else {
        return Center(child: Text('No data found'));
      }
      },
      );
    } else {
    return Center(child: Text('No data found'));
    }
    },
    ),
    ),
    SizedBox(width: 4),
    Text('Tasks',style: TextStyle(color: Colors.white ,fontSize: 15,fontWeight: FontWeight.bold,fontFamily:'Expressway'))
    ]),
    // Boards title bar
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [ 
    Container(
    height: 30,
    width: 40,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(color: Color(0xFF7195EE),borderRadius: BorderRadius.circular(30)),  
    child:FutureBuilder<int?>(
    future: _getUserId(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData) {
      int? userId = snapshot.data;
      return FutureBuilder<List<dynamic>?>(
      future: API.getListBoards(userId!),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        List<dynamic>? listBoards = snapshot.data;
        return Center(child:Text(listBoards!.length.toString() ,style: TextStyle(color: Colors.white ,fontSize: 15,fontFamily:'Expressway')));
      } else {
        return Center(child: Text('No data found'));
      }
      },
      );
    } else {
      return Center(child: Text('No data found'));
    }
    },
    ),),
    SizedBox(width: 4),
    Text('Boards',style: TextStyle(color: Colors.white ,fontSize: 15,fontFamily:'Expressway'))
    ]),               
    ],
    views: [
    Tasks(context),
    Boards(context)
    ],
    onChange: (index) => print(index),
    ),
    ),

    ]
    ) , 
    ),
    )
    )
    );
  }
}

Widget Tasks(BuildContext context) {
  Widget tasksWidget = Container(
  margin: EdgeInsets.only(right:4,left:4,bottom:4,top:8),
  child:Column(children: [
  // col 1 = Row 1 of (tasks status : for filtering)
  Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
  Selector<MainPageModel, List<bool>>(
  selector: (context, model) => model.getStatusFilter(),
  builder: (context, statusFilter, _) {
  return GestureDetector(
  onTap: () {
    context.read<MainPageModel>().reverseStatusActive();
    if (context.read<MainPageModel>().getStatusFilter()[0]) {
      print("'Active' tasks filter is selected");
      selectedStatus_filter = "0";
      context.read<MainPageModel>().setselectedDate_Status(selectedDate_filter,selectedStatus_filter);
    }
    if ( (context.read<MainPageModel>().getStatusFilter()[0] == false) && (context.read<MainPageModel>().getStatusFilter()[1] == false)  ){
      selectedStatus_filter = "all";
      context.read<MainPageModel>().setselectedDate_Status(selectedDate_filter,selectedStatus_filter);
    }
  },
  child:Container(
  padding: EdgeInsets.all(4),
  decoration:BoxDecoration(borderRadius: BorderRadius.circular(30),color:context.watch<MainPageModel>().getStatusFilter()[0]?Colors.white:null),
  child:Text("Active",style: TextStyle(color: Color(0xFF7195EE) ,fontSize: 15,fontWeight: FontWeight.bold,fontFamily:'Expressway'))));
  }

  ),

  SizedBox(width: 10),

  Selector<MainPageModel, List<bool>>(
  selector: (context, model) => model.getStatusFilter(),
  builder: (context, statusFilter, _) {
  return GestureDetector(
  onTap: () {
    context.read<MainPageModel>().reverseStatusDone();
    if (context.read<MainPageModel>().getStatusFilter()[1]) {
      print("'Done' tasks filter is selected");
      selectedStatus_filter = "1";
      context.read<MainPageModel>().setselectedDate_Status(selectedDate_filter,selectedStatus_filter);
    }
    if ( (context.read<MainPageModel>().getStatusFilter()[0] == false) && (context.read<MainPageModel>().getStatusFilter()[1] == false)) {
      selectedStatus_filter = "all";
      context.read<MainPageModel>().setselectedDate_Status(selectedDate_filter,selectedStatus_filter);
    }
  },
  child:Container(
  padding: EdgeInsets.all(4),
  decoration:BoxDecoration(borderRadius: BorderRadius.circular(30),color:context.watch<MainPageModel>().getStatusFilter()[1]?Colors.white:null),
  child:Text("Done",style: TextStyle(color: Color(0xFF7195EE) ,fontSize: 15,fontWeight: FontWeight.bold,fontFamily:'Expressway'))));
  }),
  ]),
  // Row 2 = calendar
  Selector<MainPageModel, List<String>>(
  selector: (context, model) => model.getselectedDate_Status(),
  builder: (context, statusFilter, _) {
  return EasyDateTimeLine(
  activeColor: Colors.white.withOpacity(0.8),
  initialDate: DateTime.now(),
  onDateChange: (selectedDate) {
  selectedDate_filter = selectedDate.toString().substring(0,10);
  print("selected Date = "+selectedDate_filter+" // selected status = "+selectedStatus_filter);
  context.read<MainPageModel>().setselectedDate_Status(selectedDate_filter,selectedStatus_filter);
  },
  headerProps: const EasyHeaderProps(
  selectedDateStyle: TextStyle(color: Colors.white,fontFamily:'Expressway'),
  monthStyle: TextStyle(color: Colors.white ,fontSize: 15,fontFamily:'Expressway'),
  monthPickerType: MonthPickerType.switcher,
  dateFormatter: DateFormatter.fullDateDMY(),
  ),
  dayProps: const EasyDayProps(
  todayHighlightColor: Color(0xff3371FF),
  height: 35,
  dayStructure: DayStructure.dayStrDayNum,
  inactiveDayStyle: DayStyle(
  monthStrStyle: TextStyle(color: Colors.white,fontFamily:'Expressway'),
  dayStrStyle: TextStyle(color: Color(0xFF7195EE),fontFamily:'Expressway'),
  dayNumStyle: TextStyle(color: Colors.white,fontFamily:'Expressway')
  ),
  disabledDayStyle: DayStyle(
  monthStrStyle: TextStyle(color: Colors.white,fontFamily:'Expressway'),
  dayStrStyle: TextStyle(color: Color(0xFF7195EE),fontFamily:'Expressway'),
  dayNumStyle: TextStyle(color: Colors.white,fontFamily:'Expressway')
  ),
  activeDayStyle: DayStyle( 
  monthStrStyle: TextStyle(color: Colors.white,fontFamily:'Expressway'),
  dayStrStyle: TextStyle(color: Colors.white,fontFamily:'Expressway'),
  dayNumStyle: TextStyle(color: Colors.white,fontFamily:'Expressway'),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  gradient: LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
  Color(0xff3371FF),
  Color(0xff8426D6),
  ],
  ),
  ),
  ),
  ),
  );
  }),
  // Row 3 = Tasks/Boards Custom cards
  SizedBox(height:8),
  FutureBuilder<int?>(
  future: _getUserId(),
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
  return Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
  return Center(child: Text('Error: ${snapshot.error}'));
  } else if (snapshot.hasData) {
  int? userId = snapshot.data;

  if (userId == null) {
    return Center(child: Text('No user ID found'));
  }

  return Selector<MainPageModel, List<String>>(
  selector: (context, model) => model.getselectedDate_Status(),
  builder: (context, statusFilter, _) {
  return FutureBuilder<List<dynamic>>(
  future: API.getListTasksFilter(userId,context.watch<MainPageModel>().getselectedDate_Status()[0],context.watch<MainPageModel>().getselectedDate_Status()[1]),
  builder: (context, listtaskssnapshot) {
  if (listtaskssnapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
  } else if (listtaskssnapshot.hasError) {
    return Center(child: Text('Error: ${listtaskssnapshot.error}'));
  } else if (listtaskssnapshot.hasData) {
    List<dynamic> listTasks = listtaskssnapshot.data!;
    return Expanded(
    child: ListView(
    shrinkWrap: true,
    children: CustomTasksCards(listTasks,context),
    ),
    );
  } else {
    return Center(child: Text('No percentage data found'));
  }
  },
  );}
  );
  } else {
    return Center(child: Text('No data found'));
  }
  },
  )
  ]));
  return tasksWidget;
}

Widget Boards(BuildContext context) {
  return FutureBuilder<int?>(
  future: _getUserId(),
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
  } else if (snapshot.hasData) {
  int? userId = snapshot.data;
  if (userId == null) {
    return Center(child: Text('No user ID found'));
  }
  return FutureBuilder<List<dynamic>>(
  future: API.getListBoards(userId),
  builder: (context, listBoardsSnapshot) {
  if (listBoardsSnapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
  } else if (listBoardsSnapshot.hasError) {
    return Center(child: Text('Error: ${listBoardsSnapshot.error}'));
  } else if (listBoardsSnapshot.hasData) {
    List<dynamic> listBoards = listBoardsSnapshot.data!;
    return ListView(
    shrinkWrap: true,
    children: CustomBoardsCards(listBoards, context),
    );
  } else {
    return Center(child: Text('No boards data found'));
  }
  },
  );
  } else {
  return Center(child: Text('No user data found'));
  }
  },
  );
}

// ********************* TASKS CARDS **************************

List<Widget> CustomTasksCards(List<dynamic> tasks , BuildContext context) {
  List<Widget> containers = [];
  for(int i=0 , j=0 ; i< tasks.length && j < style.cardsColors().length ; i++ , j++) {
  int taskId = tasks[i]['id'];
  int boardId = tasks[i]['boardId'];
  String taskName = tasks[i]['taskName'];
  String taskDescription = tasks[i]['taskDescription'];
  int taskStatus = tasks[i]['taskStatus'];
  String boardName = tasks[i]['name'];
  print("=============== taskName = "+taskName);
  DateTime taskCreationDateTime = DateTime.parse(tasks[i]['taskCreationDate']);
  String taskTimeLeft = formatDuration(DateTime.now(),taskCreationDateTime); 
  Color taskColor = style.cardsColors()[j];
  print(" ++++++++++++++++ task detail +++++++++++++++++");
  print("task : id = "+taskId.toString()+" / boardId = "+boardId.toString()+" / taskName = "+taskName.toString()+" / taskDescription = "
  +taskDescription+" / taskStatus = "+taskStatus.toString()+" / taskCreationDate = "+taskCreationDateTime.toString()+" / boardName = " + boardName);
  
  containers.add( FutureBuilder<List<dynamic>?>(
  future: API.getListUsersBoards(boardId),
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
  return Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
  return Center(child: Text('Error: ${snapshot.error}'));
  } else if (snapshot.hasData) {
  List<dynamic>? usersList = snapshot.data;
  return GestureDetector(
  onTap: () async {
    List<dynamic> boardCreatedBy = await API.getBoardCreatorUser(boardId).then((userBoardCreator){
    List<dynamic> boardCreatorUser =  userBoardCreator;
    return boardCreatorUser;
    });
    Task task = new Task(taskId,boardId,boardName,taskName,taskDescription,taskStatus,taskCreationDateTime,usersList,boardCreatedBy,taskColor);
    print("task clicked infos : task id = "+ taskId.toString());
    Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => TaskDetailEdit(task:task) ) );
  },
  child:Container(
  margin: EdgeInsets.all(4),
  padding: EdgeInsets.all(10),
  decoration: BoxDecoration(color:taskColor,borderRadius: BorderRadius.circular(20)),
  child:Column(children: [
  // Col 1 : Row 1 (img_users assigne & icon 'active/done' for task status)
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
  children: [
  for(int i=0;i<usersList!.length;i++)
  Align(
  widthFactor: 0.5,
  child:Padding(
  padding: EdgeInsets.only(left:13),
  child: CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImage(API.serverPath+usersList[i]['photoPath']),
  ))
  )
  ]),
  ) 
  ),
  SizedBox(width: 60),
  Container(
  margin: EdgeInsets.only(bottom: 20,right:4),
  child: Text(taskTimeLeft,style: TextStyle(color:Colors.black,fontSize: 15,fontFamily: 'Paul',fontWeight: FontWeight.bold)),
  ),
  ]),
  Spacer(),
  Container(
  margin: EdgeInsets.only(bottom: 20,right:4),
  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(100)),
  child: taskStatus == 1? Icon(Icons.check,color:Color(0xFF7195EE)):SpinKitFadingCircle(
  color: Color(0xFF7195EE),
  size: 25, 
  ),
  )
  ]),
  // Col 2 : {BoardName}
  SizedBox(height:8),
  Container(
  alignment: Alignment.centerLeft,
  child:Text(boardName,style: TextStyle(color: Colors.black,fontSize: 15,fontFamily:'Expressway'))
  ),
  // Col 3 => Row : {TaskName} & delete Icon
  Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Container(
  alignment: Alignment.centerLeft,
  child:Text(taskName,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold,fontFamily:'Expressway'))
  ),
  Spacer(),
  GestureDetector(
  onTap: () {
    print("delete this task : task Id = " +taskId.toString());
    style.popUpWidget(context, "Delete Task", "Are your sure to delete this task ?", DialogType.info,onOkPress: () {
    API.deleteTaskById(taskId);
    });
  },
  child:Icon(Icons.delete_forever,color:Color.fromARGB(255, 232, 136, 112).withOpacity(0.6)) 
  ),
  ],
  )
  ]  
  ))
  );
  } else {
    return Center(child: Text('No data found'));
  }
  },
  ),
  );
  }
  return containers;
}

// ********************* BOARDS CARDS **************************

  List<Widget> CustomBoardsCards(List<dynamic> boards , BuildContext context) {

  List<Widget> containers = [];

    for(int i=0 , j= 0 ; i< boards.length && j < style.cardsColors().length ; i++ , j++) {
      int boardId = boards[i]['id'];
      int userId = boards[i]['createdBy'];
      String boardName = boards[i]['name'];
      Color boardColor = style.cardsColors()[j];

      containers.add(
      ChangeNotifierProvider(
      create: (_) => MainPageModel(),
      child: Selector<MainPageModel, Future<List<dynamic>>?>(
      selector: (context, model) => model.getListUsersPerBoard(),
      builder: (context, checkboxUserValue, _) {
      return FutureBuilder<dynamic>(
      future: context.watch<MainPageModel>().getListUsersPerBoard() ?? API.getListUsersBoards(boardId),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
        List<dynamic> usersList = snapshot.data;
        return FutureBuilder<dynamic>(
        future: API.nbrActiveTasksBoard(userId,boardId),
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
        List<dynamic> listActiveTasks_Board = snapshot.data;
        return  GestureDetector(
        onTap: () async {
          int boardid = boardId;
          List<dynamic> assignedToBoardusers = usersList;
          int userBoardCreatorId = userId;
          String boardname = boardName; 
          List<dynamic> tasksList = await API.getListTasksByBoardId(userBoardCreatorId,boardId);
          List<dynamic> userBoardCreator = await API.getUserById(userBoardCreatorId);
          print("board clicked , infos : board id = " + boardId.toString() );
          Board board = new Board(boardid,boardname,tasksList,userBoardCreator,assignedToBoardusers,boardColor);
          Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => BoardDetailEdit(board:board)) );
        },
        child:Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: boardColor,borderRadius: BorderRadius.circular(20)),
        child:Column(children: [
        // Col 1 : Row 1 (img_users assigne & icon 'active/done' for task status)
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Container(
        height: 50,
        width: 200,
        child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Align(
        alignment: Alignment.centerRight,
        widthFactor: 0.5,
        child:Padding(
        padding: EdgeInsets.only(left:50),
        child: CircleAvatar(
        backgroundColor: Color(0xFF7195EE).withOpacity(0.5),
        radius: 50,     
        child:IconButton(icon: Icon(Icons.add,color:Colors.black), onPressed: () async {
          List<dynamic> listusers = await API.getNOTListUsersBoards(boardId);
          print("add user to "+boardName+" / index of board 'i' = "+i.toString());
          selectedUsersBoard = [];
          showDialog(
          context: context,
          builder: (BuildContext c) {   
          return AlertDialog(
          title: Center(child:
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Spacer(),
          IconButton(icon:Icon(Icons.cancel),color:Color.fromARGB(255, 232, 136, 112).withOpacity(0.5),onPressed: () {
            Navigator.of(c).pop();
          })
          ]),
          ),
          content: popUp_AddUsers(context,listusers),
          backgroundColor: screenColor.withOpacity(0.8),
          actions: [
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          TextButton(
          onPressed: () {
          // Close the dialog box
            Navigator.of(c).pop();
          },
          child: Container (
          margin: EdgeInsets.all(MediaQuery.of(context).size.height*0.01),
          decoration: BoxDecoration(color: Color(0xFF7195EE), shape: BoxShape.circle),
          padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
          child: Center(child:IconButton(icon: Icon(Icons.add,color:Colors.black) , onPressed: () async {
            print("add user to boardId = "+boardId.toString());
            print("********** selected users Id's ************");
            print(selectedUsersBoard);
            selectedUsersBoard.forEach((userId){
            API.updateBoard_addUserToBoard(boardId, userId);
            });
            if (selectedUsersBoard.length != 0) {
              try{
                print("++++++++++++++++++++++ START new users update ++++++++++++++++");
                print(API.getListUsersBoards(boardId));
                print("++++++++++++++++++++++ END new users update ++++++++++++++++");
                context.read<MainPageModel>().setListUsersPerBoard(API.getListUsersBoards(boardId));
              } catch(e){
                print("error update users : "+e.toString());
              }
            }
            Navigator.of(c).pop();                                                                
          }))
          ),
          ),                                          
          ])
          ],
          );
          },
          );
        }),              
        ))
        ),
        for(int j=0;j<usersList.length;j++)
          Align(
            alignment: Alignment.centerRight,
            widthFactor: 0.5,
            child:Padding(
            padding: EdgeInsets.only(left:13),
            child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(API.serverPath + usersList[j]['photoPath']),
            ))
          ),
        ]
        ),
        ) 
        ),
        ]),
        Spacer(),
        // Task Status Icon 'active/done'
        Container(
        margin:EdgeInsets.only(bottom: 20,right:4),
        child:GestureDetector(
        onTap: () {
          print("delete this board : board Id = "+boardId.toString());
          style.popUpWidget(context, "Delete Board", "Are your sure to delete this board ?", DialogType.info,onOkPress: () {
          API.deleteBoardById(boardId);
          });
        },
        child:Icon(Icons.delete_forever,color: Color.fromARGB(255, 232, 136, 112).withOpacity(0.6)) 
        )),
        ]),
        // Col 2 = {BoardName}
        SizedBox(height:8),
        Container(
        alignment: Alignment.centerLeft,
        child:Text( listActiveTasks_Board[0]['nbrActiveTasks'].toString() + " Active tasks",style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 15,fontFamily:'Expressway'))
        ),
        // Col 3 => Row : {TaskName} & deleteIcon
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Container(
        alignment: Alignment.centerLeft,
        child:Text(boardName,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold,fontFamily:'Expressway'))
        ),
        ],
        )
        ]  
        ))
        );
        } else {
          return Center(child: Text('No data found'));
        }
        },
        );
        } else {
          return Center(child: Text('No data found'));
        }
      },
      );
      })
      )
      );
      }
  return containers;
}

String formatDuration(DateTime startTime, DateTime endTime) {
  Duration difference = endTime.difference(startTime);
  String formattedDuration = '${difference.inDays}d ${difference.inHours.remainder(24)}h ${difference.inMinutes.remainder(60)}min';
  return formattedDuration;
}

Widget popUp_AddUsers( BuildContext context, List<dynamic> list_users) {
  Widget popUpContainer = Container(
  height: 240,
  child:SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child:Column(children: [
  for(int i=0 , j = 0 ; i<list_users.length && j < style.cardsColors().length; i++ , j++)
    Container(
    width: 260,
    margin: EdgeInsets.only(top:10,bottom:10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(color:style.cardsColors()[j] , borderRadius: BorderRadius.circular(10)),
    child:Row(
    mainAxisAlignment: MainAxisAlignment.center,  
    children: [
    Flexible(child: Container(
    width: 120,
    child:Text(list_users[i]['userName'] , style:TextStyle(color:Colors.black,fontSize: 16,fontFamily:'Expressway'))
    )),
    SizedBox(width: 20),
    Container(
    height: 40,
    width: 40,
    child:CircleAvatar(
    backgroundImage: NetworkImage(API.serverPath+list_users[i]['photoPath']),
    )),
    SizedBox(width: 15),
    ChangeNotifierProvider(
    create: (_) => MainPageModel(),
    child: Selector<MainPageModel, Future<bool>>(
    selector: (context, model) => model.getUserCheckboxValue(i),
    builder: (context, checkboxUserValue, _) {
    return FutureBuilder<bool>(
    future: context.watch<MainPageModel>().getUserCheckboxValue(i),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); 
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      bool checkboxValue = snapshot.data!;
      return Checkbox(
      value: checkboxValue,
      onChanged: (newValue) {
        context.read<MainPageModel>().reverseUserCheckboxValue(i);
        print("New value of username "+list_users[i]['userName']+" / new value = "+newValue.toString());
        if ( selectedUsersBoard.contains(list_users[i]['id']) ) {
          print("we will remove "+list_users[i]['userName']);
          selectedUsersBoard.remove(list_users[i]['id']);                                      
        } else {
          print("we will add "+list_users[i]['userName']);
          selectedUsersBoard.add(list_users[i]['id']);
        }
        print("selected id's = "+selectedUsersBoard.toString());
      },
      );                     
    }
    },
    );
    })
    )                         
    ]))
  ]))
  );
  return popUpContainer;
}