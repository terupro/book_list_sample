import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
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

  Future signUp() async {
    this.email = emailController.text;
    this.password = passwordController.text;

    // firebase authでユーザー作成

    // firestoreに追加
    // await FirebaseFirestore.instance.collection('books').doc(book.id).update({
    //   'title': title,
    //   'author': author,
    // });
  }
}
