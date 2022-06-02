import 'package:flutter/material.dart';
import 'package:myshop/Providers/register_provider.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RegisterBody(),
    );
  }
}

class RegisterBody extends StatelessWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [blueColor.withAlpha(125), pinkColor.withAlpha(125)],
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: mq.size.width * 0.9,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [blueColor, pinkColor],
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 30),
                      child: Image(
                        image: const AssetImage(
                            'assets/images/online-shopping.png'),
                        width: 60,
                        height: 60,
                        color: purpleColor,
                      ),
                    ),

                    //name field
                    Consumer<RegisterProvider>(
                      builder: (context, register, _) => AnimatedContainer(
                        height: register.authMode == AuthMode.SignIn ? 0 : 65,
                        duration: const Duration(milliseconds: 500),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: register.authMode == AuthMode.SignIn ? 0 : 1,
                          child: register.textfield(
                              'Name',
                              Icons.person_outline_rounded,
                              TextInputType.name,
                              false,
                              register.namecontroller),
                        ),
                      ),
                    ),

                    //email field
                    Consumer<RegisterProvider>(
                      builder: (context, register, _) => register.textfield(
                          'Email',
                          Icons.email_outlined,
                          TextInputType.emailAddress,
                          false,
                          register.emailcontroller),
                    ),

                    //password field

                    Consumer<RegisterProvider>(
                      builder: (context, register, _) => register.textfield(
                          'Password',
                          Icons.lock_outline_rounded,
                          TextInputType.visiblePassword,
                          register.obsecure1,
                          register.passwordcontroller),
                    ),

                    //confirmpassword field
                    Consumer<RegisterProvider>(
                      builder: (context, register, _) => AnimatedContainer(
                        height: register.authMode == AuthMode.SignIn ? 0 : 65,
                        duration: const Duration(milliseconds: 500),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: register.authMode == AuthMode.SignIn ? 0 : 1,
                          child: register.textfield(
                              'Confirm Password',
                              Icons.lock_outline_rounded,
                              TextInputType.visiblePassword,
                              register.obsecure2,
                              register.confirmpasswordcontroller),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Consumer<RegisterProvider>(
                        builder: (context, register, _) => register.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (register.authMode == AuthMode.SignUp) {
                                    register.signUp(context);
                                  } else {
                                    register.signIn(context);
                                  }
                                },
                                style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.all(blueColor),
                                    elevation: MaterialStateProperty.all(5),
                                    shadowColor:
                                        MaterialStateProperty.all(Colors.black),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                child: Text(
                                  register.authMode == AuthMode.SignUp
                                      ? 'Sign up'.tr()
                                      : 'Sign in'.tr(),
                                  style: theme.textTheme.bodyText1,
                                ),
                              ),
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          'or'.tr(),
                          style: const TextStyle(
                              color: Colors.white, fontFamily: font),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                      ],
                    ),
                    Consumer<RegisterProvider>(
                      builder: (context, register, _) => TextButton(
                        onPressed: () {
                          register.setAuthMode(context);
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(blueColor)),
                        child: Text(
                          register.authMode == AuthMode.SignUp
                              ? 'Sign in instead'.tr()
                              : 'Sign up instead'.tr(),
                          style: theme.textTheme.bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Consumer<RegisterProvider>(builder: (context, register, _) {
                      register.setLang();
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            register.buildRow(
                                'English', register.eng, context, false),
                            register.buildRow(
                                'العربية', register.ar, context, false),
                          ]);
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
