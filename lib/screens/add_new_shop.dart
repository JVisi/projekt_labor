import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/config/core.dart';
import 'package:shop_assistant/config/loader.dart';
import 'package:shop_assistant/config/model.dart';
import 'package:shop_assistant/core/shopping_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop_assistant/web/add_new_product.dart';
import 'package:shop_assistant/web/add_new_shop.dart';
import 'package:shop_assistant/web/update_product.dart';

class AddShopScreen extends StatefulWidget {

  AddShopScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddShopScreenState();
}

class AddShopScreenState extends State<AddShopScreen> {
  final _name = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.addListener(nameCheck);
    _address.addListener(addressCheck);
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
                              .shop_name),
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
                              .shop_address),
                      controller: _address,
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
                          if(addressCheck() && nameCheck()){
                             Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              LoadingHandler(
                                  future: AddShop(
                                      name: _name.text,address: _address.text).sendRequest,
                                  succeeding: (Shop shop){
                                    return  AlertDialog(
                                      title: Text(AppLocalizations.of(context).alertDialogTitle),
                                      content: Text(AppLocalizations.of(context).successful_add),
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

  bool addressCheck()=> _address.text!="";
  bool nameCheck()=> _name.text.length>2;
}














































