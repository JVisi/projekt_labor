import 'package:json_annotation/json_annotation.dart';

part 'shopping_list.g.dart';

@JsonSerializable()
class ShoppingList {
  List<ShopItem>? shopItems;
  List<Coupon>? coupons;

  ShoppingList({this.shopItems, this.coupons});

  double sumOfItems() {
    if (shopItems != null) {
      double sum = 0;
      shopItems!.forEach((element) {
        sum += element.price * element.amount!;
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
  int id;
  String name;
  int price;
  String? barcode;
  int shopId;
  Shop shop;
  int? amount;

  ShopItem(
      {required this.id,
      required this.name,
      required this.price,
      this.barcode,
      required this.shopId,
      required this.shop,
      this.amount});

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemToJson(this);
}

@JsonSerializable()
class Shop {
  int id;
  String name;
  String address;

  Shop({required this.id, required this.name, required this.address});

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);
}

@JsonSerializable()
class Coupon {
  int id;
  String name;
  @JsonKey(name: "description")
  String desc;
  double? bargain;
  String type;
  DateTime endDate;
  int shopId;
  Shop shop;
  int? amount;

  Coupon(
      {required this.id,
      required this.name,
      required this.desc,
      this.bargain,
      required this.type,
      required this.endDate,
      required this.shopId,
      required this.shop,
      this.amount});

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  Map<String, dynamic> toJson() => _$CouponToJson(this);

  double calculateBargain(double amountToPay) {
    ///TODO rewrite this thing
    ///could be switch-case tho
    if(type=="type1"){
      for(int i=0;i<amount!;i++){

        amountToPay= amountToPay - (amountToPay * (bargain! / 100));
      }
      return amountToPay;
    }
    else if(type=="type2"){
      for(int i=0;i<amount!;i++){
        amountToPay=amountToPay - bargain!;
      }
      return amountToPay;
    }
    else{
      return 0;
    }
  }
  ///type1: x% off from the price
  ///type2: set amount off from the price
}
