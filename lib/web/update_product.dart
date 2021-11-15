import 'dart:convert';

import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:http/http.dart' as http;

class UpdateProduct {
  int id;
  String name;
  int price;
  String? barcode;

  UpdateProduct(
      {required this.id,
      required this.name,
      required this.price, this.barcode});

  Future<ShopItem> sendRequest() async {
    final body = jsonEncode(
        {"id": id, "name": name, "price": price, "barcode": barcode});
    final response = await http.post(
        Uri.parse(WebConfig.url + "/updateProduct"),
        headers: WebConfig.headers,
        body: body);
    try {
      ShopItem updated=ShopItem.fromJson(jsonDecode(response.body)["product"]);
      return updated;
    } catch (e) {
      //ErrorMessage err=ErrorMessage.fromJson(jsonDecode(response.body));
      return Future.error("err");
    }
  }
}
