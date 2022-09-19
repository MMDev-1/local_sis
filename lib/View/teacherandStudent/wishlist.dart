import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/books.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View-Model/providers/public/wishlist_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  void initState() {
    super.initState();
  }

  Books? allBooks;
  loadBooks() async {
    
  }
  @override
  Widget build(BuildContext context) {
    context.watch<WishListProvider>();
    var _apptheme = Provider.of<ThemeProvide>(context);
    var wishesProvider = context.read<WishListProvider>();
    return SafeArea(
      child: GestureDetector(
        onTap: () {},
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : darkModeBackground,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_sharp,
                    size: 30, color: _apptheme.getAppTheme.bodyLarge.color),
              ),
            ),
            backgroundColor: _apptheme.getAppTheme == AppTheme.lightMode
                ? Theme.of(context).scaffoldBackgroundColor
                : darkModeBackground,
            body: wishesProvider.getTotalBooks == 0
                ? Center(
                    child: Text(
                      'No Books Found!',
                      style: _apptheme.getAppTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: wishesProvider.getTotalBooks,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 12, right: 12),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            boxShadow:
                                _apptheme.getAppTheme == AppTheme.lightMode
                                    ? [kboxshadow2]
                                    : [const BoxShadow()],
                            borderRadius: kcircular,
                            color: _apptheme.getAppTheme == AppTheme.lightMode
                                ? Theme.of(context).scaffoldBackgroundColor
                                : darkModeContainers,
                          ),
                          height: 130,
                          width: double.infinity,
                          child: Card(
                            color: _apptheme.getAppTheme == AppTheme.lightMode
                                ? Theme.of(context).scaffoldBackgroundColor
                                : darkModeContainers,
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 80,
                                      child: Image.network(
                                        wishesProvider.books[index].image,
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          wishesProvider.books[index].name
                                              .toString(),
                                          style:
                                              _apptheme.getAppTheme.bodyMedium,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            wishesProvider.books[index].category
                                                .toString(),
                                            style: GoogleFonts.roboto(
                                              fontSize: _apptheme.getAppTheme
                                                  .bodyMedium.fontSize,
                                              fontWeight: FontWeight.w700,
                                              color: _apptheme.getAppTheme ==
                                                      AppTheme.lightMode
                                                  ? kblack.withOpacity(0.6)
                                                  : kwhite.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          wishesProvider.removeBook(
                                              wishesProvider.books[index]);
                                        },
                                        icon: Icon(
                                          Icons.delete_outline_outlined,
                                          color: _apptheme.getAppTheme ==
                                                  AppTheme.lightMode
                                              ? kprimary
                                              : kwhite,
                                          size: 30,
                                        )))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
      ),
    );
  }
}
