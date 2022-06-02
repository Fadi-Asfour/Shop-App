import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Providers/register_provider.dart';
import 'package:myshop/Screens/add_product_screen.dart';
import 'package:myshop/Screens/register_screen.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  void navigate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('lang') == 'ar') {
      EasyLocalization.of(context)!.setLocale(const Locale('ar', ''));
    }
    Future.delayed(
        Duration(
            seconds: sharedPreferences.getBool('isSigned') == true ? 3 : 1),
        () async {
      bool isSigned = sharedPreferences.getBool('isSigned') ?? false;
      if (isSigned) {
        await Provider.of<RegisterProvider>(context, listen: false)
            .getUserInfoFromStorage();
        // await Provider.of<ProductsProvider>(context, listen: false)
        //     .getProducts(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RegisterScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [blueColor, pinkColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage(
                "assets/images/online-shopping.png",
              ),
              width: 150,
              height: 150,
              color: purpleColor,
            ),
            Text(
              'My Shop',
              style: TextStyle(
                color: purpleColor,
                shadows: const [
                  Shadow(
                    color: blueColor,
                    offset: Offset(0, 2),
                  ),
                ],
                fontSize: 30,
                fontWeight: FontWeight.w600,
                fontFamily: 'YesevaOne',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
