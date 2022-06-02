import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:intl/intl.dart';
import 'package:myshop/Providers/add_product_provider.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Widgets/appbar.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController day1Controller = TextEditingController();
  final TextEditingController day2Controller = TextEditingController();
  final TextEditingController discount1Controller = TextEditingController();
  final TextEditingController discount2Controller = TextEditingController();
  final TextEditingController discount3Controller = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String exp = 'Expiration:'.tr();
    return Scaffold(
      appBar: myAppbar('Add product', Icons.add_shopping_cart_sharp),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Consumer<AddProductProvider>(
            builder: (context, addProduct, _) => Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                addProduct.mytextfield(
                    'Enter product name',
                    'Product name',
                    TextInputType.name,
                    Icons.shopping_bag_outlined,
                    2,
                    nameController),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      color: purpleColor.withOpacity(0.8),
                    ),
                    child: addProduct.pickedImage == null
                        ? IconButton(
                            icon: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 70,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              addProduct.showPhotoAlertDialog(context);
                            },
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              fit: BoxFit.fill,
                              image: FileImage(
                                File(addProduct.pickedImage!.path),
                              ),
                            ),
                          ),
                  ),
                ),
                if (addProduct.pickedImage != null)
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(purpleColor),
                        elevation: MaterialStateProperty.all(7)),
                    onPressed: () {
                      addProduct.showPhotoAlertDialog(context);
                    },
                    child: Text(
                      'Change the photo'.tr(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(7)),
                    onPressed: () {
                      addProduct.datePicker(context);
                    },
                    icon: Icon(
                      Icons.date_range_outlined,
                      color: purpleColor,
                    ),
                    label: Text(
                      '$exp ${DateFormat.yMd().format(addProduct.selectedDate)}',
                      style: TextStyle(
                          color: purpleColor, fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: purpleColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
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
                          builder: (context, cate, child) =>
                              DropdownButton<String>(
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.white,
                            alignment: Alignment.bottomCenter,
                            dropdownColor: purpleColor,
                            onChanged: (value) {
                              addProduct.changeVal(value!);
                            },
                            value: addProduct.Categoryval,
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
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              elevation: MaterialStateProperty.all(7)),
                          onPressed: () {
                            addProduct.setphoneContainerHeight(phoneController);
                          },
                          icon: Icon(
                            Icons.add_circle,
                            color: purpleColor,
                          ),
                          label: Text(
                            'Add phone number'.tr(),
                            style: TextStyle(
                                color: purpleColor,
                                fontWeight: FontWeight.bold),
                          )),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              elevation: MaterialStateProperty.all(7)),
                          onPressed: () {
                            addProduct
                                .setfacebookContainerHeight(facebookController);
                          },
                          icon: Icon(
                            Icons.add_circle,
                            color: purpleColor,
                          ),
                          label: Text(
                            'Add Facebook link'.tr(),
                            style: TextStyle(
                                color: purpleColor,
                                fontWeight: FontWeight.bold),
                          )),
                    ]),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: addProduct.phoneContainerHeight,
                  child: addProduct.mytextfield(
                      'Enter phone number'.tr(),
                      'phone number'.tr(),
                      TextInputType.number,
                      addProduct.phoneContainerHeight == 0 ? null : Icons.phone,
                      addProduct.phoneContainerHeight == 0 ? 0 : 2,
                      phoneController),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: addProduct.facebookContainerHeight,
                  child: addProduct.mytextfield(
                      'Enter link of your facebook profile'.tr(),
                      'Facebook'.tr(),
                      TextInputType.url,
                      addProduct.facebookContainerHeight == 0
                          ? null
                          : Icons.link,
                      addProduct.facebookContainerHeight == 0 ? 0 : 2,
                      facebookController),
                ),
                addProduct.mytextfield(
                    'Enter number of products'.tr(),
                    'Quantity'.tr(),
                    TextInputType.number,
                    Icons.format_list_numbered_rounded,
                    2,
                    quantityController),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [blueColor, pinkColor],
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Price".tr(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: addProduct.mytextfield(
                      'Enter price'.tr(),
                      'Price'.tr(),
                      TextInputType.number,
                      Icons.attach_money,
                      2,
                      priceController),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 60,
                          child: addProduct.discountTextField('Enter day',
                              'Day', day1Controller, 'Before ', 'days'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 60,
                          child: addProduct.discountTextField('Enter discount',
                              'Discount', discount1Controller, null, '%'),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                            height: 60,
                            child: addProduct.discountTextField('Enter day',
                                'Day', day2Controller, 'Before ', 'days')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                            height: 60,
                            child: addProduct.discountTextField(
                                'Enter discount',
                                'Discount',
                                discount2Controller,
                                null,
                                '%')),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: addProduct.discountTextField('Enter discount',
                        'General discount', discount3Controller),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purpleColor),
                      elevation: MaterialStateProperty.all(7)),
                  onPressed: () {
                    addProduct.saveProduct(
                        context,
                        nameController,
                        phoneController,
                        facebookController,
                        quantityController,
                        day1Controller,
                        discount1Controller,
                        day2Controller,
                        discount2Controller,
                        discount3Controller,
                        priceController);
                    // addProduct.getCategoryId(context);
                    // addProduct.saveProduct(
                    //     context,
                    //     nameController,
                    //     phoneController,
                    //     facebookController,
                    //     quantityController,
                    //     day1Controller,
                    //     discount1Controller,
                    //     day2Controller,
                    //     discount2Controller,
                    //     discount3Controller,
                    //     priceController);
                  },
                  child: Text(
                    'Save'.tr(),
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
