// ignore_for_file: constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Providers/add_product_provider.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Providers/register_provider.dart';
import 'package:myshop/Providers/search_provider.dart';
import 'package:myshop/Screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', ''), Locale('ar', '')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', ''),
        child: const MyShop()),
  );
}

const Color blueColor = Color(0xff4cc9f0);
const Color pinkColor = Color(0xffb5179e);
Color purpleColor = Colors.purple.shade800;
const String font = 'YesevaOne';
const hostName = "http://192.168.43.60/ite/public/api";

Map<String, String> headers = {'Accept': 'application/json'};

enum AuthMode { SignIn, SignUp }

class MyShop extends StatelessWidget {
  const MyShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => AddProductProvider()),
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: purpleColor,
              fontFamily: font,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
