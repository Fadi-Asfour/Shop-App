import 'package:flutter/material.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Providers/register_provider.dart';
import 'package:myshop/Screens/edit_product_screen.dart';
import 'package:myshop/Widgets/appbar.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen(this.productData, {Key? key}) : super(key: key);
  var productData;
  final String cat = 'Category:',
      quant = 'Quantity:',
      price = 'Price:',
      exp = 'Expiration:';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('Details'.tr(), Icons.insert_drive_file_outlined),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productData['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    fontFamily: "YesevaOne",
                    color: purpleColor),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(9),
              child: Image(image: NetworkImage(productData['image_url'])),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: productContainer(
                  productText("${cat.tr()} ${productData['category']}", false),
                  context),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: productContainer(
                  productText(
                      "${exp.tr()} ${productData['expiry_date']}", false),
                  context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                // color: Colors.blueGrey,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: productContainer(
                            productText(
                                "${price.tr()} ${productData['price']} \$",
                                false),
                            context),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: productContainer(
                            productText(
                                "${quant.tr()} ${productData['quantity']}",
                                false),
                            context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: productContainer(
                    Column(
                      children: [
                        productText('Contact info'.tr(), false),
                        if (productData['facebook_url'].toString() != 'null')
                          SizedBox(
                            height: 15,
                          ),
                        if (productData['facebook_url'].toString() != 'null')
                          productText('Facebook account:'.tr(), false),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              await launch(
                                productData['facebook_url'],
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 5,
                                  backgroundColor: Colors.orange,
                                  content: Text(
                                    'Could not open facebook link',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                          child: productText(
                              productData['facebook_url'].toString() == 'null'
                                  ? ''
                                  : productData['facebook_url'].toString(),
                              true),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (productData['phone_number'].toString() != 'null')
                          productText('Phone number: '.tr(), false),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              await launch(
                                'tel://${productData['phone_number'].toString()}',
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 5,
                                  backgroundColor: Colors.orange,
                                  content: Text(
                                    'Could not open this phone number'.tr(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                          child: productText(
                              productData['phone_number'].toString() == 'null'
                                  ? ''
                                  : productData['phone_number'].toString(),
                              true),
                        ),
                      ],
                    ),
                    context)),
            Consumer<RegisterProvider>(
                //id !!!!!
                builder: (context, register, _) {
              if (register.userInfo['id'].toString() !=
                  productData['owner_id'].toString()) {
                return const Text('');
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              elevation: MaterialStateProperty.all(7)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProductScreen(productData)));
                          },
                          label: Text(
                            'Edit'.tr(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          icon: Icon(Icons.mode_edit_outlined),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red[700]),
                              elevation: MaterialStateProperty.all(7)),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) => AlertDialog(
                                      title: Text(
                                        'Are you sure to delete this product ?'
                                            .tr(),
                                        style: TextStyle(color: purpleColor),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text(
                                              'No'.tr(),
                                              style: const TextStyle(
                                                  color: blueColor),
                                            )),
                                        Consumer<ProductsProvider>(
                                          builder: (context, product, _) =>
                                              TextButton(
                                                  onPressed: () async {
                                                    SharedPreferences
                                                        sharedPreferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    String token =
                                                        sharedPreferences
                                                                .getString(
                                                                    'token') ??
                                                            '';

                                                    final response = await http
                                                        .delete(
                                                            Uri.parse(hostName +
                                                                "/products/${productData['id']}"),
                                                            headers: {
                                                          'Accept':
                                                              'application/json',
                                                          'Authorization':
                                                              'Bearer $token'
                                                        });
                                                    if (response.statusCode ==
                                                        200) {
                                                      Navigator.of(ctx).pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      product.deleteProduct(
                                                          productData['id']);
                                                    }
                                                    print(response.body);
                                                  },
                                                  child: Text(
                                                    'Yes'.tr(),
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  )),
                                        )
                                      ],
                                    ));
                          },
                          label: Text(
                            'Delete'.tr(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          icon: Icon(Icons.delete_forever_sharp),
                        ),
                      ),
                    ),
                  ],
                );
              }
            })
          ],
        )),
      ),
    );
  }

  Text productText(String str, bool isUrl) {
    return Text(
      str,
      textAlign: TextAlign.center,
      style: TextStyle(
        decoration: isUrl ? TextDecoration.underline : TextDecoration.none,
        color: isUrl ? blueColor : Colors.white,
        fontWeight: isUrl ? FontWeight.normal : FontWeight.w500,
        fontSize: 20,
      ),
    );
  }

  Widget productContainer(Widget child, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: purpleColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: child),
      ),
    );
  }
}
