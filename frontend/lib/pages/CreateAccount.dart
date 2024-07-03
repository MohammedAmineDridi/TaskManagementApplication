import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:neopop/neopop.dart';
import 'package:provider/provider.dart';
import '../Providers/CreateAccountPageModel.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:my_app1/model/user.dart';
import '../http/APIs.dart' as API;
import '../style/style.dart' as style;

class CreateAccountPage extends StatelessWidget {
  
  CreateAccountPage({super.key});

  Color screenColor = Color(0xFF081245);
  bool initIsChecked = false;
  RegExp regExpEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isEmailValid = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? image = null;

  Future getImageFromGallery() async {
  final picker = ImagePicker();
  final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedImageFile != null) {
    image = File(pickedImageFile.path);
  } else {
    print('No image selected.');
    return;
  }
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
    create: (_) => CreateAccountPageModel(),
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
    Spacer(),
    Text("Let's create your account",style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 18))
    ])
    ),
    // ********************* TEXT FIELDS ***************************
    Container(
    margin: EdgeInsets.all(screenSize.height*0.02),
    alignment: Alignment.topLeft,
    padding: EdgeInsets.only(left:screenSize.height*0.015 , right:screenSize.height*0.015),
    child:Column(
    children: [
    // username textfield
    TextField(
    controller: usernameController,
    cursorColor: Colors.white,
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Username" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    prefixIcon: Icon(Icons.person,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ),
    ),
    SizedBox(height: screenSize.height*0.02),
    // email textfield
    Selector<CreateAccountPageModel, bool>(
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
    suffixIcon: context.watch<CreateAccountPageModel>().getemailIsValid() == false ? const Icon(Icons.error_outline,color:Color.fromARGB(255, 232, 136, 112)) : null,
    prefixIcon: Icon(Icons.email_outlined,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ),
    onChanged: (newEmailValue) {
      print("new email = "+newEmailValue.toString());
      isEmailValid = regExpEmail.hasMatch(newEmailValue);
      print("Emailregex output validation = "+isEmailValid.toString());
      context.read<CreateAccountPageModel>().setemailIsValid(isEmailValid);
    },
    );
    }),
    SizedBox(height: screenSize.height*0.02),
    // phone number textfield
    TextField(
    controller: phoneNumberController,
    cursorColor: Colors.white,
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Phone number" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    prefixIcon: Icon(Icons.phone,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6))
    ),
    ),
    SizedBox(height: screenSize.height*0.02),
    // password textfield
    Selector<CreateAccountPageModel, bool>(
    selector: (context, model) => model.getpasswordIsobscure(),
    builder: (context, passwordIsobscure, _) {
    return TextField(
    controller: passwordController,
    cursorColor: Colors.white,
    obscureText: !( context.watch<CreateAccountPageModel>().getpasswordIsobscure() ),
    style: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white),
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Color.fromARGB(255, 83, 151, 210), width: 2.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10) , borderSide: BorderSide(color: Colors.white, width: 2.0)),
    hintText: "Password" , hintStyle: TextStyle(fontFamily:'Expressway',fontSize: 16,color: Colors.white) , 
    prefixIcon: Icon(Icons.lock_open_sharp,color: Color.fromARGB(255, 243, 240, 87).withOpacity(0.6)) ,
    suffixIcon: IconButton(onPressed: () {
      context.read<CreateAccountPageModel>().setpasswordIsobscure();
    }, 
    icon: Icon(context.watch<CreateAccountPageModel>().getpasswordIsobscure()? Icons.visibility : Icons.visibility_off),color: Colors.white)
    ),
    onChanged: (newPasswordValue) {
      print("new password = "+newPasswordValue.toString());
    },
    );
    }),

    SizedBox(height: screenSize.height*0.02),
    // choose your photo (image picker here ....)
    Selector<CreateAccountPageModel, bool>(
    selector: (context, model) => model.getphotoUsernameSelected(),
    builder: (context, photoUsernameSelected, _) {
    return Row(children: [
    context.watch<CreateAccountPageModel>().getphotoUsernameSelected() && image != null ? 
    ClipOval(
    child: Image.file(
    image!,
    height: 80,
    width: 80,
    scale: 2,
    fit: BoxFit.cover,
    ),
    ) : const Text("No photo selected !",style:TextStyle(color:Color.fromARGB(255, 232, 136, 112),fontFamily:'Expressway',fontSize: 12)) ,
    MaterialButton(
    child: Text("Choose your photo 📂",style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 12)),
    onPressed: () async {
      final picker = ImagePicker();
      final pickedImageFile = await picker.pickImage(source: ImageSource.gallery , maxHeight: 200 , maxWidth: 200);
      if (pickedImageFile != null) {
        image = File(pickedImageFile.path);
        context.read<CreateAccountPageModel>().setphotoUsernameSelected(true);
        print("************************* " + context.read<CreateAccountPageModel>().getphotoUsernameSelected().toString() + "************************* ");
      } else {
        print('No image selected.');
      }
    }),
    ]);
    }),
    // ********************* POLICIES AGREEMENT ***************************
    SizedBox(height: screenSize.height*0.02),
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Selector<CreateAccountPageModel, bool>(
    selector: (context, model) => model.getcheckboxStatus(),
    builder: (context, isEmailValid, _) {
    return Container(
    child:Checkbox(
    checkColor: Color(0xFF0D0D0D),
    activeColor: Color.fromARGB(255, 83, 151, 210),
    value: context.watch<CreateAccountPageModel>().getcheckboxStatus(),
    onChanged:(bool? newCheckBoxValue) {
      context.read<CreateAccountPageModel>().reversecheckboxStatus();
      print("agree policy checkbox = "+newCheckBoxValue.toString());
      initIsChecked = newCheckBoxValue!;
    }));
    }),
    const Text("I agree to Privacy Policy and Terms of use",style: TextStyle(color: Colors.white , fontFamily:'Expressway',fontSize: 12)),
    ]),
    // ********************* BUTTONS ***************************
    SizedBox(height: screenSize.height*0.02),
    NeoPopTiltedButton(
    isFloating: true,
    onTapUp: () {
      if (image != null) {
        String userName = usernameController.text;
        String email = emailController.text;
        int phoneNumber = int.parse(phoneNumberController.text);
        String password = passwordController.text;
        if ((userName != "") && (email != "") && (phoneNumber != 0) && (password != "") && (initIsChecked)) {
          API.addUser(new User(userName,email,password,phoneNumber,"") ,image!);
          style.popUpWidget(context, "Account Creation", "Congrats , Your account is created successfuly", DialogType.success);
        } else {
          style.popUpWidget(context, "Account Creation Error", "Error ! make sure that all inputs are not empty", DialogType.success);
        }
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
    ));
  }
}