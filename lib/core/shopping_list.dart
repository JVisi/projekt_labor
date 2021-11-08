import 'package:json_annotation/json_annotation.dart';

part 'shopping_list.g.dart';

@JsonSerializable()
class ShoppingList {
  List<ShopItem>? shopItems;
  List<Coupon>? coupons;

  ShoppingList({this.shopItems, this.coupons});

  double sumOfItems(){
    if(shopItems!=null){
      double sum=0;
      shopItems!.forEach((element) {
          sum+=double.parse(element.price);
      });
      return sum;
    }
    return 0;
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);
}

@JsonSerializable()
class ShopItem {
  String name;
  String price;

  ShopItem({required this.name, required this.price});

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemToJson(this);
}

@JsonSerializable()
class Coupon {
  String name;
  String desc;
  double bargain;

  Coupon({required this.name, required this.desc, required this.bargain});

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  Map<String, dynamic> toJson() => _$CouponToJson(this);

  double calculateBargain(double amountToPay) {
    return amountToPay-(amountToPay * (bargain / 100));
  }
}
