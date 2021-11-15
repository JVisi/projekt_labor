import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/config/loader.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop_assistant/web/update_product.dart';

class UpdateItemScreen extends StatefulWidget {
  ShopItem item;

  UpdateItemScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UpdateItemScreenState();
}

class UpdateItemScreenState extends State<UpdateItemScreen> {
  final _price = TextEditingController();
  final _barcode = TextEditingController();
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                      controller: _name..text = widget.item!.name,
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
                      controller: _price..text = widget.item!.price.toString(),
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
                      controller: _barcode..text = widget.item!.barcode ?? "",
                      keyboardType: TextInputType.number,
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
                          ShopItem current = widget.item;
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              LoadingHandler(
                                  future: UpdateProduct(id: widget.item.id,
                                      name: _name.text,
                                      price: int.parse(_price.text),
                                      barcode: _barcode.text != "" ? _barcode
                                          .text : null).sendRequest,
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
                                              Navigator.pop(context);         /// going back to main_screen
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                  })));
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

}
