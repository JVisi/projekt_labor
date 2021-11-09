import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/config/loader.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:shop_assistant/screens/item_screen.dart';
import 'package:shop_assistant/web/get_all_shop_items.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late ShoppingList shoppingList;
  late List<ListTile> listTiles;

  @override
  initState() {
    super.initState();
    shoppingList = AppModel.of(context).getShoppingList();
    listTiles = _listViewBuilder(shoppingList);
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: listTiles.length != 0
                ? ListView.builder(
                    itemCount: listTiles.length,
                    itemBuilder: (context, index) => listTiles.elementAt(index))
                : Center(
                    child: Text(AppLocalizations.of(context).empty_list),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppLocalizations.of(context).final_amount +
                      bargainCounter(shoppingList).toString(),
                  style: themeConfig().textTheme.bodyText2,
                ),
                FloatingActionButton(
                    onPressed: () {
                      _loadProducts_Debug();
                    },
                    tooltip: AppLocalizations.of(context).add_item_tooltip,
                    child: Icon(Icons.add))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadProducts_Debug() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoadingHandler(
                future: GetShopItems().sendRequest,
                succeeding: (List<ShopItem> sList) {
                  return ItemScreen(items: sList);
                }))).then((value) => setState(() {
          shoppingList = AppModel.of(context).getShoppingList();
          listTiles = _listViewBuilder(shoppingList);
        }));
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
    return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(item.name),
              ],
            ),
            Column(
              children: [
                Text(AppLocalizations.of(context).amount+item.amount!.toString()),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    AppModel.of(context).removeFromShoppingList(context, item);
                    _refresh();
                  },
                )
              ],
            )
          ],
        ),
        subtitle: Text(item.price.toString()));
  }

  void _refresh() {
    setState(() {
      shoppingList = AppModel.of(context).getShoppingList();
      listTiles = _listViewBuilder(shoppingList);
    });
  }

  ListTile _couponListTileBuilder(Coupon coupon) {
    return ListTile(
      title: Text(
        coupon.name + ",  " + coupon.bargain.toString() + "%",
      ),
    );
  }

  double bargainCounter(ShoppingList shoppingList) {
    double fullAmount = shoppingList.sumOfItems();
    if (shoppingList.coupons != null) {
      shoppingList.coupons!.forEach((element) {
        fullAmount = element.calculateBargain(fullAmount);
      });
    }
    return fullAmount;
  }
}
