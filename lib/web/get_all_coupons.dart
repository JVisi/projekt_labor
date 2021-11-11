import 'dart:convert';

import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:http/http.dart' as http;

class GetCoupons {
  Future<List<Coupon>> sendRequest() async {
    final response = await http.get(Uri.parse(WebConfig.url + "/coupons"),
        headers: WebConfig.headers);
    try {
      List<dynamic> l = jsonDecode(response.body)["coupons"];
      List<Coupon> sl=List.empty(growable: true);
      l.forEach((element) {
        sl.add(Coupon.fromJson(element));
      });
      return sl;
    } catch (e) {
      //ErrorMessage err=ErrorMessage.fromJson(jsonDecode(response.body));
      return Future.error("err");
    }
  }
}
