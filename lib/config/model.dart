import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shop_assistant/core/shopping_list.dart';

class AppModel extends Model {
  late ShoppingList shoppingList;

  void setList(ShoppingList currentList) => shoppingList = currentList;

  ShoppingList getShoppingList() => shoppingList;

  /*late User _user;
  void setUser(User currentUser)=>_user=currentUser;
  User getUser()=>_user;*/
  void addToShoppingList(BuildContext context, ShopItem item) {
    item.amount == null ? item.amount = 1 : null;
    final int index =
        shoppingList.shopItems!.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      int currentAmount = shoppingList.shopItems!.elementAt(index).amount!;
      shoppingList.shopItems!.removeWhere((element) => element.id == item.id);
      int newAmount = currentAmount + item.amount!;

      ShopItem newItem = ShopItem(
          id: item.id,
          name: item.name,
          price: item.price,
          shopId: item.shopId,
          shop: item.shop,
          amount: newAmount);
      shoppingList.shopItems!.add(newItem);
    } else {
      shoppingList.shopItems!.add(item);
    }
  }

  void removeFromShoppingList(BuildContext context, ShopItem item) {
    int index =
        shoppingList.shopItems!.indexWhere((element) => element.id == item.id);
    if (shoppingList.shopItems!.elementAt(index).amount! > item.amount!) {
      int newAmount =
          shoppingList.shopItems!.elementAt(index).amount! - item.amount!;
      shoppingList.shopItems!.removeWhere((element) => element.id == item.id);
      ShopItem newItem = ShopItem(
          id: item.id,
          name: item.name,
          price: item.price,
          shopId: item.shopId,
          shop: item.shop,
          amount: newAmount);
      shoppingList.shopItems!.add(newItem);
    } else {
      shoppingList.shopItems!.removeWhere((element) => element.id == item.id);
    }
  }

  void addToCoupons(BuildContext context, Coupon coupon) {
    coupon.amount == null ? coupon.amount = 1 : null;
    final int index =
        shoppingList.coupons!.indexWhere((element) => element.id == coupon.id);
    if (index != -1) {
      int currentAmount = shoppingList.coupons!.elementAt(index).amount!;
      shoppingList.coupons!.removeWhere((element) => element.id == coupon.id);
      int newAmount = currentAmount + coupon.amount!;

      Coupon newCoupon = Coupon(
          id: coupon.id,
          name: coupon.name,
          desc: coupon.desc,
          endDate: coupon.endDate,
          type: coupon.type,
          bargain: coupon.bargain,
          shopId: coupon.shopId,
          shop: coupon.shop,
          amount: newAmount);
      shoppingList.coupons!.add(newCoupon);
    } else {
      shoppingList.coupons!.add(coupon);
    }
  }

  void removeFromCoupons(BuildContext context, Coupon coupon) {
    int index =
        shoppingList.coupons!.indexWhere((element) => element.id == coupon.id);
    if (shoppingList.coupons!.elementAt(index).amount! > coupon.amount!) {
      int newAmount =
          shoppingList.coupons!.elementAt(index).amount! - coupon.amount!;
      shoppingList.coupons!.removeWhere((element) => element.id == coupon.id);
      Coupon newCoupon = Coupon(
          id: coupon.id,
          name: coupon.name,
          desc: coupon.desc,
          endDate: coupon.endDate,
          type: coupon.type,
          bargain: coupon.bargain,
          shopId: coupon.shopId,
          shop: coupon.shop,
          amount: newAmount);
      shoppingList.coupons!.add(newCoupon);
    } else {
      shoppingList.coupons!.removeWhere((element) => element.id == coupon.id);
    }
  }

  static AppModel of(BuildContext context) => ScopedModel.of<AppModel>(context);
}
