import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/models/bookModel.dart';
import 'package:bai_test_intern/page/homepage/components/itemBook.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class detailSearch extends StatefulWidget {
  const detailSearch({super.key, required this.title});
  final String title;

  @override
  State<detailSearch> createState() => _detailSearchState();
}

class _detailSearchState extends State<detailSearch> {
  late String title;
  final bookStream = FirebaseFirestore.instance
      .collection("books")
      .orderBy("yearOfManufactor", descending: true)
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      title = widget.title;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Tìm kiếm với: $title',
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? colorWhite
                : colorBlack,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
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
                    .name
                    .toLowerCase()
                    .contains(title.toLowerCase())) {
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
