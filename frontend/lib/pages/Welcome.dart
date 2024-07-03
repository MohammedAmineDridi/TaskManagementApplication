import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:provider/provider.dart';
import '../Providers/WelcomePageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style/style.dart' as style;
import 'package:awesome_dialog/awesome_dialog.dart';
import '../http/APIs.dart' as API;

class WelcomePage extends StatelessWidget {

  WelcomePage({super.key});

  Color screenColor = Color(0xFF081245);
  bool initIsChecked = false;
  RegExp regExpEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isEmailValid = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int? userId ;

  @override
  Widget build(BuildContext context) {

    init(context);
    Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
    create: (_) => WelcomePageModel(),
    child: Scaffold(
    resizeToAvoidBottomInset: true,
    backgroundColor:screenColor,
    body: SingleChildScrollView( child:Container(
    height: screenSize.height,
    width: screenSize.width,
    margin: EdgeInsets.only(left:screenSize.height*0.01,top:screenSize.height*0.06,right:screenSize.height*0.01,bottom:screenSize.height*0.01),
    child: Column(
    children: [
    // ********************* LOGO & DESCRIPTION ***************************
    Container(
    margin: EdgeInsets.only(right: screenSize.height*0.02),
    alignment: Alignment.topLeft , 
    child: Row(children: [
    Image.asset("assets/images/Taskify_logo.png",height:screenSize.height*0.3),
    Flexible( child:Text("Taskify is a free daily routine task management application",style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 18))),
    ])
    ),
    // ********************* TEXT FIELDS ***************************
    // TextFields Container (Email & Password)
    Container(
    margin: EdgeInsets.all(screenSize.height*0.02),
    alignment: Alignment.topLeft,
    padding: EdgeInsets.only(left:screenSize.height*0.015 , right:screenSize.height*0.015),
    child:Column(
    children: [
    // email textfield
    Selector<WelcomePageModel, bool>(
    selector: (context, model) => model.getemailIsValid(),
    builder: (context, isEmailValid, _) {
    return TextField(
    controller: emailController,
    cursorColor: Colors.white,
    style: TextStyle(fontFamily:'Expressway',fontSize: 15,color: Colors.white),
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Email" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    suffixIcon: context.watch<WelcomePageModel>().getemailIsValid() == false ? const Icon(Icons.error_outline,color:Color.fromARGB(255, 232, 136, 112)) : null,
    prefixIcon: Icon(Icons.email_outlined,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ),
    onChanged: (newEmailValue) {
      print("new email = "+newEmailValue.toString());
      isEmailValid = regExpEmail.hasMatch(newEmailValue);
      print("Emailregex output validation = "+isEmailValid.toString());
      context.read<WelcomePageModel>().setemailIsValid(isEmailValid);
    },
    );
    }),
    SizedBox(height: screenSize.height*0.02),
    Selector<WelcomePageModel, bool>(
    selector: (context, model) => model.getpasswordIsobscure(),
    builder: (context, isEmailValid, _) {
    return TextField(
    controller: passwordController,
    cursorColor: Colors.white,
    obscureText: !( context.watch<WelcomePageModel>().getpasswordIsobscure() ),
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Password" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    prefixIcon: Icon(Icons.lock_open_sharp,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6)) ,
    suffixIcon: IconButton(onPressed: () {
      context.read<WelcomePageModel>().setpasswordIsobscure();
    }, 
    icon: Icon(context.watch<WelcomePageModel>().getpasswordIsobscure()? Icons.visibility : Icons.visibility_off),color: Colors.white)
    ),
    onChanged: (newPasswordValue) {
      print("new password = "+newPasswordValue.toString());
    }, // changing icon with state mang (cosumer)
    );
    }),
    // ********************* REMEBER ME & FORGET PASSWORD ***************************
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Selector<WelcomePageModel, bool>(
    selector: (context, model) => model.getcheckboxStatus(),
    builder: (context, isCheckBoxTrue, _) {
    return Container(
    child:Checkbox(
    checkColor: Color(0xFF0D0D0D),
    activeColor: Color.fromARGB(255, 83, 151, 210),
    value: context.watch<WelcomePageModel>().getcheckboxStatus(),
    onChanged:(bool? newCheckBoxValue) {
      context.read<WelcomePageModel>().reversecheckboxStatus();
      print("remeber me = "+newCheckBoxValue.toString());
    }));
    }),
    const Text("Remember Me",style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 12)),
    Spacer(),
    GestureDetector(             
    onTap: () {
      print("Forgot password clicked!");
      Navigator.of(context).pushReplacementNamed('forgotPassword');
    },
    child: Container(
    margin: EdgeInsets.only(right:20),
    child:const Text(
    "Forgot Password ?",
    style: TextStyle(
    color: Colors.white,
    fontFamily:'Expressway',
    fontSize: 12
    ),
    textAlign: TextAlign.end
    ),),
    )
    ]),
    // ********************* BUTTONS ***************************
    Selector<WelcomePageModel, bool>(
    selector: (context, model) => model.getcheckboxStatus(),
    builder: (context, isCheckBoxTrue, _) {
    return NeoPopTiltedButton(
    isFloating: true,
    onTapUp: () async {
      List<dynamic> personLogin = await API.login(emailController.text,passwordController.text);
      print("person login is : "+personLogin.toString());
      if (personLogin.isNotEmpty) {
      print("********** login Correct ***********");
      if ( context.read<WelcomePageModel>().getcheckboxStatus() ) {
        SharedPreferences prefsId = await SharedPreferences.getInstance();
        prefsId.setInt("id", personLogin[0]['id']); 
      }
      Navigator.of(context).pushReplacementNamed('tasksboardsList');
      } else {
        print("********** login Incorrect ***********");
        style.popUpWidget(context,"Login incorrect","Email and/or Password are incorrect !",DialogType.error); 
      }
    },
    decoration: const NeoPopTiltedButtonDecoration(
    color: Color(0xFF0D0D0D) ,
    plunkColor: Color.fromARGB(255, 83, 151, 210),
    shadowColor: Colors.black,
    border: Border.fromBorderSide(
    BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 1),
    ),
    ),
    child: Container(
    padding: EdgeInsets.only(top:20 , bottom: 20),
    child: Center(child:Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('Sign In', style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 20)),
    SizedBox(width: 10),
    Icon(Icons.login,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ]))
    ),
    );
    }),
    NeoPopTiltedButton(
    isFloating: true,
    onTapUp: () {
      Navigator.of(context).pushReplacementNamed('createAccount');
    },
    decoration: const NeoPopTiltedButtonDecoration(
    color: Color(0xFF0D0D0D),
    plunkColor: Color.fromARGB(255, 83, 151, 210), // new color = 5FAAEB / old color = 0xFF3F6915
    shadowColor: Colors.black,
    border: Border.fromBorderSide(
    BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 1), // old color = 0xFF8DD04A
    ),
    ),
    child: Container(
    padding: EdgeInsets.only(top:20 , bottom: 20),
    child: Center(child:Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('Create an account', style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 20)),
    SizedBox(width: 10),
    Icon(Icons.account_box_sharp,color:Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ]))
    ),
    ),
    ]),
    ),
    ]
    ) , 
    ),
    ),
    )
    );
    }
    Future<void> init(BuildContext context) async {  
      SharedPreferences prefsId = await SharedPreferences.getInstance();
      userId = prefsId.getInt("id");
      print("init : WelcomePage : user_id = "+userId.toString());
      if (userId != null) {
        Navigator.of(context).pushReplacementNamed('tasksboardsList');
      }
    }
}


