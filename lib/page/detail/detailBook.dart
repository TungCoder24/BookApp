import 'dart:io';

import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/models/bookModel.dart';
import 'package:bai_test_intern/permission/checkPermission.dart';
import 'package:bai_test_intern/permission/derectoryPath.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:bai_test_intern/screens/comment.dart';
import 'package:bai_test_intern/screens/readBook.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class detailBook extends StatefulWidget {
  const detailBook({super.key, required this.objBook});
  final bookModel objBook;

  @override
  State<detailBook> createState() => _detailBookState();
}

class _detailBookState extends State<detailBook> {
  bool isPermission = false;
  bool downloading = false;

  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));
  late bookModel objBook;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    objBook = widget.objBook;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Provider.of<ThemeProvider>(context).isDarkMode
                  ? colorWhite
                  : colorBlack,
            )),
        title: Text(
          objBook.name,
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? colorWhite
                : colorBlack,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.6,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: objBook.image,
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          cacheManager: customCacheManager,
                          placeholder: (context, url) {
                            return Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 169, 167, 167),
                                highlightColor:
                                    const Color.fromARGB(255, 223, 219, 219),
                                child: Container(
                                  color: Provider.of<ThemeProvider>(context)
                                          .isDarkMode
                                      ? colorWhite
                                      : colorBlack,
                                ));
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.only(bottom: 1),
                                      child: Container(
                                        color: Colors.amber[300],
                                        child: Center(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Comment(
                                                    id: objBook.id,
                                                  );
                                                }));
                                              },
                                              child: Text(
                                                "Bình luận",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      Provider.of<ThemeProvider>(
                                                                  context)
                                                              .isDarkMode
                                                          ? colorWhite
                                                          : colorBlack,
                                                ),
                                              )),
                                        ),
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: Container(
                                      color: Colors.blue[200],
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return readBook(
                                                objBook: widget.objBook,
                                              );
                                            }));
                                          },
                                          child: Text(
                                            "Đọc",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    Provider.of<ThemeProvider>(
                                                                context)
                                                            .isDarkMode
                                                        ? colorWhite
                                                        : colorBlack),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Tác giả: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      objBook.author,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Tóm tắt nội dung: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ReadMoreText(
                  objBook.summary,
                  style: const TextStyle(fontSize: 18),
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Xem thêm',
                  trimExpandedText: '  Ẩn bớt',
                  moreStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  lessStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
