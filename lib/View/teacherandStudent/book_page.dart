import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/books.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/public/wishlist_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class BookPage extends StatefulWidget {
  BookPage({Key? key, required this.books}) : super(key: key);
  Books books;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {

  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    return SafeArea(
      child: Card(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: _apptheme.getAppTheme == AppTheme.lightMode
                      ? kprimary
                      : darkModeBackground),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: _apptheme.getAppTheme == AppTheme.lightMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : darkModeContainers),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_sharp,
                          color: kwhite,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.books.name,
                    style: _apptheme.getAppTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                      height: 150,
                      width: 120,
                      child: Image.network(
                        widget.books.image,
                        fit: BoxFit.contain,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.books.author,
                    style: _apptheme.getAppTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      log(rating.toString());
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 45, right: 20),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.books.pages,
                                style: _apptheme.getAppTheme.bodyMedium,
                              ),
                              Text(
                                'pages',
                                style: _apptheme.getAppTheme.displayMedium,
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.books.language,
                                style: _apptheme.getAppTheme.bodyMedium,
                              ),
                              Text(
                                'Language',
                                style: _apptheme.getAppTheme.displayMedium,
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.books.releasedate,
                                style: _apptheme.getAppTheme.bodyMedium,
                              ),
                              Text(
                                'Release',
                                style: _apptheme.getAppTheme.displayMedium,
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Text(
                      widget.books.description,
                      maxLines: 8,
                      textAlign: TextAlign.center,
                      style: _apptheme.getAppTheme.bodyMedium,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 70,
                    decoration: _apptheme.getAppTheme == AppTheme.lightMode
                        ? BoxDecoration(gradient: kmix, borderRadius: kcircular)
                        : BoxDecoration(color: kblack, borderRadius: kcircular),
                    child: MaterialButton(
                      onPressed: () {
                        context.read<WishListProvider>().addBook(widget.books);
                      },
                      child: Text(
                        'Add To Wishlist',
                        style: _apptheme.getAppTheme.titleLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
