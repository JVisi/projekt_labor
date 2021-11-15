import 'dart:convert';

import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:http/http.dart' as http;

class AddProduct {
  String name;
  int price;
  String? barcode;
  int shopId;

  AddProduct({
      required this.name,
      required this.price,
      this.barcode,
      required this.shopId});

  Future<ShopItem> sendRequest() async {
    final body = jsonEncode({
      "name": name,
      "price": price,
      "barcode": barcode,
      "shopId": shopId
    });
    final response = await http.post(
        Uri.parse(WebConfig.url + "/addProduct"),
        headers: WebConfig.headers,
        body: body);
    try {
      ShopItem updated =
          ShopItem.fromJson(jsonDecode(response.body));
      return updated;
    } catch (e) {
      //ErrorMessage err=ErrorMessage.fromJson(jsonDecode(response.body));
      return Future.error("err");
    }
  }
}
