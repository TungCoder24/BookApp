import 'package:cloud_firestore/cloud_firestore.dart';

class commentModel {
  String name;
  String content;
  Timestamp time;

  commentModel({required this.name, required this.content, required this.time});

  factory commentModel.fromData(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return commentModel(
        name: data["name"] ?? "",
        content: data["content"] ?? "",
        time: data["time"] ?? "");
  }
}
