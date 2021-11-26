import 'dart:convert';

import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:http/http.dart' as http;

class AddShop {
  String name;
  String address;

  AddShop({required this.name, required this.address});

  Future<Shop> sendRequest() async {
    final body = jsonEncode(
        {"name": name, "address": address,});
    final response = await http.post(Uri.parse(WebConfig.url + "/addShop"),
        headers: WebConfig.headers, body: body);
    try {
      Shop shop = Shop.fromJson(jsonDecode(response.body)["shop"]);
      return shop;
    } catch (e) {
      //ErrorMessage err=ErrorMessage.fromJson(jsonDecode(response.body));
      return Future.error("err");
    }
  }
}
