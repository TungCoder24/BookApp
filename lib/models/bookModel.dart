import 'package:cloud_firestore/cloud_firestore.dart';

class bookModel {
  String id;
  String name;
  String image;
  String content;
  Timestamp yearOfManufactor;
  String author;
  String summary;
  List<dynamic> listFavourite;

  bookModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.content,
      required this.author,
      required this.listFavourite,
      required this.summary,
      required this.yearOfManufactor});

  factory bookModel.fromData(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return bookModel(
        id: snapshot.id,
        name: data["name"] ?? "",
        image: data["image"] ?? "",
        content: data["content"] ?? "",
        author: data["author"] ?? "",
        summary: data["summary"] ?? "",
        listFavourite: data["listFavourite"] ?? [],
        yearOfManufactor: data["yearOfManufactor"] ?? "");
  }
}
