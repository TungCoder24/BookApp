import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/models/bookModel.dart';
import 'package:bai_test_intern/page/detail/detailBook.dart';
import 'package:bai_test_intern/page/homepage/components/itemBook.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:bai_test_intern/screens/addNewBook.dart';
import 'package:bai_test_intern/screens/detailSearch.dart';
import 'package:bai_test_intern/screens/myFavourite.dart';
import 'package:bai_test_intern/screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot> _stream;
  final List<DocumentSnapshot> _documents = [];
  bool isSearch = false;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('books')
        .orderBy("yearOfManufactor", descending: true)
        .limit(6)
        .snapshots();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load thêm dữ liệu khi cuộn đến cuối trang
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    var lastDocument = _documents[_documents.length - 1];
    print(_documents.length);
    var additionalDocuments = await FirebaseFirestore.instance
        .collection('books')
        .orderBy("yearOfManufactor", descending: true)
        .startAfterDocument(lastDocument)
        .limit(6)
        .get();
    setState(() {
      _documents.addAll(additionalDocuments.docs);
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    _documents.clear();
    var additionalDocuments = await FirebaseFirestore.instance
        .collection('books')
        .orderBy("yearOfManufactor", descending: true)
        .limit(6)
        .get();
    setState(() {
      _documents.addAll(additionalDocuments.docs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearch
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                    color: colorWhite, borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  onSubmitted: (String value) {
                    setState(() {
                      _searchCtrl.text = value;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return detailSearch(title: _searchCtrl.text);
                    }));
                  },
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      border: Provider.of<ThemeProvider>(context).isDarkMode
                          ? InputBorder.none
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1)),
                      hintText: "Search",
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 16, 12)),
                ),
              )
            : Text(
                "BookStore",
                style: TextStyle(
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? colorWhite
                        : colorBlack),
              ),
        actions: [
          isSearch
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? colorWhite
                        : colorBlack,
                  ))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                  icon: Icon(
                    Icons.search,
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? colorWhite
                        : colorBlack,
                  )),
          PopupMenuButton(
            offset: const Offset(0, 50),
            iconColor: Provider.of<ThemeProvider>(context).isDarkMode
                ? colorWhite
                : colorBlack,
            initialValue: const Icon(
              Icons.more_vert_rounded,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: const Text("Thêm mới"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AddNewBook();
                    }));
                  }),
              PopupMenuItem(
                child: const Text("Yêu thích"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyFavourite();
                  }));
                },
              ),
              PopupMenuItem(
                child: const Text("Cài đặt"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Setting();
                  }));
                },
              ),
              PopupMenuItem(
                child: const Text("Đăng xuất"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              )
            ],
          )
        ],
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              List<bookModel> list = [];
              if (_documents.isEmpty) {
                _documents.addAll(snapshot.data.docs);
              }
              for (var element in _documents) {
                list.add(bookModel.fromData(element));
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.count(1, index % 2 == 0 ? 1.4 : 1.5);
                    },
                    itemBuilder: (context, index) {
                      return itemBook(
                        index: index,
                        list: list,
                      );
                    },
                    itemCount: list.length),
              );
            }
            return Container();
          }),
    );
  }
}
