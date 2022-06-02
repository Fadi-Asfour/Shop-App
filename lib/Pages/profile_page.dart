// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Providers/register_provider.dart';
import 'package:myshop/Screens/product_details_screen.dart';
import 'package:myshop/Widgets/product_card.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<ProductsProvider>(context, listen: false)
            .getproductsByUserid(context);
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Consumer<RegisterProvider>(
                    builder: (context, register, _) => Text(
                      register.userInfo['name'],
                      style: TextStyle(
                          fontFamily: 'YesevaOne',
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: purpleColor),
                    ),
                  ),
                ),
              ),
              Consumer<RegisterProvider>(
                builder: (context, register, _) => Text(
                  register.userInfo['email'].toString(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: purpleColor,
                  ),
                ),
              ),
              Consumer<RegisterProvider>(builder: (context, register, _) {
                register.setLang();
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      register.buildRow('English', register.eng, context, true),
                      register.buildRow('العربية', register.ar, context, true),
                    ]);
              }),
              Consumer2<RegisterProvider, ProductsProvider>(
                builder: (context, register, product, _) => ElevatedButton.icon(
                  onPressed: () async {
                    await register.logout(context);
                    product.reset();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  label: register.logoutLoading
                      ? CircularProgressIndicator(
                          color: purpleColor,
                          strokeWidth: 2,
                        )
                      : Text('Logout'.tr()),
                  icon: const Icon(Icons.logout_outlined),
                ),
              ),
              Consumer<ProductsProvider>(builder: (context, product, _) {
                return ListBody(
                  children: product.userProducts
                      .map((e) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(e)));
                              product.viewIncreament(e['id'], context, true);
                            },
                            child: Consumer<ProductsProvider>(
                              builder: (context, product, _) => ProductCard(
                                  e['image_url'] ?? "",
                                  e['name'],
                                  e['views'] ?? 0,
                                  e['id'] ?? -1,
                                  e['is_liked'] ?? false,
                                  e['likes'] ?? 0,
                                  e['reviews'] ?? [],
                                  product.userProducts,
                                  true,
                                  false),
                            ),
                          ))
                      .toList(),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
