import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:myshop/Providers/add_product_provider.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';

class SearchProvider with ChangeNotifier {
  bool nameCheck = true;
  bool expirationCheck = false;
  bool categoryCheck = false;
  DateTime selectedDate = DateTime.now();

  void changeValue(val, String checkType) {
    if (checkType == 'Name') {
      nameCheck = val;
      categoryCheck = categoryCheck ? false : categoryCheck;
      expirationCheck = expirationCheck ? false : expirationCheck;
    } else if (checkType == 'Expiration') {
      expirationCheck = val;
      categoryCheck = categoryCheck ? false : categoryCheck;
      nameCheck = nameCheck ? false : nameCheck;
    } else if (checkType == 'Category') {
      categoryCheck = val;
      expirationCheck = expirationCheck ? false : expirationCheck;
      nameCheck = nameCheck ? false : nameCheck;
    }
    notifyListeners();
  }

  List<String> categories = [
    'Clothes',
    'Electronics',
    'Shoes',
    'Food',
    'Other'
  ];
  String Categoryval = 'Other';

  void changeVal(val) {
    Categoryval = val;
    notifyListeners();
  }

  void datePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
              // primaryColorDark: Colors.purple,
              //  accentColor: Colors.purple,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value == null) return;

      selectedDate = value;
      notifyListeners();
    });
  }
}
