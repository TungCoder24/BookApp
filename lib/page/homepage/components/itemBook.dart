import 'dart:io';

import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/models/bookModel.dart';
import 'package:bai_test_intern/page/detail/detailBook.dart';
import 'package:bai_test_intern/permission/checkPermission.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class itemBook extends StatefulWidget {
  const itemBook({super.key, required this.list, required this.index});
  final List<bookModel> list;
  final int index;

  @override
  State<itemBook> createState() => _itemBookState();
}

class _itemBookState extends State<itemBook> {
  final user = FirebaseAuth.instance.currentUser;
  bool isFavourite = false;
  bool isPermission = false;
  var checkAllPermission = checkPermission();

  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));
  void clickFavourite() async {
    if (!isFavourite) {
      await FirebaseFirestore.instance
          .collection("books")
          .doc(widget.list[widget.index].id)
          .update({
        'listFavourite': FieldValue.arrayUnion([user!.uid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection("books")
          .doc(widget.list[widget.index].id)
          .update({
        'listFavourite': FieldValue.arrayRemove([user!.uid])
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFavourite = widget.list[widget.index].listFavourite.contains(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return detailBook(
              objBook: widget.list[widget.index],
            );
          }));
        },
        child: Container(
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.list[widget.index].image,
                key: UniqueKey(),
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                cacheManager: customCacheManager,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 169, 167, 167),
                      highlightColor: const Color.fromARGB(255, 223, 219, 219),
                      child: Container(
                        color: Provider.of<ThemeProvider>(context).isDarkMode
                            ? colorWhite
                            : colorBlack,
                      ));
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                        onPressed: () {
                          clickFavourite();
                          setState(() {
                            isFavourite = !isFavourite;
                          });
                        },
                        icon: Icon(
                          Icons.favorite_outlined,
                          color: isFavourite ? Colors.red : null,
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  height: 60,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        maxLines: 2,
                        widget.list[widget.index].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: NetworkImage(widget.list[widget.index].image),
          //         fit: BoxFit.cover)),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [

          //   ],
          // ),
        ),
      ),
    );
  }
}
