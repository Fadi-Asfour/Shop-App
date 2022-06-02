import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Providers/products_provider.dart';
import 'package:myshop/Screens/comments_screen.dart';
import 'package:myshop/main.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  ProductCard(
      this.imageUrl,
      this.title,
      this.views,
      this.id,
      this.isLiked,
      this.likesCount,
      this.comments,
      this.products,
      this.isProfile,
      this.isSearch,
      {Key? key})
      : super(key: key);

  String imageUrl;
  String title;
  int id;
  int views;
  int likesCount;
  //List commentsCount;
  bool isLiked;
  List comments;
  bool isProfile;
  List products;
  bool isSearch;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.isLiked);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(width: 1.5, color: purpleColor)),
          elevation: 5,
          shadowColor: purpleColor,
          color: Colors.white70,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  //maxLines: 1,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: purpleColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: SizedBox(
                    height: 250,
                    width: 500,
                    child: Builder(
                      builder: (context) {
                        try {
                          return Image(
                            image: NetworkImage(widget.imageUrl),
                            errorBuilder: (context, error, stackTrace) {
                              return Image(
                                  color: purpleColor.withAlpha(200),
                                  image: const AssetImage(
                                      'assets/images/shopping-cart.png'));
                            },
                          );
                        } catch (e) {
                          return Image(
                              color: purpleColor.withAlpha(200),
                              image: const AssetImage(
                                  'assets/images/shopping-cart.png'));
                        }
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Consumer<ProductsProvider>(
                        builder: (context, product, _) => buildRow(
                            widget.likesCount.toString(),
                            widget.isLiked
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart, () {
                          product.setLike(
                            !widget.isLiked,
                            widget.id,
                            widget.products,
                            context,
                          );
                        }),
                      ),
                    ),
                    Expanded(
                        child: buildRow(widget.views.toString(),
                            Icons.remove_red_eye_outlined, () {})),
                    Expanded(
                      child: buildRow(
                        widget.comments.length.toString(),
                        Icons.comment_outlined,
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                  widget.id,
                                  '',
                                  widget.comments,
                                  widget.isProfile,
                                  widget.isSearch)));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget buildRow(String title, IconData iconData, Function ontap) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: purpleColor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(color: purpleColor),
          ),
        ],
      ),
    );
  }
}
