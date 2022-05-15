import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginkModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email;
  String? password;

  void setEmail(String title) {
    this.email = title;
    notifyListeners();
  }

  void setPassword(String author) {
    this.password = author;
    notifyListeners();
  }

  Future login() async {
    this.email = emailController.text;
    this.password = passwordController.text;

    // ログイン
  }
}
