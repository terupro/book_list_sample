import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  List<Book>? books;

  void fetchBookList() async {
    // コレクションの指定
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('books').get();

    // Firebase上のドキュメントの値(フィールド)をBookに変換する
    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      // data = field
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String author = data['author'];
      final String? imgURL = data['imgURL'];
      return Book(id, title, author, imgURL);
    }).toList();

    this.books = books;
    notifyListeners();
  }

  Future delete(Book book) async {
    await FirebaseFirestore.instance.collection('books').doc(book.id).delete();
  }
}
