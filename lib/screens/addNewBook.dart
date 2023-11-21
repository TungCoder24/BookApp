import 'dart:io';

import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/models/bookModel.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class AddNewBook extends StatefulWidget {
  const AddNewBook({super.key});

  @override
  State<AddNewBook> createState() => _AddNewBookState();
}

class _AddNewBookState extends State<AddNewBook> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _authorCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _summaryCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();
  final storage = firebase_storage.FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  String linkImage = "";
  String urlImageFirebase = "";
  XFile? fileImage;

  Future<void> pickImage() async {
    var url = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (url != null) {
      setState(() {
        fileImage = url;
        linkImage = url.path;
      });
    }
  }

  void pickDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(-3000),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        _dateCtrl.text = '${value!.day}/${value.month}/${value.year}';
      });
    });
  }

  void addBook() async {
    if (linkImage != "") {
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref = storage
          .ref()
          .child("imageBook")
          .child(fileImage!.path.split("/").last);
      uploadTask = ref.putFile(File(fileImage!.path));
      await uploadTask.whenComplete(() {
        print("Upload thanh cong");
      });
      urlImageFirebase = await ref.getDownloadURL();
    }
    var data = {
      "name": _nameCtrl.text,
      "image": urlImageFirebase,
      "content": _contentCtrl.text,
      "author": _authorCtrl.text,
      "summary": _summaryCtrl.text,
      "yearOfManufactor":
          Timestamp.fromDate(DateFormat("dd/MM/yyyy").parse(_dateCtrl.text))
    };
    await db.collection("books").add(data).then((value) {
      print("Them sach thanh cong");
    });
    whenComplete();
  }

  void whenComplete() {
    setState(() {
      _nameCtrl.clear();
      _authorCtrl.clear();
      _dateCtrl.clear();
      _summaryCtrl.clear();
      _contentCtrl.clear();
      linkImage = "";
      urlImageFirebase = "";
      fileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm mới sách"),
        actions: [
          TextButton(
              onPressed: () {
                addBook();
              },
              child: Text(
                "Thêm mới",
                style: TextStyle(
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? colorWhite
                        : colorBlack,
                    fontSize: 16),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(8),
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: size.height * 0.35,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: linkImage == ""
                                ? const Center(
                                    child: Text("Anh bìa"),
                                  )
                                : Image.file(File(fileImage!.path)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: IconButton(
                              onPressed: () {
                                pickImage();
                              },
                              icon: const Icon(Icons.camera_alt)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(8),
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextFormField(
                          controller: _nameCtrl,
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                top: 10,
                              ),
                              hintText: "Tên sách",
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Icon(
                                Icons.abc,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background))),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextFormField(
                        controller: _authorCtrl,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 10),
                            hintText: "Tên tác giả",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.abc,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(8),
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: _dateCtrl,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(right: 10, top: 15),
                            hintText: "Ngày xuất bản",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: GestureDetector(
                              onTap: () {
                                pickDate();
                              },
                              child: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(8),
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextFormField(
                          controller: _summaryCtrl,
                          textInputAction: TextInputAction.next,
                          maxLines: null,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                top: 10,
                              ),
                              hintText: "Nội dung tóm tắt",
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Icon(
                                Icons.abc,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background))),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextFormField(
                        controller: _contentCtrl,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 10),
                            hintText: "Nội dung sách",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.abc,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
