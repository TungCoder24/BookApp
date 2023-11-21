import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/itemCmt.dart';
import 'package:bai_test_intern/models/commentModel.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Comment extends StatefulWidget {
  const Comment({super.key, required this.id});
  final String id;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final db = FirebaseFirestore.instance;
  final TextEditingController _cmtCtrl = TextEditingController();
  late String id;
  var bookStream;
  void addCmt() async {
    var data = {
      "name": "Nguyen Duc Anh",
      "content": _cmtCtrl.text,
      "time": Timestamp.fromDate(DateTime.now())
    };
    await db
        .collection("books")
        .doc(id)
        .collection("comments")
        .add(data)
        .then((value) {
      print("cmt thanh cong");
    });
    _cmtCtrl.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.id;
    bookStream = FirebaseFirestore.instance
        .collection("books")
        .doc(id)
        .collection("comments")
        .orderBy("time", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          "Bình luận",
          style: TextStyle(
              color: Provider.of<ThemeProvider>(context).isDarkMode
                  ? colorWhite
                  : colorBlack),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
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
                    List<commentModel> list = [];
                    for (var element in snapshot.data.docs) {
                      list.add(commentModel.fromData(element));
                    }
                    return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Commentitem(index: index, list: list);
                        });
                  }
                  return Container();
                }),
          ),
          SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: TextField(
                        controller: _cmtCtrl,
                        decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                            hintText: "Để lại bình luận tại đây",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 16, 12)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: IconButton(
                      onPressed: () {
                        addCmt();
                      },
                      icon: const Icon(Icons.send)),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
