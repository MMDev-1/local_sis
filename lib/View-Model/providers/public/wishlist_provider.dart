import 'package:senior_project/Models/books.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishListProvider with ChangeNotifier {
  final String key = 'Books';
  SharedPreferences? _preferences;
  int index = 0;

  List<Books> books = [];
  List<Books> prefsBooks = [];
  void addBook(Books book) {
    books.add(book);
    notifyListeners();
  }

  void removeBook(Books book) {
    books.remove(book);
    notifyListeners();
  }

  addBookstoPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('category $index', books[index].category.toString());
  }

  get getTotalBooks => books.length;
}
