import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/config/loader.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop_assistant/screens/add_new_item.dart';
import 'package:shop_assistant/web/get_all_coupons.dart';

import 'coupon_screen.dart';
import 'update_item_screen.dart';

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
  String _scanBarcode = "";
  String textFilter = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ids = List.empty(growable: true);
    shops = List.empty(growable: true);

    if (filteredItems.isEmpty) {
      itemTiles = widget.originalItems.map((e) => _ListTileBuilder(e, ids));
    } else {
      itemTiles = filteredItems.map((e) => _ListTileBuilder(e, ids));
    }
    shopFilterTiles = distinctShops().map((e) => _ShopFilterBuilder(e, shops));
    search.addListener(() {
      setState(() {
        textFilter = search.text;
        _refresh();
      });
    });
  }

  List<Shop> distinctShops() {
    List<int> dShopIds = List.empty(growable: true);
    List<Shop> distinctShop = List.empty(growable: true);
    widget.originalItems.forEach((element) {
      if (!dShopIds.contains(element.shop.id)) {
        dShopIds.add(element.shop.id);
        distinctShop.add(element.shop);
      }
    });
    return distinctShop;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).add_product_appBar)),
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(AppLocalizations.of(context).filter),
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
              ),
              ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemScreen(distinctShops: distinctShops())),), child: Text(AppLocalizations.of(context).new_product_button))
            ],
          ),
        ),
        body: Column(
          children: [
            TextFormField(controller: search),
            Expanded(
                flex: 5,
                child: ListView.builder(
                    itemCount: itemTiles.length,
                    itemBuilder: (context, index) =>
                        itemTiles.elementAt(index))),
            Expanded(flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockSizeVertical*3)),
                        onPressed: () async {
                          await scanBarcodeNormal();
                        },
                        child: Text(AppLocalizations.of(context).barcode_scanner),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal, vertical: SizeConfig.blockSizeVertical),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockSizeVertical*3)),
                        onPressed: () {
                          loadCoupons();
                        },
                        child: Text(AppLocalizations.of(context).coupons_button),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadCoupons() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoadingHandler(
                future: GetCoupons().sendRequest,
                succeeding: (List<Coupon> sList) {
                  return CouponScreen(originalCoupons: sList);
                }))).then((value) => setState(() {}));
  }

  void _refresh() {
    if (textFilter != "") {
      List<ShopItem> textFiltered = List.empty(growable: true);
      if (filteredItems.isNotEmpty) {
        filteredItems.forEach((element) {
          if (element.name.toLowerCase().contains(textFilter.toLowerCase())) {
            textFiltered.add(element);
          }
        });
        itemTiles = textFiltered.map((e) => _ListTileBuilder(e, ids));
      } else {
        widget.originalItems.forEach((element) {
          if (element.name.toLowerCase().contains(textFilter.toLowerCase())) {
            textFiltered.add(element);
          }
        });
        itemTiles = textFiltered.map((e) => _ListTileBuilder(e, ids));
      }
    } else {
      if (filteredItems.isEmpty) {
        itemTiles = widget.originalItems.map((e) => _ListTileBuilder(e, ids));
      } else {
        itemTiles = filteredItems.map((e) => _ListTileBuilder(e, ids));
      }
    }
  }

  StatefulBuilder _ListTileBuilder(ShopItem item, List<int> ids) {
    return StatefulBuilder(
      builder: (context, _setState) => GestureDetector(
        onLongPress: () {
          print("asdf");
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context).alertDialogTitle),
              content: Text(AppLocalizations.of(context).update_product),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    ///TODO add new item
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateItemScreen(
                                  item: item,
                                )));
                  },
                  child: Text(AppLocalizations.of(context).yes),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
              ],
            ),
          );

          ///TODO
          ///go to shopItem edit here
        },
        child: CheckboxListTile(
          isThreeLine: true,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name + ",  "),
                  ],
                ),
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
          subtitle: Text(item.shop.name +
              "  " +
              item.shop.address +
              "\n" +
              item.price.toString() +
              "Ft"),
        ),
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
              ? addToFilteredItems(
                  shop) //AppModel.of(context).addToShoppingList(context, item)
              : removeFromFilteredItems(
                  shop); //AppModel.of(context).removeFromShoppingList(context, item);
        },
        title: Text(shop.name + " "),
        subtitle: Text(shop.address),
      ),
    );
  }

  Future<ShopItem?> _searchItemByBarcode(String barcode) async {
    ShopItem? foundElement;
    if (filteredItems.isNotEmpty) {
      filteredItems.forEach((element) {
        if (element.barcode != null) {
          if (element.barcode == barcode) {
            foundElement = element;
            return;
          }
        }
      });
    } else {
      widget.originalItems.forEach((element) {
        if (element.barcode != null) {
          if (element.barcode == barcode) {
            foundElement = element;
            return;
          }
        }
      });
    }
    return foundElement;
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (barcodeScanRes != "-1") {
        ShopItem? itemFound = await _searchItemByBarcode(barcodeScanRes);
        if (itemFound != null) {
          setState(() {
            search.text = itemFound.name;
            //textFilter = itemFound.name;
            _refresh();
            return;
          });
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context).alertDialogTitle),
              content: Text(AppLocalizations.of(context).alertDialogText),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    ///TODO add new item
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
              ],
            ),
          );
        }
      }
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
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
