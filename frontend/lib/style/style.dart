import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

  AwesomeDialog popUpWidget(BuildContext context, String popupTitle , String popupText, DialogType dialogType,{VoidCallback? onOkPress}) {
    return AwesomeDialog(
      context: context,
      dialogType: dialogType , // .success / .error / .warning / .info
      animType: AnimType.rightSlide,
      title: popupTitle,
      desc: popupText,
      btnCancelOnPress: (){
      },
      btnOkOnPress: onOkPress,
      )..show();
  }

  List<Color> cardsColors() {
    List<Color> listCardsColors = [];
    Color color1 = Color(0xFFB0E7F3);
    Color color2 = Color(0XFFD7F3B0);
    Color color3 = Color(0xFFF3E4B0);
    Color color4 = Color(0xFFF3C4B0);
    Color color5 = Color(0xFFB2B0F3);
    listCardsColors.addAll([color1,color2,color3,color4,color5]);
    return listCardsColors;
  }