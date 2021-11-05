import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


final routes={
  // '/loginPage':(context)=>const LoginScreen(),
  // '/registerPage':(context)=>const RegisterScreen(),
};

/*
Future<void> saveToPreferences(String? email,String? password) async{
  SharedPreferences loginCredentials= await SharedPreferences.getInstance();
  if(email!=null && password!=null){
    loginCredentials.setString("email", email);
    loginCredentials.setString("password", password);
  }
}
Future<Map<String?, String?>> loadLoginCreds() async {
  SharedPreferences prefs=await SharedPreferences.getInstance();
  return {"email":prefs.getString("email"),"password":prefs.getString("password")};
}
Future<void> killLoginCreds() async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.remove("email");
  prefs.remove("password");
}
*/


class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth=0;
  static double screenHeight=0;
  static double blockSizeHorizontal=0;
  static double blockSizeVertical=0;
  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;


  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    if(_mediaQueryData!=null) {
      screenWidth = _mediaQueryData!.size.width;
      screenHeight = _mediaQueryData!.size.height;
      blockSizeHorizontal = screenWidth / 100;
      blockSizeVertical = screenHeight / 100;
      _safeAreaHorizontal =
          _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
      _safeAreaVertical =
          _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
      safeBlockHorizontal = (screenWidth - _safeAreaHorizontal!) / 100;
      safeBlockVertical = (screenHeight - _safeAreaVertical!) / 100;
    }
  }
}
class CustomColors{
  static Color backgroundColor = Colors.blue;
  static Color interact = Colors.orangeAccent;
  static Color textColor = Colors.orangeAccent;
  static Color starColor = Colors.yellow;
}

class WebConfig {
  static String url = "https://bookrate-api.herokuapp.com";
  static Map<String, String> headers = {
    HttpHeaders.contentTypeHeader:"application/json"
  };
  static String Cookie=""; //"authorization": WebConfig.authKey,
}
class ListViewWithoutGlowEffect extends ScrollBehavior{
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

ThemeData themeConfig() => ThemeData(
    iconTheme: IconThemeData(size: SizeConfig.blockSizeVertical * 7),
    textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: SizeConfig.blockSizeVertical * 5, fontWeight: FontWeight.bold, color:CustomColors.textColor),
        bodyText1: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.5, color:CustomColors.textColor)));