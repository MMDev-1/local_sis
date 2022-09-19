import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/books.dart';
import 'package:senior_project/Repo/api_library.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/Utils/themes/app_theme.dart';
import 'package:senior_project/View-Model/providers/public/theme_provider.dart';
import 'package:senior_project/View/teacherandStudent/book_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class BooksLibrary extends StatefulWidget {
  const BooksLibrary({Key? key}) : super(key: key);

  @override
  State<BooksLibrary> createState() => _BooksLibraryState();
}

class _BooksLibraryState extends State<BooksLibrary> {
  @override
  void initState() {
    super.initState();
    gettingBooks();
  }

  final TextEditingController searchController = TextEditingController();
  bool isPressed = false;
  LibraryApi service = LibraryApi();
  Future<List<Books>>? allbooks;
  List<Books>? retrievedBooks;
  Future<void> gettingBooks() async {
    allbooks = service.getAllBooks();
    retrievedBooks = await service.getAllBooks();
  }

  bool searching = false;
  @override
  Widget build(BuildContext context) {
    var _apptheme = Provider.of<ThemeProvide>(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            /* Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: AnimSearchBar(
                color: _apptheme.getAppTheme == AppTheme.lightMode
                    ? Colors.grey.shade300
                    : kwhite,
                width: 400,
                rtl: true,
                autoFocus: true,
                textController: searchController,
                onSuffixTap: () {
                  setState(() {
                    searchController.clear();
                  });
                },
              ),
            ),*/
         
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: allbooks,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Books>> snap,
              ) {
                if (snap.hasData) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: retrievedBooks!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          bookCard(_apptheme, index),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        thickness: 2,
                        color: _apptheme.getAppTheme == AppTheme.lightMode
                            ? kblack
                            : kwhite,
                      );
                    },
                  );
                }
                return listShimmer(_apptheme, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Shimmer listShimmer(ThemeProvide _apptheme, BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.7),
      highlightColor: Colors.black.withOpacity(0.04),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              height: 90,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: kcircular,
                          color: kblack,
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: kcircular,
                              color: kblack,
                            ),
                            width: double.infinity,
                            height: 33,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: kcircular,
                                color: kblack,
                              ),
                              width: double.infinity,
                              height: 33,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            );
          }),
    );
  }

  Padding bookCard(ThemeProvide _apptheme, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(5.0),
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _apptheme.getAppTheme == AppTheme.lightMode
              ? Theme.of(context).scaffoldBackgroundColor
              : kblack,
        ),
        child: Card(
          color: _apptheme.getAppTheme == AppTheme.lightMode
              ? Theme.of(context).scaffoldBackgroundColor
              : kblack,
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
                      retrievedBooks![index].image,
                      fit: BoxFit.contain,
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        retrievedBooks![index].name.toString(),
                        style: _apptheme.getAppTheme.bodyMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          retrievedBooks![index].category.toString(),
                          style: GoogleFonts.roboto(
                              fontSize:
                                  _apptheme.getAppTheme.bodyMedium.fontSize,
                              fontWeight: FontWeight.w700,
                              color: _apptheme.getAppTheme == AppTheme.lightMode
                                  ? ksecondary
                                  : kwhite.withOpacity(0.6)),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookPage(
                                        books: Books(
                                      retrievedBooks![index].id,
                                      retrievedBooks![index].name,
                                      retrievedBooks![index].category,
                                      retrievedBooks![index].author,
                                      retrievedBooks![index].description,
                                      retrievedBooks![index].image,
                                      retrievedBooks![index].language,
                                      retrievedBooks![index].link,
                                      retrievedBooks![index].pages,
                                      retrievedBooks![index].releasedate,
                                    ))));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: _apptheme.getAppTheme.bodyLarge.color,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
