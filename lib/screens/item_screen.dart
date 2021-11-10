import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';

class ItemScreen extends StatefulWidget {
  final List<ShopItem> originalItems;

  ItemScreen({required this.originalItems});

  @override
  State<StatefulWidget> createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  late Iterable<StatefulBuilder> itemTiles;

  late Iterable<StatefulBuilder> shopFilterTiles;
  final search = TextEditingController();
  late List<int> ids;
  late List<int> shops;
  List<ShopItem> filteredItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ids = List.empty(growable: true);
    shops = List.empty(growable: true);
    if (filteredItems.isEmpty) {
      itemTiles = widget.originalItems.map((e) => _ListTileBuilder(e, ids));
    } else {
      itemTiles = filteredItems!.map((e) => _ListTileBuilder(e, ids));
    }
    shopFilterTiles = distinctShops().map((e) => _ShopFilterBuilder(e, shops));
    search.addListener(() {});
  }

  void _refresh() {
    if (filteredItems.isEmpty) {
      itemTiles = widget.originalItems.map((e) => _ListTileBuilder(e, ids));
    } else {
      itemTiles = filteredItems!.map((e) => _ListTileBuilder(e, ids));
    }
  }

  List<Shop> distinctShops() {
    List<Shop> shops = List.empty(growable: true);
    widget.originalItems.forEach((element) {
      if (!shops.contains(element.shop)) {
        shops.add(element.shop);
      }
    });
    return shops;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Add items")),
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text('Filters'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: ListView.builder(
                    itemCount: shopFilterTiles.length,
                    itemBuilder: (context, index) =>
                        shopFilterTiles.elementAt(index)),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            TextFormField(controller: search),
            Expanded(
                child: ListView.builder(
                    itemCount: itemTiles.length,
                    itemBuilder: (context, index) =>
                        itemTiles.elementAt(index)))
          ],
        ),
      ),
    );
  }

  StatefulBuilder _ListTileBuilder(ShopItem item, List<int> ids) {
    return StatefulBuilder(
      builder: (context, _setState) => CheckboxListTile(
        value: ids.contains(item.id),
        onChanged: (toAdd) {
          _setState(() {
            if (toAdd!) {
              ids.add(item.id);
            } else {
              ids.remove(item.id);
            }
          });
          toAdd!
              ? AppModel.of(context).addToShoppingList(context, item)
              : AppModel.of(context).removeFromShoppingList(context, item);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  item.name + ",  " + item.price.toString() + "Ft",
                ),
              ],
            ),
            Column(
              children: [
                CustomNumberPicker(
                  initialValue: 1,
                  maxValue: 1000,
                  minValue: 1,
                  step: 1,
                  enable: !ids.contains(item.id),
                  onValue: (value) {
                    item.amount = int.parse(value.toString());
                  },
                ),
              ],
            )
          ],
        ),
        subtitle: Text(item.shop.name + "  " + item.shop.address ?? ""),
      ),
    );
  }

  StatefulBuilder _ShopFilterBuilder(Shop shop, List<int> shops) {
    return StatefulBuilder(
      builder: (context, _setState) => CheckboxListTile(
        value: shops.contains(shop.id),
        onChanged: (toFilter) {
          _setState(() {
            if (toFilter!) {
              shops.add(shop.id);
            } else {
              shops.remove(shop.id);
            }
          });
          toFilter!
              ? addToFilteredItems(shop)//AppModel.of(context).addToShoppingList(context, item)
              : removeFromFilteredItems(shop); //AppModel.of(context).removeFromShoppingList(context, item);
        },
        title: Text(shop.name + " "),
        subtitle: Text(shop.address ?? ""),
      ),
    );
  }

  void addToFilteredItems(Shop shop) {
    widget.originalItems.forEach((element) {
      if (element.shop.id == shop.id) {
        setState(() {
          filteredItems.add(element);
          _refresh();
        });
      }
    });
  }

  void removeFromFilteredItems(Shop shop) {
    widget.originalItems.forEach((element) {
      if (element.shop.id == shop.id) {
        setState(() {
          filteredItems.remove(element);
          _refresh();
        });
      }
    });
  }
}
