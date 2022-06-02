import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Pages/home_page.dart';
import 'package:myshop/Pages/profile_page.dart';
import 'package:myshop/Providers/add_product_provider.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Screens/add_product_screen.dart';
import 'package:myshop/Screens/product_details_screen.dart';
import 'package:myshop/Screens/register_screen.dart';
import 'package:myshop/Screens/search_screen.dart';
import 'package:myshop/Widgets/appbar.dart';
import 'package:myshop/Widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<HomeScreen> {
  List<Widget> pages = [HomePage(), ProfilePage()];
  int currentIndex = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false).getProducts(context);
    Provider.of<AddProductProvider>(context, listen: false)
        .getCategories(context);
    Provider.of<ProductsProvider>(context, listen: false)
        .getproductsByUserid(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: currentIndex == 0
          ? Consumer<ProductsProvider>(
              builder: (context, options, _) => Drawer(
                    child: Container(
                      color: purpleColor.withOpacity(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Filters'.tr(),
                            style: TextStyle(color: purpleColor, fontSize: 25),
                          ),
                          Valuescheckbox(
                              options.priceCheck, 'Price'.tr(), options),
                          Valuescheckbox(
                              options.nameCheck, 'Name'.tr(), options),
                          Valuescheckbox(options.expirationCheck,
                              'Expiration'.tr(), options),
                          Divider(
                            color: purpleColor,
                          ),
                          Orderscheckbox(
                              options.asc, 'Ascending'.tr(), options),
                          Orderscheckbox(
                              options.des, 'Descending'.tr(), options),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(purpleColor)),
                                onPressed: () {
                                  options.ResetPage();
                                  options.ResetProducts();
                                  options.saveFilters(context);
                                },
                                child: Text(
                                  'Refresh'.tr(),
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                  ))
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddProductScreen()));
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: purpleColor,
      ),
      appBar: currentIndex == 0
          ? AppBar(
              iconTheme: IconThemeData(color: purpleColor),
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen()));
                    },
                    icon: Icon(
                      Icons.search_sharp,
                      color: purpleColor,
                    ))
              ],
              title: Consumer<ProductsProvider>(builder: (context, loader, _) {
                if (loader.isLoadingAppbar) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: purpleColor,
                    ),
                  );
                } else {
                  return const Text('');
                }
              }),
            )
          : myAppbar('Profile', Icons.person_outline_rounded),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17), topRight: Radius.circular(17)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [blueColor, pinkColor],
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade800,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home'.tr(),
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person_pin_rounded),
                label: 'Profile'.tr()),
          ],
        ),
      ),
    );
  }

  Widget Valuescheckbox(bool val, String title, ProductsProvider options) {
    return CheckboxListTile(
      value: val,
      onChanged: (value) {
        options.ValueschangeValue(value, title.tr());
      },
      title: Text(title),
      checkColor: Colors.white,
      activeColor: purpleColor,
    );
  }

  Widget Orderscheckbox(bool val, String title, ProductsProvider options) {
    return CheckboxListTile(
      value: val,
      onChanged: (value) {
        options.OrderChangeValue(value, title.tr());
      },
      title: Text(title),
      checkColor: Colors.white,
      activeColor: purpleColor,
    );
  }
}
