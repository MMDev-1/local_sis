import 'package:cloud_firestore/cloud_firestore.dart';

class Books {
  String id;
  String name;
  String category;
  String image;
  String language;
  String author;
  String pages;
  String releasedate;
  String description;
  String link;
  Books(this.id, this.name, this.category, this.author, this.description,
      this.image, this.language, this.link, this.pages, this.releasedate);

  Books.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document)
      : id = document.data()!['id'].toString(),
        name = document.data()!['Title'],
        category = document.data()!['Genre'],
        image = document.data()!['Cover-Picture'],
        language = document.data()!['Language'],
        author = document.data()!['Author'],
        pages = document.data()!['Pages'].toString(),
        releasedate = document.data()!['Release-Date'],
        description = document.data()!['Description'],
        link = document.data()!['URL'];

  Books.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['Title'],
        category = json['Genre'],
        image = json['Cover-Picture'],
        language = json['Language'],
        author = json['Author'],
        pages = json['Pages'].toString(),
        releasedate = json['Release-Date'],
        description = json['Description'],
        link = json['URL'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'Title': name,
        'category': category,
        'image': image,
        'language': language,
        'author': author,
        'pages': pages,
        'releasedate': releasedate,
        'description': description,
        'link': link
      };
}
