// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) => ShoppingList(
      shopItems: (json['shopItems'] as List<dynamic>?)
          ?.map((e) => ShopItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupons: (json['coupons'] as List<dynamic>?)
          ?.map((e) => Coupon.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) =>
    <String, dynamic>{
      'shopItems': instance.shopItems,
      'coupons': instance.coupons,
    };

ShopItem _$ShopItemFromJson(Map<String, dynamic> json) => ShopItem(
      name: json['name'] as String,
      price: json['price'] as String,
    );

Map<String, dynamic> _$ShopItemToJson(ShopItem instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };

Coupon _$CouponFromJson(Map<String, dynamic> json) => Coupon(
      name: json['name'] as String,
      desc: json['desc'] as String,
      bargain: (json['bargain'] as num).toDouble(),
    );

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'name': instance.name,
      'desc': instance.desc,
      'bargain': instance.bargain,
    };
