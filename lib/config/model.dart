import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shop_assistant/core/shopping_list.dart';

class AppModel extends Model{
  late ShoppingList shoppingList;

  void setList(ShoppingList currentList) =>shoppingList = currentList;
  ShoppingList getShoppingList() => shoppingList;
  /*late User _user;
  void setUser(User currentUser)=>_user=currentUser;
  User getUser()=>_user;*/


  static AppModel of(BuildContext context) => ScopedModel.of<AppModel>(context);
}
