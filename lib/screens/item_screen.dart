import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';

class ItemScreen extends StatefulWidget {
  final List<ShopItem> items;

  ItemScreen({required this.items});

  @override
  State<StatefulWidget> createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {

  late Iterable<StatefulBuilder>itemTiles;
  final search=TextEditingController();
  late bool tileMarked;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemTiles=widget.items.map((e) => _ListTileBuilder(e));
    search.addListener(() { });
    tileMarked=false;
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextFormField(controller: search),
            Expanded(child: ListView.builder(itemCount: itemTiles.length,itemBuilder: (context,index)=>itemTiles.elementAt(index)))
          ],
        ),
      ),
    );
  }

  StatefulBuilder _ListTileBuilder(ShopItem item) {
    return StatefulBuilder(
      builder:(context, _setState)=> CheckboxListTile(
        value: tileMarked,
        onChanged: (toAdd) {
          _setState(() {
            tileMarked=!tileMarked;
          });
          toAdd!?AppModel.of(context).addToShoppingList(context,item):AppModel.of(context).removeFromShoppingList(context,item);

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
            Column(children: [
              CustomNumberPicker(
                initialValue: 1,
                maxValue: 1000,
                minValue: 1,
                step: 1,
                enable: true,
                onValue: (value) {
                  item.amount=int.parse(value.toString());
                },
              ),
            ],)
          ],
        ),
        subtitle: Text(item.shop.name + "  " + item.shop.address ?? ""),
      ),
    );
  }
}
