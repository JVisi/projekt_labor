import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop_assistant/screens/main_screen.dart';
import 'config/core.dart';
import 'config/loader.dart';
import 'config/model.dart';
import 'core/shopping_list.dart';


void main() {
  final appModel = AppModel();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
      value) =>
      runApp(ScopedModel<AppModel>(model: appModel, child: const MyApp())));


  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('hu', ''), // Spanish, no country code
      ],
      title: 'Flutter Demo',
      initialRoute: '/',
      //routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Start(),

      ///check memory
    );
  }
}

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoadingHandler(future: loadShoppingList,
        succeeding: (ShoppingList slist) {
            return MainScreen(shoppingList: slist,);
        });
  }

}
