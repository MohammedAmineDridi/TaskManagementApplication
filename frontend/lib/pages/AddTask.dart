import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/AddTaskPageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../http/APIs.dart' as API;
import '../style/style.dart' as style;
import 'package:awesome_dialog/awesome_dialog.dart';

TextEditingController taskNameController = TextEditingController();
TextEditingController taskdateController = TextEditingController();
TextEditingController tasktimeController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController taskDescriptionController = TextEditingController();
DateTime currentDate = DateTime.now();

class AddTask extends StatelessWidget {

  AddTask({Key? key});

  Color screenColor = Color(0xFF081245);
  String? taskName_txtinput;
  String? taskDescription_txtinput;
  String? date_input;
  String? time_input;
  String? boardId_dropinput ;

  @override
  Widget build(BuildContext context) {
    
    Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
    create: (_) => AddTaskPageModel(),
    child: Scaffold(
    resizeToAvoidBottomInset: true,
    backgroundColor:screenColor,
    body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child:Container(
    height: screenSize.height,
    width: screenSize.width,
    child: Column(
    children: [
    // ********************* Drop down icon and delete icon **************************    
    // ROw 1 : (Drop down icon)
    SizedBox(height: 30),
    Container(
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
    child: Row(children: [
    Container(
    child:IconButton(icon: Icon(Icons.cancel,size:40,color:Color.fromARGB(255, 243, 240, 87).withOpacity(0.6)),onPressed: () {
    print("return to main page");
    Navigator.of(context).pushReplacementNamed('tasksboardsList');
    })
    )
    ])
    ),         
    // ROW 2 = Title
    Container(
    padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
    child: Center(child:const Text("Add Task",style: TextStyle(fontFamily:'Expressway',fontSize: 40,color:Color(0xFF7195EE))))
    ),

    // *********************** FORM **********************
    // ROW 3 = TaskName Name textfield
    Container (
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
    child:Row(children: [
    Text("Name ",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.white)),
    Expanded(
    child: Padding(
    padding: EdgeInsets.only(left:70),
    child: TextField(
    controller: taskNameController,
    cursorColor: Colors.white,
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Task Name ..." , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    prefixIcon: Icon(Icons.task,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ),
    onChanged: (newtaskName)  {
    print("new task name = "+newtaskName.toString());
    taskName_txtinput = newtaskName.toString();
    },
    )
    )),
    ])), 
    // ROW 4 = Task description textifled 'paragraph'
    Container (
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
    child:Row(children: [
    Text("Description ",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.white)),
    Expanded(
    child: Padding(
    padding: EdgeInsets.only(left:28) ,
    child:TextField(
    maxLines: 5,
    controller: taskDescriptionController,
    cursorColor: Colors.white,
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Task Description ..." , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    ),
    onChanged: (newtaskDescription) {
    print("new task description = "+newtaskDescription.toString());
    taskDescription_txtinput = newtaskDescription.toString();
    },
    )
    ),
    ),
    ])),
    // ROW 5 = Task Date 'date & time picker'
    Container (
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.only(left:20,top:10,bottom: 10),
    child:Row(children: [
    Text("Date & Time",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.white)),
    SizedBox(width: 26),
    Container( 
    height: 50,
    width: 190,
    child:Selector<AddTaskPageModel, String>(
    selector: (context, model) => model.getDateTime(),
    builder: (context, isEmailValid, _) {
    return TextField(
    focusNode: FocusNode()..addListener(() {
    FocusNode().unfocus();
    }),
    readOnly: true,
    controller: taskdateController,
    cursorColor: Colors.white,
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: context.watch<AddTaskPageModel>().getDateTime() , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 11,color: Colors.white,fontWeight: FontWeight.bold) , 
    prefixIcon: IconButton(icon:Icon(Icons.date_range_outlined),color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6),onPressed: () async{
    DateTime? choosenDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(1900), 
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
    return Theme(
    data: ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
    primary: Color(0xFF7195EE) ,
    onPrimary: screenColor,
    onSurface: screenColor,
    ),
    dialogBackgroundColor: Colors.black,
    ),
    child: child!,
    );
    },
    );
    if (choosenDate != null) {
      context.read<AddTaskPageModel>().setDate( choosenDate.toString().substring(0,10));
      print("chossen date = "+choosenDate.toString().substring(0,10));
      date_input = choosenDate.toString().substring(0,10);
    } else {
      print("default date : "+DateFormat('yyyy-MM-dd').format(DateTime.now()));
      date_input = currentDate.toString().substring(0,10);
    }
    }
    ),
    suffixIcon: IconButton(icon:Icon(Icons.access_time_rounded),color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6),onPressed: () async{
    var choosenTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute), 
    builder: (BuildContext context, Widget? child) {
    return Theme(
    data: ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
    primary: Color(0xFF7195EE) ,
    onPrimary: screenColor,
    onSurface: screenColor,
    ),
    dialogBackgroundColor: Colors.black,
    ),
    child: child!,
    );
    },               
    );
    if (choosenTime != null) {
      String newTime = choosenTime.hour.toString()+":"+choosenTime.minute.toString();
      print("choosen time = "+newTime);
      final period = choosenTime.period == DayPeriod.am ? "AM" : "PM";
      print("period = "+period.toString());
      context.read<AddTaskPageModel>().setTime(newTime);
      print("new time = "+newTime);
      time_input = choosenTime.hour.toString()+":"+choosenTime.minute.toString();
    } else {
      print("default choosen time : "+TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).toString());
      time_input = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).toString();
    }
    })
    ),
    
    );
    }),
    ),
    ])),
    // ROW 6 = Board Name dropdown
    Container (
    margin: EdgeInsets.all(screenSize.height*0.01),
    padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
    child:Row(children: [
    Text("Board Name ",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.white)),
    Expanded(child: Container(
    margin: EdgeInsets.only(left:20),
    decoration:BoxDecoration(color:Colors.white.withOpacity(0.1),borderRadius: BorderRadius.circular(30)) ,   
    child:Center(
    child: FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, userSnapshot) {
    if (userSnapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (userSnapshot.hasError) {
      return Center(child: Text('Error: ${userSnapshot.error}'));
    } else if (userSnapshot.hasData) {
      SharedPreferences prefs = userSnapshot.data!;
      int? user_id = prefs.getInt("id");
      return  Selector<AddTaskPageModel, String?>(
      selector: (context, model) => model.getSelectedBoardNameItem(),
      builder: (context, selectedItemBoardName, _) {
      return FutureBuilder<List<dynamic>>(         
      future: API.getListBoards(user_id!),
      builder: (context, userSnapshot) {
      if (userSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (userSnapshot.hasError) {
        return Center(child: Text('Error: ${userSnapshot.error}'));
      } else if (userSnapshot.hasData) {
        List<dynamic> boards = userSnapshot.data!;
        print("boards : "+boards.toString());
        List<String> boardsNames = boards.map((board) => board['name'] as String).toList(); 
        List<int> boardIds = boards.map((board) => board['id'] as int).toList();
        Map<int, String> boardsMap = {for (int i = 0; i < boardIds.length; i++) boardIds[i]: boardsNames[i]};
        return DropdownButton<String>(
        dropdownColor: screenColor,
        underline: Container(height: 2,color:Color.fromARGB(255, 243, 240, 87).withOpacity(0.6)),
        value: boardsNames[0] ?? context.watch<AddTaskPageModel>().getSelectedBoardNameItem(),
        onChanged: (String? newBoardIdValue)  async{  
        if (newBoardIdValue != null) {
          context.read<AddTaskPageModel>().setSelectedBoardNameItem(newBoardIdValue);
          print("new board id selected = $newBoardIdValue");
          boardId_dropinput = newBoardIdValue;
        }
      },
    items : boardsMap.entries.map<DropdownMenuItem<String>>((entry) {
    int index = entry.key;
    String value = entry.value;
    return DropdownMenuItem<String>(
    value: index.toString(),
    child: Text(value,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white,fontFamily:'Expressway'),
    ),
    );
    }).toList()
    );                          
    } else {
      return Center(child: Text('No data found'));
    }
    },
    );});
    } else {
      return Center(child: Text('No data found'));
    }
    },
    )
    ),
    ), 
    ),
    ])),
    // ROW 7 : circle button of add task
    Container (
    margin: EdgeInsets.all(screenSize.height*0.01),
    decoration: BoxDecoration(color: Color(0xFF7195EE) , shape: BoxShape.circle),
    padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
    child: Center(child:IconButton(icon: Icon(Icons.add,color:Colors.black) , onPressed: (){
    if ( taskName_txtinput == "" || taskDescription_txtinput == "" || time_input == "" || date_input == "" || boardId_dropinput == ""  ){
      //show dialog
    } else {
    API.addTask(int.parse(boardId_dropinput!), taskName_txtinput!, taskDescription_txtinput!, 0, date_input!+" "+time_input!+":00");
    style.popUpWidget(context, "Add Task", "Task : "+taskNameController.text.toString()+" is added successfuly", DialogType.success);
    }
    }))
    ),
    ]
    ) , 
    )),
    ));
    }
}