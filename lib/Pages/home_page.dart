import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Screens/product_details_screen.dart';
import 'package:myshop/Widgets/product_card.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<ProductsProvider>(context, listen: false).ResetPage();
        Provider.of<ProductsProvider>(context, listen: false).ResetProducts();
        await Provider.of<ProductsProvider>(context, listen: false)
            .saveFilters(context);
      },
      child: SafeArea(
        child: Consumer<ProductsProvider>(
          builder: (context, products, _) {
            return products.isError
                ? Center(
                    child: TextButton(
                        onPressed: () {
                          products.setisLoading(true);
                          products.getProducts(context);
                        },
                        child: Text(
                          'Retry'.tr(),
                          style: TextStyle(color: purpleColor, fontSize: 20),
                        )),
                  )
                : (products.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: purpleColor,
                          strokeWidth: 2,
                        ),
                      )
                    : ListView.builder(
                        controller: products.scrollController,
                        itemCount: searchController.text.trim().isNotEmpty
                            ? products.searchResult.length
                            : products.products.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ProductDetailsScreen(
                                        products.products[index])));
                                products.viewIncreament(
                                    products.products[index]['id'],
                                    context,
                                    false);
                              },
                              child: ProductCard(
                                  products.products[index]['image_url'],
                                  products.products[index]['name'],
                                  products.products[index]['views'],
                                  products.products[index]['id'],
                                  products.products[index]['is_liked'],
                                  products.products[index]['likes'],
                                  products.products[index]['reviews'] ?? [],
                                  products.products,
                                  false,
                                  false));
                        }));
          },
        ),
      ),
    );
  }
}
