import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/core/shopping_list.dart';

class MainScreen extends StatefulWidget {
  ShoppingList shoppingList;

  MainScreen({Key? key, required this.shoppingList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    //Dummy data
    List<ShopItem> items = List.empty(growable: true);
    items.add(ShopItem(name: "asdf", price: "489"));
    items.add(ShopItem(name: "qwer", price: "399"));
    List<Coupon> coupons = List.empty(growable: true);
    coupons.add(Coupon(name: "kupon1", bargain: 10, desc: "10%"));
    widget.shoppingList = ShoppingList(shopItems: items, coupons: coupons);

    final listTiles = _listViewBuilder(widget.shoppingList);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: listTiles.length,
                itemBuilder: (context, index) => listTiles.elementAt(index)),
          ),
          Text(bargainCounter().toString()),
        ],
      ),
    );
  }

  List<ListTile> _listViewBuilder(ShoppingList sl) {
    List<ListTile> allTiles = List.empty(growable: true);
    if (sl.shopItems != null) {
      final shopItems = sl.shopItems!.map((e) => _shopItemListTileBuilder(e));
      shopItems.forEach((element) {
        allTiles.add(element);
      });
    }
    if (sl.coupons != null) {
      final coupons = sl.coupons!.map((e) => _couponListTileBuilder(e));
      coupons.forEach((element) {
        allTiles.add(element);
      });
    }

    return allTiles;
  }

  ListTile _shopItemListTileBuilder(ShopItem item) {
    return ListTile(title: Text(item.name), subtitle: Text(item.price));
  }

  ListTile _couponListTileBuilder(Coupon coupon) {
    return ListTile(
      title: Text(
        coupon.name + ",  " + coupon.bargain.toString() + "%",
      ),
    );
  }

  double bargainCounter() {
    double fullAmount = widget.shoppingList.sumOfItems();
    if (widget.shoppingList.coupons != null) {
      widget.shoppingList.coupons!.forEach((element) {
        fullAmount = element.calculateBargain(fullAmount);
      });
    }
    return fullAmount;
  }
}
