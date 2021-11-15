import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CouponScreen extends StatefulWidget {
  final List<Coupon> originalCoupons;

  CouponScreen({required this.originalCoupons});

  @override
  State<StatefulWidget> createState() => CouponScreenState();
}

class CouponScreenState extends State<CouponScreen> {
  late Iterable<StatefulBuilder> couponTiles;

  late Iterable<StatefulBuilder> shopFilterTiles;
  final search = TextEditingController();
  late List<int> ids;
  late List<int> shops;
  List<Coupon> filteredCoupons = [];
  String textFilter = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ids = List.empty(growable: true);
    shops = List.empty(growable: true);

    if (filteredCoupons.isEmpty) {
      couponTiles = widget.originalCoupons.map((e) => _ListTileBuilder(e, ids));
    } else {
      couponTiles = filteredCoupons.map((e) => _ListTileBuilder(e, ids));
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
    widget.originalCoupons.forEach((element) {
      if (!dShopIds.contains(element.shop.id)) {
        dShopIds.add(element.shop.id);
        distinctShop.add(element.shop);
      }
    });
    return distinctShop;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).coupons_button)),
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
              )
            ],
          ),
        ),
        body: Column(
          children: [
            TextFormField(controller: search),
            Expanded(
                flex: 5,
                child: ListView.builder(
                    itemCount: couponTiles.length,
                    itemBuilder: (context, index) =>
                        couponTiles.elementAt(index))),
          ],
        ),
      ),
    );
  }

  void _refresh() {
    if (textFilter != "") {
      List<Coupon> textFiltered = List.empty(growable: true);
      if (filteredCoupons.isNotEmpty) {
        filteredCoupons.forEach((element) {
          if (element.name.toLowerCase().contains(textFilter.toLowerCase())) {
            textFiltered.add(element);
          }
        });
        couponTiles = textFiltered.map((e) => _ListTileBuilder(e, ids));
      } else {
        widget.originalCoupons.forEach((element) {
          if (element.name.toLowerCase().contains(textFilter.toLowerCase())) {
            textFiltered.add(element);
          }
        });
        couponTiles = textFiltered.map((e) => _ListTileBuilder(e, ids));
      }
    } else {
      if (filteredCoupons.isEmpty) {
        couponTiles = widget.originalCoupons.map((e) => _ListTileBuilder(e, ids));
      } else {
        couponTiles = filteredCoupons.map((e) => _ListTileBuilder(e, ids));
      }
    }
  }

  StatefulBuilder _ListTileBuilder(Coupon coupon, List<int> ids) {
    return StatefulBuilder(
      builder: (context, _setState) => GestureDetector(
        onLongPress: () {
          print("asdf");

          ///TODO
          ///go to shopItem edit here
        },
        child: CheckboxListTile(isThreeLine: true,
          value: ids.contains(coupon.id),
          onChanged: (toAdd) {
            _setState(() {
              if (toAdd!) {
                ids.add(coupon.id);
              } else {
                ids.remove(coupon.id);
              }
            });
            toAdd!
                ? AppModel.of(context).addToCoupons(context, coupon)
                : AppModel.of(context).removeFromCoupons(context, coupon);
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        coupon.name + ",  "),
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
                    enable: !ids.contains(coupon.id),
                    onValue: (value) {
                      coupon.amount = int.parse(value.toString());
                    },
                  ),
                ],
              )
            ],
          ),
          subtitle: Text(coupon.shop.name + "  " + coupon.shop.address+"\n"+coupon.desc),
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
              ? addToFilteredCoupons(
              shop) //AppModel.of(context).addToShoppingList(context, item)
              : removeFromFilteredCoupons(
              shop); //AppModel.of(context).removeFromShoppingList(context, item);
        },
        title: Text(shop.name + " "),
        subtitle: Text(shop.address),
      ),
    );
  }

  void addToFilteredCoupons(Shop shop) {
    widget.originalCoupons.forEach((element) {
      if (element.shop.id == shop.id) {
        setState(() {
          filteredCoupons.add(element);
          _refresh();
        });
      }
    });
  }

  void removeFromFilteredCoupons(Shop shop) {
    widget.originalCoupons.forEach((element) {
      if (element.shop.id == shop.id) {
        setState(() {
          filteredCoupons.remove(element);
          _refresh();
        });
      }
    });
  }
}
