import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/Providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AddProductProvider with ChangeNotifier {
  XFile? pickedImage;

  double facebookContainerHeight = 0;
  double phoneContainerHeight = 0;
  DateTime selectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  String Categoryval = '';
  List categories = [];
  List categoriesValues = [];

  void changeVal(String value) {
    Categoryval = value;
    notifyListeners();
  }

  void setCategoryValue(String val) {
    Categoryval = val;
  }

  Future<void> getCategories(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response =
          await http.get(Uri.parse(hostName + '/categories'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
      });
      if (response.statusCode == 200) {
        categories = jsonDecode(response.body);
        for (int i = 0; i < categories.length; i++) {
          if (!categoriesValues
              .contains(categories[i].entries.elementAt(1).value.toString())) {
            categoriesValues
                .add(categories[i].entries.elementAt(1).value.toString());
          }
        }
        Categoryval = categoriesValues[0];
      } else {
        print('error (categories)');
      }
    } catch (e) {
      print('categories');
      print(e);
    }
    notifyListeners();
  }

  int getCategoryId(BuildContext context) {
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].entries.elementAt(1).value.toString() ==
          Categoryval.toString()) {
        print('+++++++++++++++++++++++++++++++++++++++++');
        print(categories[i].entries.elementAt(0).value.toInt());
        return categories[i].entries.elementAt(0).value.toInt();
      }
    }
    print('errrrrrrrrrrrrrorrrrr');
    return 1;
  }

  int getCategoryIdforSearch(BuildContext context, String val) {
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].entries.elementAt(1).value.toString() ==
          val.toString()) {
        print('+++++++++++++++++++++++++++++++++++++++++');
        print(categories[i].entries.elementAt(0).value.toInt());
        return categories[i].entries.elementAt(0).value.toInt();
      }
    }
    print('errrrrrrrrrrrrrorrrrr');
    return 1;
  }

  void setfacebookContainerHeight(TextEditingController textEditingController) {
    if (textEditingController.text.trim().isEmpty) {
      facebookContainerHeight = facebookContainerHeight == 0 ? 60 : 0;
    }

    notifyListeners();
  }

  void setphoneContainerHeight(TextEditingController textEditingController) {
    if (textEditingController.text.trim().isEmpty) {
      phoneContainerHeight = phoneContainerHeight == 0 ? 60 : 0;
    }

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

  Widget discountTextField(String hintText, String labelText,
      TextEditingController textEditingController,
      [String? prefixText, String? suffixText]) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: purpleColor),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: purpleColor),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText.tr(),
          labelText: labelText.tr(),
          prefixText: prefixText == null ? '' : prefixText.tr(),
          suffixText: suffixText == null ? '' : suffixText.tr(),
          suffixStyle: TextStyle(
              color: purpleColor,
              fontSize: suffixText.toString().contains('days') ? 15 : 20,
              fontWeight: FontWeight.w500),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixStyle:
              TextStyle(color: purpleColor, fontWeight: FontWeight.w500),
          labelStyle: TextStyle(
              color: purpleColor, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        controller: textEditingController,
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget mytextfield(
      String hint,
      String label,
      TextInputType keyboard,
      IconData? theIcon,
      double borderWidth,
      TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        maxLength: label.contains('Product name') ? 30 : null,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: borderWidth != 0
                  ? BorderSide(width: borderWidth, color: purpleColor)
                  : BorderSide.none,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          border: OutlineInputBorder(
              borderSide: borderWidth != 0
                  ? BorderSide(width: borderWidth, color: purpleColor)
                  : BorderSide.none,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          fillColor: Colors.white,
          filled: true,
          hintText: hint.tr(),
          labelText: label.tr(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
              color: purpleColor, fontSize: 20, fontWeight: FontWeight.w500),
          prefixIcon: Icon(
            theIcon,
            color: purpleColor,
          ),
        ),
        controller: textEditingController,
        keyboardType: keyboard,
        cursorWidth: borderWidth,
      ),
    );
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

  saveProduct(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController phoneController,
      TextEditingController facebookController,
      TextEditingController quantityController,
      TextEditingController day1Controller,
      TextEditingController discount1Controller,
      TextEditingController day2Controller,
      TextEditingController discount2Controller,
      TextEditingController discount3Controller,
      TextEditingController priceController) async {
    try {
      if (nameController.text.trim().isEmpty) {
        showSnackbar('You have to add name', context, Colors.red);
      } else if (pickedImage == null) {
        showSnackbar('You have to add photo', context, Colors.red);
      } else if ((phoneController.text.trim().isEmpty &&
          facebookController.text.trim().isEmpty)) {
        showSnackbar('You have to add contact info', context, Colors.red);
      } else if (quantityController.text.trim().isEmpty) {
        showSnackbar('You have to add quantity', context, Colors.red);
      } else if (priceController.text.trim().isEmpty) {
        showSnackbar('You have to add price', context, Colors.red);
      } else if (day1Controller.text.trim().isEmpty ||
          day2Controller.text.trim().isEmpty) {
        showSnackbar(
            'You have to add all days for discounts', context, Colors.red);
      } else if (discount1Controller.text.trim().isEmpty ||
          discount2Controller.text.trim().isEmpty ||
          discount3Controller.text.trim().isEmpty) {
        showSnackbar('You have to add all discounts', context, Colors.red);
      } else if (double.tryParse(quantityController.text.trim()) == null) {
        showSnackbar('Invalid quantity number', context, Colors.red);
      } else if (int.tryParse(day1Controller.text.trim()) == null ||
          int.tryParse(day2Controller.text.trim()) == null) {
        showSnackbar('Invalid day', context, Colors.red);
      } else if (double.tryParse(discount1Controller.text.trim()) == null ||
          double.tryParse(discount2Controller.text.trim()) == null ||
          double.tryParse(discount3Controller.text.trim()) == null) {
        showSnackbar('Invalid discount', context, Colors.red);
      } else if (double.tryParse(priceController.text.trim()) == null) {
        showSnackbar('Invalid price', context, Colors.red);
      } else if (phoneController.text.trim().isNotEmpty &&
          int.tryParse(phoneController.text.trim()) == null) {
        showSnackbar('Invalid phone number', context, Colors.red);
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        final token = sharedPreferences.getString('token');
        //create multipart request for POST or PATCH method
        var request =
            http.MultipartRequest("POST", Uri.parse(hostName + '/products'));
        request.headers['Accept'] = "application/json";
        request.headers['Authorization'] = "Bearer $token";
        //add text fields
        request.fields["category_id"] = getCategoryId(context).toString();
        request.fields["name"] = nameController.text.trim().toString();
        request.fields["quantity"] = quantityController.text.trim().toString();
        request.fields["original_price"] =
            priceController.text.trim().toString();

        var prices = [
          {
            "days_before_expiration": day1Controller.text.trim().toString(),
            "percentage": discount1Controller.text.trim()
          },
          {
            "days_before_expiration": day2Controller.text.trim().toString(),
            "percentage": discount2Controller.text.trim()
          }
        ];
        String pricesJson = jsonEncode(prices);
        request.fields["discounts"] = pricesJson;
        request.fields["description"] = 'gghgh';
        request.fields["expiry_date"] =
            DateFormat('yyyy-MM-DD').format(selectedDate);
        request.fields["facebook_url"] =
            facebookController.text.trim().toString();
        request.fields["phone_number"] = phoneController.text.trim().toString();
        //create multipart using filepath, string or bytes
        var pic = await http.MultipartFile.fromPath("image", pickedImage!.path);
        //add multipart to request
        request.files.add(pic);
        var response = await request.send();

        //Get the response from the server
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(
            '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&777777777777777777777');
        print(responseString);
        print(response.statusCode);

        pickedImage = null;
        Provider.of<ProductsProvider>(context, listen: false)
            .getproductsByUserid(context);
        showSnackbar('Product added successfully', context, Colors.green);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void editProduct(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController phoneController,
      TextEditingController facebookController,
      TextEditingController quantityController,
      TextEditingController day1Controller,
      TextEditingController discount1Controller,
      TextEditingController day2Controller,
      TextEditingController discount2Controller,
      TextEditingController discount3Controller,
      TextEditingController priceController,
      int productId) async {
    try {
      // phoneController.text.trim().re
      print('editttttttttttttttt');
      if (double.tryParse(quantityController.text.trim()) == null) {
        showSnackbar('Invalid quantity number', context, Colors.red);
      } else if ((day1Controller.text.isNotEmpty &&
              int.tryParse(day1Controller.text.trim()) == null) ||
          (day2Controller.text.isNotEmpty &&
              int.tryParse(day2Controller.text.trim()) == null)) {
        showSnackbar('Invalid day', context, Colors.red);
      } else if ((double.tryParse(discount1Controller.text.trim()) == null &&
              discount1Controller.text.isNotEmpty) ||
          (double.tryParse(discount2Controller.text.trim()) == null &&
              discount2Controller.text.isNotEmpty) ||
          (double.tryParse(discount3Controller.text.trim()) == null &&
              discount3Controller.text.isNotEmpty)) {
        showSnackbar('Invalid discount', context, Colors.red);
      } else if ((double.tryParse(priceController.text.trim()) == null &&
              priceController.text.isNotEmpty) &&
          (int.tryParse(priceController.text.trim()) == null &&
              priceController.text.isNotEmpty)) {
        showSnackbar('Invalid price', context, Colors.red);
      }
      // else if (phoneController.text.trim().isNotEmpty &&
      //     int.tryParse(phoneController.text.trim()) == null) {
      //   showSnackbar('Invalid phone number', context, Colors.red);
      // }
      else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        final token = sharedPreferences.getString('token');
        print(token);

        var request = http.MultipartRequest(
            "POST", Uri.parse(hostName + '/products/$productId?_method=PATCH'));
        request.headers['Accept'] = "application/json";
        request.headers['Authorization'] = "Bearer $token";
        //add text fields
        request.fields["category_id"] = getCategoryId(context).toString();
        request.fields["name"] = nameController.text.trim().toString();
        request.fields["quantity"] = quantityController.text.trim().toString();
        request.fields["original_price"] =
            priceController.text.trim().toString();

        var prices = [
          {
            "days_before_expiration": day1Controller.text.trim().toString(),
            "percentage": discount1Controller.text.trim()
          },
          {
            "days_before_expiration": day2Controller.text.trim().toString(),
            "percentage": discount2Controller.text.trim()
          }
        ];
        String pricesJson = jsonEncode(prices);
        request.fields["discounts"] = pricesJson;
        request.fields["description"] = 'gghgh';
        request.fields["expiry_date"] =
            DateFormat('yyyy-MM-DD').format(selectedDate);
        request.fields["facebook_url"] = facebookController.text.trim();
        request.fields["phone_number"] = phoneController.text.trim();
        //create multipart using filepath, string or bytes
        if (pickedImage != null) {
          var pic =
              await http.MultipartFile.fromPath("image", pickedImage!.path);
          //add multipart to request
          request.files.add(pic);
        }
        var response = await request.send();

        //Get the response from the server
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(responseString);
        print(response.statusCode);
        pickedImage = null;
        Provider.of<ProductsProvider>(context, listen: false)
            .getproductsByUserid(context);
        showSnackbar('Product edited successfully', context, Colors.green);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void pickimage(ImageSource src) async {
    final imagepicker = ImagePicker();
    final image = await imagepicker.pickImage(source: src);

    if (image != null) {
      pickedImage = image;
    }

    notifyListeners();
  }

  showPhotoAlertDialog(BuildContext context, [image_url]) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              content: Container(
                alignment: Alignment.center,
                height: 70,
                child: Column(
                  children: [
                    Text(
                      'Choose prdouct picture from:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            pickimage(ImageSource.camera);
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: Text(
                            'Camera'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(purpleColor)),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            pickimage(ImageSource.gallery);
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(
                            'Gallery'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(purpleColor)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  // Future<void> test() async {

  // }
}
