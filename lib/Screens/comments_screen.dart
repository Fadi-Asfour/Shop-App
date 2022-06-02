// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Providers/register_provider.dart';
import 'package:myshop/Widgets/appbar.dart';
import 'package:myshop/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsScreen extends StatefulWidget {
  CommentsScreen(this.productId, this.userInfo, this.comments, this.isProfile,
      this.isSearch,
      {Key? key})
      : super(key: key);

  int productId;
  var userInfo;
  List comments;
  bool isProfile;
  bool isSearch;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: purpleColor),
        title: Text(
          'Comments'.tr(),
          style: TextStyle(color: purpleColor, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<ProductsProvider>(
              builder: (context, product, _) => Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: purpleColor.withAlpha(200),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Text(
                                    product
                                        .getReviewsbyId(
                                            widget.productId,
                                            widget.isProfile,
                                            widget
                                                .isSearch)[index]['user']
                                            ['name']
                                        .toString(),
                                    style: const TextStyle(
                                        color: blueColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    product
                                        .getReviewsbyId(
                                            widget.productId,
                                            widget.isProfile,
                                            widget.isSearch)[index]['comment']
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                      itemCount: product
                          .getReviewsbyId(widget.productId, widget.isProfile,
                              widget.isSearch)
                          .length)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: commentsController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: purpleColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: purpleColor, width: 3),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.comment_rounded,
                    color: purpleColor,
                  ),
                  suffixIcon: Consumer2<ProductsProvider, RegisterProvider>(
                    builder: (context, product, register, _) => IconButton(
                      icon: Icon(
                        Icons.send_outlined,
                        color: purpleColor,
                      ),
                      onPressed: () async {
                        if (await product.addComment(
                            commentsController,
                            widget.productId,
                            register,
                            context)) commentsController.clear();
                      },
                    ),
                  ),
                  label: Text(
                    'Add a comment'.tr(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
