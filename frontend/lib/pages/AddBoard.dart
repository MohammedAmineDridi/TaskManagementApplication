import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../http/APIs.dart' as API;
import '../Providers/AddBoardPageModel.dart';
import '../style/style.dart' as style;

TextEditingController boardNameController = TextEditingController();
TextEditingController userNameController = TextEditingController();
List<String> selectedUsersBoard = [];

class AddBoard extends StatelessWidget {

  AddBoard({Key? key});
  
  Color screenColor = Color(0xFF081245);

  @override
  Widget build(BuildContext context) {
  
  Size screenSize = MediaQuery.of(context).size;
  return Scaffold(
  resizeToAvoidBottomInset: true,
  backgroundColor:screenColor,
  body: SingleChildScrollView(child:Container(
  height: screenSize.height,
  width: screenSize.width,
  child: Column(
  children: [
  // ********************* Drop down icon and delete icon ************************* //
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
  child: Center(child:const Text("Add Board",style: TextStyle(fontFamily:'Expressway',fontSize: 40,color:Color(0xFF7195EE))))
  ),

  // *********************** FORM **********************
  // ROW 3 = BoardName textfield
  Container(
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child:Row(children: [
  Text("Name ",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.white)),
  Expanded(
  child: Padding(
  padding: EdgeInsets.only(left:70),
  child: TextField(
  controller: boardNameController,
  cursorColor: Colors.white,
  style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
  decoration: InputDecoration(
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
  hintText: "Board Name ..." , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
  prefixIcon: Icon(Icons.library_books,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
  ),
  onChanged: (newboardName) {
  print("new board name = "+newboardName.toString());
  },
  )
  )),
  ])
  ), 

  // ROW 4 = Assigned to (list of users assigned to this board)
  ChangeNotifierProvider(
  create: (_) => AddBoardPageModel(),
  child:  Container (
  margin: EdgeInsets.all(screenSize.height*0.01),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child:Column(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Row(children: [
  Text("Assigned to",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.white)),
  Expanded(
  child: Padding(
  padding: EdgeInsets.only(left:30),
  child: Selector<AddBoardPageModel, String>(
  selector: (context, model) => model.getuserNameFilter(),
  builder: (context, userName, _) {
  return TextField(
  controller: userNameController,
  cursorColor: Colors.white,
  style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
  decoration: InputDecoration(
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
  hintText: "User Name ..." , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
  prefixIcon: Icon(Icons.person,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
  ),
  onChanged: (newuserName) {
  print("new user name = "+newuserName.toString());
  if (newuserName == "") {
  newuserName = "all";
  print("new user name = "+newuserName.toString());
  }
  context.read<AddBoardPageModel>().setuserNameFilter(newuserName.toString());
  },
  );
  })
  )),
  ]),
  SizedBox(height: 20),
  Container(
  height: 240,
  child:SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child: SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child : Column(children: [
  Selector<AddBoardPageModel, String>(
  selector: (context, model) => model.getuserNameFilter(),
  builder: (context, userName, _) {
  return FutureBuilder<SharedPreferences>(
  future: SharedPreferences.getInstance(),
  builder: (context, userSnapshot) {
  if (userSnapshot.connectionState == ConnectionState.waiting) {
  return Center(child: CircularProgressIndicator());
  } else if (userSnapshot.hasError) {
  return Center(child: Text('Error: ${userSnapshot.error}'));
  } else if (userSnapshot.hasData) {
  SharedPreferences prefs = userSnapshot.data!;
  int? user_id = prefs.getInt("id");
  return FutureBuilder<List<dynamic>?>(
  future: API.getUserFilterByUserName(user_id!,context.watch<AddBoardPageModel>().getuserNameFilter()),
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
  return Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
  return Center(child: Text('Error: ${snapshot.error}'));
  } else if (snapshot.hasData) {
  List<dynamic>? usersList = snapshot.data;
  print("++++++++++++ list users +++++++++++++");
  print(usersList);
  print("++++++++++++ end list users +++++++++++++");
  return ListView.builder(
  shrinkWrap: true,
  itemCount: usersList!.length,
  itemBuilder: (context, i) {
  return Container(
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(color:Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(10)),
  height: 240,
  child:SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child:Column(children: [ 
  for(int i=0,j=0;i<usersList.length && j < style.cardsColors().length;i++,j++)
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
  child:Text(usersList[i]['userName'],style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.black))
  )),
  SizedBox(width: 20),
  Container(
  height: 40,
  width: 40,
  child:CircleAvatar(
  backgroundImage: NetworkImage(API.serverPath+usersList[i]['photoPath']),
  )),

  SizedBox(width: 15),

  ChangeNotifierProvider(
  create: (_) => AddBoardPageModel(),
  child: Selector<AddBoardPageModel, Future<bool>>(
  selector: (context, model) => model.getUserCheckboxValue(i),
  builder: (context, checkboxUserValue, _) {
  return FutureBuilder<bool>(
  future: context.watch<AddBoardPageModel>().getUserCheckboxValue(i),
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
  context.read<AddBoardPageModel>().reverseUserCheckboxValue(i);
  print("New value of username "+usersList[i]['userName']+" / new value = "+newValue.toString());
  if ( selectedUsersBoard.contains('"'+usersList[i]['id'].toString()+'"') ) {
  print("we will remove "+usersList[i]['userName']);
  selectedUsersBoard.remove('"'+usersList[i]['id'].toString()+'"');                                      
  } else {
    print("we will add "+usersList[i]['userName']);
    selectedUsersBoard.add('"'+usersList[i]['id'].toString()+'"');
  }
  print("selected id's = "+selectedUsersBoard.toString());
  },
  );                     
  }
  },
  );})
  )
  ]))
  ]))
  );
  },
  );
  } else {
  return Center(child: Text('No data found'));
  }
  }                        
  );
  } else {
  return Center(child: Text('No data found'));
  }
  },
  );
  })
  ])))
  )]
  )
  )),
  // ROW 7 : circle button of add board
  Container (
  margin: EdgeInsets.all(screenSize.height*0.01),
  decoration: BoxDecoration(color: Color(0xFF7195EE) , shape: BoxShape.circle),
  padding: EdgeInsets.only(left:20,right: 20,top:10,bottom: 10),
  child: Center(child:IconButton(icon: Icon(Icons.add,color:Colors.black) , onPressed: () async {      
  print("add Board");
  print("boardName = "+boardNameController.text.toString()+" // selected user id's are :"+selectedUsersBoard.toString());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? user_id = prefs.getInt("id");
  if ( selectedUsersBoard.contains('"'+user_id.toString()+'"') == false) {
      selectedUsersBoard.add('"'+user_id!.toString()+'"');
  }
  try {
      API.addBoard(boardNameController.text, user_id!, selectedUsersBoard.toString()); // selectedUsersBoard = AssignedTo 'users'
      style.popUpWidget(context, "Add Board", "Board : "+boardNameController.text.toString()+" is added successfuly", DialogType.success);
  } catch(e) {
    print("error excpetion = " + e.toString());
  }         
  }
  ))
  ),
  ]
  ) , 
  ),
  )
  );
  }
}

