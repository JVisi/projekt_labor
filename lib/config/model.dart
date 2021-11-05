import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model{
  /*late User _user;
  void setUser(User currentUser)=>_user=currentUser;
  User getUser()=>_user;*/


  static AppModel of(BuildContext context) => ScopedModel.of<AppModel>(context);
}
