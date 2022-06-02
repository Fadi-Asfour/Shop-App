import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:myshop/Providers/register_provider.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'add_product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List products = [];

  List searchResult = [];
  ScrollController scrollController = ScrollController();
  int page = 1;
  bool isLoading = false;
  bool isError = false;
  bool isLoadingAppbar = false;
  List userProducts = [];
  double appBarHeight = 50;
  bool priceCheck = false;
  bool expirationCheck = false;
  bool nameCheck = false;
  bool des = false;
  bool asc = false;
  String sort = '';
  String dir = '';
  List searchProducts = [];

  void ResetPage() {
    page = 1;
    notifyListeners();
  }

  void ResetProducts() {
    products.clear();
    notifyListeners();
  }

  void ValueschangeValue(val, String checkType) {
    if (checkType == 'Name' || checkType == 'الاسم') {
      nameCheck = val;
      priceCheck = priceCheck ? false : priceCheck;
      expirationCheck = expirationCheck ? false : expirationCheck;
      if (!asc && !des) asc = true;
      if (!nameCheck && !priceCheck && !expirationCheck) {
        asc = false;
        des = false;
      }
    } else if (checkType == 'Expiration' || checkType == 'انتهاء الصلاحية') {
      expirationCheck = val;
      priceCheck = priceCheck ? false : priceCheck;
      nameCheck = nameCheck ? false : nameCheck;
      if (!asc && !des) asc = true;
      if (!nameCheck && !priceCheck && !expirationCheck) {
        asc = false;
        des = false;
      }
    } else if (checkType == 'Price' || checkType == 'السعر') {
      priceCheck = val;
      expirationCheck = expirationCheck ? false : expirationCheck;
      nameCheck = nameCheck ? false : nameCheck;
      if (!asc && !des) asc = true;
      if (!nameCheck && !priceCheck && !expirationCheck) {
        asc = false;
        des = false;
      }
    }
    notifyListeners();
  }

  void OrderChangeValue(val, String checkType) {
    if (checkType == 'Ascending' || checkType == 'تصاعدي') {
      des = false;
      if (priceCheck || nameCheck || expirationCheck) {
        asc = true;
      } else {
        asc = false;
      }
    } else if (checkType == 'Descending' || checkType == 'تنازلي') {
      asc = false;
      if (priceCheck || nameCheck || expirationCheck) {
        des = true;
      } else {
        des = false;
      }
    }

    notifyListeners();
  }

  Future<void> saveFilters(BuildContext context) async {
    try {
      if (priceCheck)
        sort = 'price';
      else if (nameCheck)
        sort = 'name';
      else if (expirationCheck) sort = 'expiry_date';

      if (des)
        dir = 'desc';
      else if (asc) dir = 'asc';
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = await http.get(
          Uri.parse(hostName + '/products?page=$page&sort=$sort&dir=$dir'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
          });
      print(response.body);

      if (response.statusCode == 200) {
        isLoadingAppbar = false;
        final jsonBody = response.body;
        final productsinJson = jsonDecode(jsonBody);

        if (productsinJson['meta']['last_page'] != page) {
          page++;
        }

        for (int i = 0; i < productsinJson['data'].toList().length; i++) {
          products.add(productsinJson['data'][i]);
        }
        print(response.statusCode);

        isLoading = false;
      }
    } catch (e) {
      print('ooooooooooooooooooooooooooooo');
      print(e);
      isLoadingAppbar = false;
      isLoading = false;
      if (page == 1) {
        isError = true;
      }
      showSnackbar('Check your internet connection', context, Colors.orange);
    }

    notifyListeners();
  }

  void setAppbarHeight() {
    appBarHeight = appBarHeight == 50 ? 500 : 50;
    notifyListeners();
  }

  void setSearchResult(List searchList) {
    searchResult = searchList;
    notifyListeners();
  }

  Future<void> setLike(
      bool value, int productId, List productsA, BuildContext context) async {
    print('*****************************');
    print(value);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token') ?? '';
    for (int i = 0; i < productsA.length; i++) {
      if (productsA[i]['id'] == productId) {
        print('found');
        productsA[i]['is_liked'] = value;
        if (value) {
          productsA[i]['likes']++;

          final response = await http.post(
              Uri.parse(hostName + '/products/$productId/like'),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
                'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
              });
          print(response.body);
          if (response.statusCode != 200) {
            print(response.statusCode);
            productsA[i]['likes']--;
          } else {
            print(response.body);
            getproductsByUserid(context);
          }
        } else {
          productsA[i]['likes']--;
          final response = await http.post(
              Uri.parse(hostName + '/products/$productId/dislike'),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
                'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
              });

          if (response.statusCode != 200)
            productsA[i]['likes']++;
          else {
            print(response.body);
            getproductsByUserid(context);
          }
        }
      } else
        print('not found');
    }
    notifyListeners();
  }

  // print('found');
  //         products[i]['is_liked'] = value;
  //         if (value) {
  //           products[i]['likes']++;

  //           if (response.statusCode != 200) {
  //             print(response.statusCode);
  //             products[i]['likes']--;
  //           } else
  //             print(response.body);
  //         } else {
  //           products[i]['likes']--;

  //         }

  checkScrolling(BuildContext context) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        //isLoading = true;
        // setisLoading(true);
        if (page > 1) {
          isLoadingAppbar = true;
        }
        if (expirationCheck || priceCheck || nameCheck) {
          await saveFilters(context);
        } else {
          await getProducts(context);
        }
      }
    });
    notifyListeners();
  }

  void deleteProduct(int productId) {
    for (int i = 0; i < userProducts.length; i++) {
      if (userProducts[i]['id'] == productId) {
        userProducts.removeAt(i);
      }
    }

    for (int i = 0; i < products.length; i++) {
      if (products[i]['id'] == productId) {
        products.removeAt(i);
      }
    }

    notifyListeners();
  }

  void setisLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setisLoadingAppbar(bool value) {
    isLoadingAppbar = value;
    // notifyListeners();
  }

  Future<void> getProducts(BuildContext context) async {
    isError = false;
    if (page > 1) {
      setisLoadingAppbar(true);
      notifyListeners();
    } else {
      isLoading = true;
    }
    await Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        final token = sharedPreferences.getString('token');
        print(isLoading);
        print('getting data');
        final response = await http
            .get(Uri.parse(hostName + '/products?page=$page'), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
        });
        print('*************');
        print(response.body);
        print('*************');
        if (response.statusCode == 200) {
          isLoadingAppbar = false;
          final jsonBody = response.body;
          // print(jsonBody);

          final productsinJson = jsonDecode(jsonBody);

          //print(productsinJson);
          if (page == 1) checkScrolling(context);

          if (productsinJson['meta']['last_page'] != page) {
            page++;
          }

          //print(productsinJson['data']);
          for (int i = 0; i < productsinJson['data'].toList().length; i++) {
            bool isNotFound = true;
            for (int j = 0; j < products.length; j++) {
              if (products[j]['id'] == productsinJson['data'][i]['id']) {
                isNotFound = false;
              }
            }
            if (isNotFound) products.add(productsinJson['data'][i]);
          }
          print('********************************+++++++++++++++++++++++++');
          print(products[0]['image_url']);
          isLoading = false;
        }
      } catch (e) {
        isLoadingAppbar = false;
        isLoading = false;
        print(e);
        if (page == 1) {
          isError = true;
        }
        showSnackbar('Check your internet connection', context, Colors.orange);
      }
    });

    notifyListeners();
  }

  Future<void> getproductsByUserid(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response =
          await http.get(Uri.parse(hostName + '/profile'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
      });
      print('***********');
      print(response.body);
      if (response.statusCode == 200) {
        final jsonBody = response.body;
        final productsinJson = jsonDecode(jsonBody);
        userProducts = productsinJson['data']['products'] ?? [];
      } else {
        print('fail');
      }
    } catch (e) {
      print(e);
    }
  }

  void showSnackbar(String title, BuildContext context, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 5,
        backgroundColor: color,
        content: Text(
          title.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<bool> addComment(TextEditingController commentsController,
      int productId, RegisterProvider user, BuildContext context) async {
    bool flag = false;
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = await http.post(
          Uri.parse(
            hostName + '/products/$productId/reviews',
          ),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
          },
          body: {
            'comment': commentsController.text.trim()
          });
      print(response.body);

      if (response.statusCode == 200) {
        flag = true;
        for (int i = 0; i < products.length; i++) {
          if (products[i]['id'] == productId) {
            List oldcomments = products[i]['reviews'] ?? [];
            oldcomments.add({
              'id': productId,
              'comment': commentsController.text.trim(),
              'created_at': "",
              'updated_at': "",
              "user": {
                "id": '',
                "name": user.userInfo['name'].toString(),
                "email": ''
              }
            });
            products[i]['reviews'] = oldcomments;
          }
        }
        for (int i = 0; i < userProducts.length; i++) {
          if (userProducts[i]['id'] == productId) {
            List oldcomments = userProducts[i]['reviews'] ?? [];
            oldcomments.add({
              'id': productId,
              'comment': commentsController.text.trim(),
              'created_at': "",
              'updated_at': "",
              "user": {
                "id": '',
                "name": user.userInfo['name'].toString(),
                "email": ''
              }
            });
            userProducts[i]['reviews'] = oldcomments;
          }
        }

        ////
        for (int i = 0; i < searchProducts.length; i++) {
          if (searchProducts[i]['id'] == productId) {
            List oldcomments = searchProducts[i]['reviews'] ?? [];
            oldcomments.add({
              'id': productId,
              'comment': commentsController.text.trim(),
              'created_at': "",
              'updated_at': "",
              "user": {
                "id": '',
                "name": user.userInfo['name'].toString(),
                "email": ''
              }
            });
            searchProducts[i]['reviews'] = oldcomments;
          }
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return flag;
  }

  List getReviewsbyId(int productId, bool isProfile, bool isSearch) {
    if (isProfile) {
      for (int i = 0; i < userProducts.length; i++) {
        if (userProducts[i]['id'] == productId)
          return userProducts[i]['reviews'] as List;
      }
    } else if (isSearch) {
      for (int i = 0; i < searchProducts.length; i++) {
        if (searchProducts[i]['id'] == productId)
          return searchProducts[i]['reviews'] as List;
      }
    } else {
      for (int i = 0; i < products.length; i++) {
        if (products[i]['id'] == productId)
          return products[i]['reviews'] as List;
      }
    }
    notifyListeners();
    return [];
  }

  Future<void> viewIncreament(
      int productId, BuildContext context, bool isProfile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final response = await http
        .post(Uri.parse(hostName + '/products/$productId/views'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (isProfile &&
          userProducts
              .where((element) => element['id'] == productId)
              .isNotEmpty) {
        final product =
            userProducts.where((element) => element['id'] == productId).first;
        product['views']++;
      } else {
        if (products
            .where((element) => element['id'] == productId)
            .isNotEmpty) {
          final product =
              products.where((element) => element['id'] == productId).first;

          product['views']++;
        }
      }
      if (searchProducts.isNotEmpty &&
          searchProducts
              .where((element) => element['id'] == productId)
              .isNotEmpty) {
        final product =
            searchProducts.where((element) => element['id'] == productId).first;

        product['views']++;
      }
    } else {}
    notifyListeners();
  }

  void reset() {
    products = [];
    searchResult = [];
    ScrollController scrollController = ScrollController();
    page = 1;
    isLoading = false;
    isError = false;
    isLoadingAppbar = false;
    userProducts = [];
    searchProducts = [];
  }

  Future<void> search(
      TextEditingController searchController,
      String categoryVal,
      DateTime selectedDate,
      bool namecheck,
      bool categoryCheck,
      bool expirecheck,
      BuildContext context) async {
    Response response = http.Response('', 200);

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      if (namecheck) {
        print(searchController.text);
        response = await http.get(
            Uri.parse(
                hostName + '/products?name=${searchController.text.trim()}'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
            });
      } else if (categoryCheck) {
        int id = Provider.of<AddProductProvider>(context, listen: false)
            .getCategoryIdforSearch(context, categoryVal);
        print(id);
        response = await http
            .get(Uri.parse(hostName + '/products?category_id=$id'), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
        });
      } else if (expirecheck) {
        var date = DateFormat('yyyy-MM-DD').format(selectedDate);
        print(date);
        response = await http
            .get(Uri.parse(hostName + '/products?expiry_date=$date'), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
        });
      }
      if (response.statusCode == 200) {
        final jsonBody = response.body;
        // print(jsonBody);

        final productsinJson = jsonDecode(jsonBody);

        //print(productsinJson);

        //print(productsinJson['data']);
        searchProducts.clear();
        for (int i = 0; i < productsinJson['data'].toList().length; i++) {
          searchProducts.add(productsinJson['data'][i]);
        }
        print('//////////////////');
        print(searchProducts);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
      print(response.body);
    }
    notifyListeners();
  }
}
