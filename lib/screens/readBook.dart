import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/models/bookModel.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class readBook extends StatefulWidget {
  const readBook({super.key, required this.objBook});
  final bookModel objBook;

  @override
  State<readBook> createState() => _readBookState();
}

class _readBookState extends State<readBook> {
  late bookModel objBook;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    objBook = widget.objBook;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          objBook.name,
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? colorWhite
                : colorBlack,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              objBook.content,
              style: TextStyle(
                fontSize: 19,
                color: Provider.of<ThemeProvider>(context).isDarkMode
                    ? colorWhite
                    : colorBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
