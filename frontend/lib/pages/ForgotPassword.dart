import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:provider/provider.dart';
import '../Providers/ForgotPasswordPageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../http/APIs.dart' as API;
import '../style/style.dart' as style;

class ForgotPasswordPage extends StatelessWidget {

  ForgotPasswordPage({super.key});

  Color screenColor = Color(0xFF081245);
  RegExp regExpEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isEmailValid = false;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
    create: (_) => ForgotPasswordPageModel(),
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
    margin: EdgeInsets.all(screenSize.height*0.02),
    padding: EdgeInsets.only(left:10,right:40),
    child: Row(children: [
    GestureDetector(
    onTap: () {
      print("return to welcome page");
    },
    child:IconButton(icon: const Icon(Icons.arrow_circle_left_outlined),color:Color.fromARGB(255, 243, 240, 87).withOpacity(0.6) , onPressed: () {
      Navigator.of(context).pushReplacementNamed('welcome');
    } , iconSize: 34),
    ),
    Container(
    margin: EdgeInsets.only(left:30),
    child:Text("Forget Password",
    style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 18)))
    ])
    ),
    // ********************* TEXT FIELDS ***************************
    Container(
    margin: EdgeInsets.all(screenSize.height*0.05),
    alignment: Alignment.topLeft,
    padding: EdgeInsets.only(left:screenSize.height*0.015 , right:screenSize.height*0.015),
    child:Column(
    children: [
    SizedBox(height: screenSize.height*0.02),
    // email textfield
    Selector<ForgotPasswordPageModel, bool>(
    selector: (context, model) => model.getemailIsValid(),
    builder: (context, isEmailValid, _) {
    return TextField(
    controller: emailController,
    cursorColor: Colors.white,
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Email" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    suffixIcon: context.watch<ForgotPasswordPageModel>().getemailIsValid() == false ? const Icon(Icons.error_outline,color:Color.fromARGB(255, 232, 136, 112)) : null,
    prefixIcon: Icon(Icons.email_outlined,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ),
    onChanged: (newEmailValue) {
      print("new email = "+newEmailValue.toString());
      isEmailValid = regExpEmail.hasMatch(newEmailValue);
      print("Emailregex output validation = "+isEmailValid.toString());
      context.read<ForgotPasswordPageModel>().setemailIsValid(isEmailValid);
    },
    );
    }),
    SizedBox(height: screenSize.height*0.04),
    // ********************* BUTTONS ***************************
    NeoPopTiltedButton(
    isFloating: true,
    onTapUp: ()  async { 
    List<dynamic> passwordObject = await API.resetPassword(emailController.text.toString());
    if (passwordObject.isEmpty) {
      style.popUpWidget(context, "Email Error", "Your Email is not correct , please verify your Email !", DialogType.error);
    } else {
      String password = passwordObject[0]['password'];
      print("password = "+password);
      SharedPreferences prefsId = await SharedPreferences.getInstance();
      int? userId = prefsId.getInt("id");
      print("Forgot Password Page user_id : "+userId.toString());
      List<dynamic> user = await API.getUserById(userId!);
      String userName = user[0]['userName'];
      String to = emailController.text.toString();
      String subject = "RESET PASSWORD";
      String message = "Hi"+userName+", your password is : "+password;
      await API.sendEmail(to,subject,message);
      print("****** email is sent to "+emailController.text.toString());
      style.popUpWidget(context, "Password Sent", "You'll find your password in your Email", DialogType.success);
    }
    },
    decoration: const NeoPopTiltedButtonDecoration(
    color: Color(0xFF0D0D0D),
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
    Text('Submit', style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 22)),
    SizedBox(width: 10),
    Icon(Icons.check,color:Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
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
}