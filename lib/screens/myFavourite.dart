import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/models/bookModel.dart';
import 'package:bai_test_intern/page/homepage/components/itemBook.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class MyFavourite extends StatefulWidget {
  const MyFavourite({super.key});

  @override
  State<MyFavourite> createState() => _MyFavouriteState();
}

class _MyFavouriteState extends State<MyFavourite> {
  final user = FirebaseAuth.instance.currentUser;

  final bookStream = FirebaseFirestore.instance
      .collection("books")
      .orderBy("yearOfManufactor", descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sách yêu thích",
          style: TextStyle(
              color: Provider.of<ThemeProvider>(context).isDarkMode
                  ? colorWhite
                  : colorBlack),
        ),
      ),
      body: StreamBuilder(
          stream: bookStream,
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
              for (var element in snapshot.data!.docs) {
                if (bookModel
                    .fromData(element)
                    .listFavourite
                    .contains(user!.uid)) {
                  list.add(bookModel.fromData(element));
                }
              }
              return StaggeredGridView.countBuilder(
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
                  itemCount: list.length);
            }
            return Container();
          }),
    );
  }
}
