// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Models/enterancepage.dart';
import 'package:senior_project/Utils/constants.dart';
import 'package:senior_project/View-Model/providers/router/enterance_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Enterance extends StatefulWidget {
  const Enterance({Key? key}) : super(key: key);

  @override
  State<Enterance> createState() => _EnteranceState();
}

class _EnteranceState extends State<Enterance> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<EnterancePages> data = [
    EnterancePages(
      kprimary,
      'assets/images/enterance1.png',
      "School Management",
    ),
    EnterancePages(
      kprimary,
      'assets/images/enterance2.jpg',
      "Different Online Services for Schools",
    ),
    EnterancePages(
      kprimary,
      'assets/images/enterance3.png',
      "Administration Control",
    ),
  ];
  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    var screenroute = Provider.of<EnteranceRouting>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kwhite,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(
                            color: kbutton,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.4,
                child: PageView(controller: controller, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            color: kprimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40)),
                            image: DecorationImage(
                                image: AssetImage(data[0].image),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(data[0].title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                color: ksecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            color: kprimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40)),
                            image: DecorationImage(
                                image: AssetImage(data[1].image),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(data[1].title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                color: ksecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            color: kprimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40)),
                            image: DecorationImage(
                                image: AssetImage(data[2].image),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(data[2].title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                color: ksecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: kprimary.withOpacity(0.6),
                      activeDotColor: kprimary,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: kprimary.withOpacity(0.6),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                        onPressed: () {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.ease);
                          if (controller.page == 2) {
                            setState(() {
                              Navigator.pushNamed(context, 'login');
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: kwhite,
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
