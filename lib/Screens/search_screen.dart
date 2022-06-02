import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myshop/Providers/add_product_provider.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Providers/search_provider.dart';
import 'package:myshop/Screens/product_details_screen.dart';
import 'package:myshop/Widgets/appbar.dart';
import 'package:myshop/Widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

import '../main.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String exp = 'Expiration:'.tr();
    return Scaffold(
      appBar: myAppbar('Search'.tr(), Icons.search),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<SearchProvider>(
              builder: (context, search, _) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRow('Name', search.nameCheck, search),
                  buildRow('Expiration', search.expirationCheck, search),
                  buildRow('Category', search.categoryCheck, search),
                ],
              ),
            ),
            Consumer<SearchProvider>(builder: (context, search, _) {
              if (search.nameCheck) {
                return Padding(
                  padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
                  child: Consumer<ProductsProvider>(
                    builder: (context, search, _) => TextField(
                      controller: searchController,
                      // onChanged: (value) {
                      //   search.setSearchResult(search.products
                      //       .where((element) =>
                      //           element['title']
                      //               .toString()
                      //               .trim()
                      //               .toLowerCase()
                      //               .contains(
                      //                   value.toString().trim().toLowerCase()) ||
                      //           element['category']
                      //               .toString()
                      //               .trim()
                      //               .toLowerCase()
                      //               .contains(
                      //                   value.toString().trim().toLowerCase()) ||
                      //           element['rating']['count']
                      //               .toString()
                      //               .trim()
                      //               .toLowerCase()
                      //               .contains(
                      //                   value.toString().trim().toLowerCase()))
                      //       .toList());
                      // },
                      //maxLength: label.contains('Product name') ? 20 : null,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: purpleColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: purpleColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: purpleColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Search'.tr(),
                        labelText: 'Search'.tr(),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: purpleColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        prefixIcon: Icon(
                          Icons.search,
                          color: purpleColor,
                        ),
                      ),
                      //controller: textEditingController,
                      keyboardType: TextInputType.text,
                      //cursorWidth: borderWidth,
                    ),
                  ),
                );
              } else if (search.expirationCheck) {
                return Padding(
                  padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          elevation: MaterialStateProperty.all(7)),
                      onPressed: () {
                        search.datePicker(context);
                      },
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: purpleColor,
                      ),
                      label: Text(
                        '$exp ${DateFormat.yMd().format(search.selectedDate)}',
                        style: TextStyle(
                            color: purpleColor, fontWeight: FontWeight.bold),
                      )),
                );
              } else if (search.categoryCheck) {
                return Padding(
                  padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: purpleColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Category'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontFamily: '',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Consumer<AddProductProvider>(
                          builder: (context, cate, _) => DropdownButton<String>(
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.white,
                            alignment: Alignment.bottomCenter,
                            dropdownColor: purpleColor,
                            onChanged: (value) {
                              cate.changeVal(value!);
                            },
                            value: cate.Categoryval,
                            items: cate.categoriesValues.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Text('');
            }),
            Consumer3<SearchProvider, ProductsProvider, AddProductProvider>(
              builder: (context, search, product, addProduct, _) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    product.search(
                        searchController,
                        addProduct.Categoryval,
                        search.selectedDate,
                        search.nameCheck,
                        search.categoryCheck,
                        search.expirationCheck,
                        context);
                  },
                  child: Text('Search'.tr()),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purpleColor)),
                ),
              ),
            ),
            Consumer3<SearchProvider, ProductsProvider, AddProductProvider>(
              builder: (context, search, product, addProduct, _) => ListBody(
                children: product.searchProducts
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
                                product.searchProducts,
                                false,
                                true),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String title, bool val, SearchProvider searchProvider) {
    return Row(
      children: [
        Text(
          title.tr(),
          style: TextStyle(color: purpleColor, fontSize: 15),
        ),
        Checkbox(
            value: val,
            fillColor: MaterialStateProperty.all(purpleColor),
            onChanged: (value) {
              searchProvider.changeValue(value, title);
            })
      ],
    );
  }
}
