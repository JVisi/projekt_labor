import 'dart:convert';

import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:http/http.dart' as http;

class GetShopItems {
  Future<List<ShopItem>> sendRequest() async {
    final response = await http.get(Uri.parse(WebConfig.url + "/products"),
        headers: WebConfig.headers);
    try {
      List<dynamic> l = jsonDecode(response.body)["products"];
      List<ShopItem> sl=List.empty(growable: true);
      l.forEach((element) {
          sl.add(ShopItem.fromJson(element));
      });
      return sl;
    } catch (e) {
      //ErrorMessage err=ErrorMessage.fromJson(jsonDecode(response.body));
      return Future.error("err");
    }
  }
}
