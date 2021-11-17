import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/config/loader.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop_assistant/web/add_new_product.dart';
import 'package:shop_assistant/web/update_product.dart';

class AddItemScreen extends StatefulWidget {
  List<Shop> distinctShops;

  AddItemScreen({Key? key, required this.distinctShops}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddItemScreenState();
}

class AddItemScreenState extends State<AddItemScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _barcode = TextEditingController();
  late int _chosenShopId;

  @override
  void initState() {
    super.initState();
    _chosenShopId=widget.distinctShops.first.id;
    _name.addListener(nameCheck);
    _price.addListener(priceCheck);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations
              .of(context)
              .update_product_appBar),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                        vertical: SizeConfig.blockSizeVertical / 2),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations
                              .of(context)
                              .item_name),
                      controller: _name,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                        vertical: SizeConfig.blockSizeVertical / 2),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations
                              .of(context)
                              .item_price),
                      controller: _price,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                        vertical: SizeConfig.blockSizeVertical / 2),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations
                              .of(context)
                              .item_barcode),
                      controller: _barcode,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 8,
                        vertical: SizeConfig.blockSizeVertical*2),
                    child: DropdownButton<int>(
                      value: _chosenShopId,
                      items: widget.distinctShops.map((Shop shop) {
                        return DropdownMenuItem<int>(
                          value: shop.id,
                          child: Text(shop.name+" "+shop.address),
                        );
                      }).toList(),
                      onChanged: (_shop) {
                        setState(() {
                          print(_shop);
                          _chosenShopId=_shop!;
                        });
                      },
                    ),
                  ),



                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                        vertical: SizeConfig.blockSizeVertical * 3),
                    child: ElevatedButton(
                        onPressed: () async {
                          ///TODO updateProduct from web
                          ///
                          if(priceCheck() && nameCheck()){
                             Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              LoadingHandler(
                                  future: AddProduct(
                                      name: _name.text,
                                      price: int.parse(_price.text),
                                      barcode: _barcode.text != "" ? _barcode
                                          .text : null,shopId: _chosenShopId).sendRequest,
                                  succeeding: (ShopItem updated){
                                    return  AlertDialog(
                                      title: Text(AppLocalizations.of(context).alertDialogTitle),
                                      content: Text(AppLocalizations.of(context).successful_update),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            ///TODO add new item
                                            Navigator.pop(context, 'OK');
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);         /// going back to main_screen
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  })));
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).fillTextFormWarning),
                              duration: const Duration(milliseconds: 750),));
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockSizeVertical * 3)),
                        child: Text(AppLocalizations
                            .of(context)
                            .save_changes)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool priceCheck()=> _price.text!="";
  bool nameCheck()=> _name.text.length>2;
}














































