import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Screens/home_screen.dart';
import 'package:myshop/Screens/register_screen.dart';

import 'package:myshop/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class RegisterProvider with ChangeNotifier {
  bool obsecure1 = true;
  bool obsecure2 = true;
  AuthMode authMode = AuthMode.SignUp;
  String token = '';
  bool isLoading = false;
  bool eng = true;
  bool ar = false;
  var userInfo;
  bool logoutLoading = false;

  Future<void> getUserInfoFromStorage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(userInfo);
    final user = {
      'id': sharedPreferences.getString('id') ?? '',
      'name': sharedPreferences.getString('name') ?? '',
      'email': sharedPreferences.getString('email') ?? ''
    };
    userInfo = user;
    // userInfo['id'] = ;
    // userInfo['name'] =
    // userInfo['email'] = ;
  }

  void setLang() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('lang') != null) {
      if (sharedPreferences.getString('lang') == 'ar') {
        eng = false;
        ar = true;
      } else if (sharedPreferences.getString('lang') == 'en') {
        eng = true;
        ar = false;
      } else {
        eng = true;
        ar = false;
      }
    }
    notifyListeners();
  }

  ///logout

  //Controllers
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  //Return Text Field
  Widget textfield(String label, IconData icon, TextInputType textInputType,
      bool obsecure, TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: TextField(
        cursorWidth: ((label == 'Name' && authMode == AuthMode.SignIn) ||
                (label == 'Confirm Password' && authMode == AuthMode.SignIn))
            ? 0
            : 1,
        controller: textEditingController,
        obscureText: obsecure,
        keyboardType: textInputType,
        maxLines: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: authMode == AuthMode.SignUp
                ? BorderSide(color: purpleColor, width: 1)
                : ((label == 'Name' && authMode == AuthMode.SignIn) ||
                        (label == 'Confirm Password' &&
                            authMode == AuthMode.SignIn))
                    ? BorderSide.none
                    : BorderSide(color: purpleColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: authMode == AuthMode.SignUp
                ? BorderSide(color: purpleColor, width: 1)
                : ((label == 'Name' && authMode == AuthMode.SignIn) ||
                        (label == 'Confirm Password' &&
                            authMode == AuthMode.SignIn))
                    ? BorderSide.none
                    : BorderSide(color: purpleColor, width: 1),
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIcon:
              (label == 'Confirm Password' && authMode == AuthMode.SignIn)
                  ? null
                  : Icon(
                      icon,
                      color: purpleColor,
                    ),
          suffixIcon:
              (label == 'Confirm Password' && authMode == AuthMode.SignIn)
                  ? null
                  : (label.contains('Password') ||
                          label.contains('Confirm Password'))
                      ? IconButton(
                          icon: Icon(obsecure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () {
                            if (label == 'Password') {
                              obsecure1 = !obsecure1;
                            } else {
                              obsecure2 = !obsecure2;
                            }
                            notifyListeners();
                          },
                        )
                      : null,
          label: Text(
            label.tr(),
            style: const TextStyle(color: Colors.grey),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }

  //Change Auth Mode
  void setAuthMode(BuildContext context) {
    isLoading = false;
    authMode = authMode == AuthMode.SignIn ? AuthMode.SignUp : AuthMode.SignIn;
    namecontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();
    confirmpasswordcontroller.clear();
    FocusScope.of(context).unfocus();

    notifyListeners();
  }

  //Sign Up
  void signUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (namecontroller.text.trim().isEmpty) {
      showSnackbar('You have to fill the name', context, Colors.red);
    } else if (emailcontroller.text.trim().isEmpty) {
      showSnackbar('You have to fill the email', context, Colors.red);
    } else if (!emailcontroller.text.trim().contains('@') ||
        !emailcontroller.text.trim().contains('.')) {
      showSnackbar('Invalid email', context, Colors.red);
    } else if (passwordcontroller.text.trim().isEmpty) {
      showSnackbar("You have to fill the Password", context, Colors.red);
    } else if (passwordcontroller.text.trim() !=
        confirmpasswordcontroller.text.trim()) {
      showSnackbar("Passwords doesn't match", context, Colors.red);
    } else if (passwordcontroller.text.trim().length < 6) {
      showSnackbar(
          "Password should be 6 characters or more", context, Colors.red);
    } else {
      try {
        isLoading = true;
        final response =
            await http.post(Uri.parse(hostName + '/register'), body: {
          'name': namecontroller.text.trim(),
          'email': emailcontroller.text.trim(),
          'password': passwordcontroller.text.trim(),
          'password_confirmation': confirmpasswordcontroller.text.trim(),
        }, headers: {
          'Accept': 'application/json',
          'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
        });

        if (response.statusCode == 200) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          final responseMessage = jsonDecode(response.body);
          showSnackbar(
              jsonDecode(response.body)['message'], context, Colors.green);
          sharedPreferences.setString('token', responseMessage['token']);
          token = responseMessage['token'];
          sharedPreferences.setBool('isSigned', true);
          userInfo = responseMessage['data'];
          print(userInfo);
          print(userInfo['id']);
          print(userInfo.entries.elementAt(0).value);
          sharedPreferences.setString('id', userInfo['id'].toString());
          sharedPreferences.setString('name', userInfo['name'].toString());
          sharedPreferences.setString('email', userInfo['email'].toString());
          isLoading = false;
          Provider.of<ProductsProvider>(context, listen: false);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          namecontroller.clear();
          emailcontroller.clear();
          passwordcontroller.clear();
          confirmpasswordcontroller.clear();
        } else {
          isLoading = false;
          final errorJson = jsonDecode(response.body);
          var errors = errorJson['errors'] ?? '';
          if (errors == '') {
            showSnackbar(errorJson['message'], context, Colors.red);
          } else {
            showSnackbar(
                errors.entries.first.value[0].toString(), context, Colors.red);
          }
        }

        //Progress indecator
      } catch (e) {
        isLoading = false;
        showSnackbar(e.toString(), context, Colors.red);
      }
    }
    notifyListeners();
  }

  //Sign In
  void signIn(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (emailcontroller.text.trim().isEmpty) {
      showSnackbar('You have to fill the email', context, Colors.red);
    } else if (passwordcontroller.text.trim().isEmpty) {
      showSnackbar("You have to fill the Password", context, Colors.red);
    } else {
      try {
        isLoading = true;
        final response = await http.post(Uri.parse(hostName + '/login'), body: {
          'email': emailcontroller.text.trim(),
          'password': passwordcontroller.text.trim(),
        }, headers: {
          'Accept': 'application/json',
          'Locale': context.locale == const Locale('en', '') ? 'en' : 'ar'
        });
        if (response.statusCode == 200) {
          final responseMessage = jsonDecode(response.body);
          showSnackbar(responseMessage['message'], context, Colors.green);
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setBool('isSigned', true);
          sharedPreferences.setString('token', responseMessage['token']);
          token = responseMessage['token'];
          userInfo = responseMessage['data'];
          sharedPreferences.setString('id', userInfo['id'].toString());
          sharedPreferences.setString('name', userInfo['name'].toString());
          sharedPreferences.setString('email', userInfo['email'].toString());
          isLoading = false;

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          namecontroller.clear();
          emailcontroller.clear();
          passwordcontroller.clear();
          confirmpasswordcontroller.clear();
        } else {
          isLoading = false;
          final errorJson = jsonDecode(response.body);
          var errors = errorJson['errors'] ?? '';
          if (errors == '') {
            showSnackbar(errorJson['message'], context, Colors.red);
          } else {
            isLoading = false;
            showSnackbar(
                errors.entries.first.value[0].toString(), context, Colors.red);
          }
        }
      } catch (e) {
        isLoading = false;
        showSnackbar(e.toString(), context, Colors.red);
      }
    }

    notifyListeners();
  }

  //Return Snackbar
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

  Widget buildRow(
      String title, bool val, BuildContext context, bool isProfile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              color: isProfile ? purpleColor : Colors.white, fontSize: 15),
        ),
        Checkbox(
            value: val,
            fillColor: isProfile
                ? MaterialStateProperty.all(purpleColor)
                : MaterialStateProperty.all(Colors.white),
            checkColor: isProfile ? Colors.white : purpleColor,
            onChanged: (value) async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();

              if (title == 'English') {
                ar = false;
                eng = true;
                context.setLocale(eng ? Locale('en', '') : Locale('ar', ''));
                sharedPreferences.setString('lang', 'en');
              } else if (title == 'العربية') {
                ar = true;
                eng = false;
                context.setLocale(ar ? Locale('ar', '') : Locale('en', ''));
                sharedPreferences.setString('lang', 'ar');
              }
              notifyListeners();
            })
      ],
    );
  }

  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      logoutLoading = true;
      final response = await http.post(Uri.parse(hostName + '/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        sharedPreferences.setString('id', '');
        sharedPreferences.setString('name', '');
        sharedPreferences.setString('email', '');
        logoutLoading = false;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()));
      } else {
        logoutLoading = false;
        showSnackbar(response.body.toString(), context, Colors.red);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
