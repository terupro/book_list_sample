import 'package:book_list_sample/add_book/add_book_page.dart';
import 'package:book_list_sample/book_list/book_list_model.dart';
import 'package:book_list_sample/domain/book.dart';
import 'package:book_list_sample/edit_book/edit_book_page.dart';
import 'package:book_list_sample/login/login_page.dart';
import 'package:book_list_sample/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('本一覧'),
          actions: [
            IconButton(
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser != null) {
                  print('ログインしている');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                } else {
                  print('ログインしてない');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: Center(
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return const CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map(
                  (book) => Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: '編集',
                          onPressed: (_) async {
                            final String? title = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookPage(book),
                              ),
                            );
                            if (title != null) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('$titleを編集しました'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            // 戻ってきたら再読み込み
                            model.fetchBookList();
                          },
                        ),
                        SlidableAction(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '削除',
                          onPressed: (_) async {
                            await showConfirmDialog(
                              context,
                              book,
                              model,
                            );
                          },
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: book.imgURL != null
                          ? Image.network(book.imgURL!)
                          : null,
                      title: Text(book.title),
                      subtitle: Text(book.author),
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddBookPage(),
                ),
              );
              if (added != null && added) {
                const snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('本が追加されました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              // 戻ってきたら再読み込み
              model.fetchBookList();
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

Future showConfirmDialog(BuildContext context, Book book, BookListModel model) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: const Text("削除の確認"),
        content: Text("『${book.title}』を削除しますか？"),
        actions: [
          TextButton(
            child: const Text("いいえ"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("はい"),
            onPressed: () {
              // 削除処理
              model.delete(book);
              Navigator.pop(context);
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text('『${book.title}』を削除しました'),
              );
              model.fetchBookList();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      );
    },
  );
}
