import 'package:flutter/material.dart';

Color kbutton = const Color.fromARGB(255, 32, 2, 99);
Color ksecondary = const Color.fromARGB(255, 80, 20, 211);
Color kprimary = const Color(0xFF725ffe);
Color darkModeBackground = const Color(0xFF000000);
Color darkModeContainers = const Color(0xFF1e1e1e);
Color kwhite = Colors.white;
Color kblack = Colors.black;
BorderRadius kmaximumCircular = const BorderRadius.all(Radius.circular(40));
BorderRadius finalCircular = const BorderRadius.all(Radius.circular(100));
BorderRadius kcircular = const BorderRadius.all(Radius.circular(15));
BorderRadius kbottomcircular = const BorderRadius.all(Radius.circular(10));
Color kDarkModePrimary = const Color(0xFFBB86FC);
Gradient kmix =
    LinearGradient(colors: [ksecondary.withOpacity(0.7), ksecondary]);
Gradient lightkmix =
    LinearGradient(colors: [ksecondary.withOpacity(0.7), kprimary]);
BoxShadow kwhiteShadow = BoxShadow(
  color: Colors.white.withOpacity(0.8),
  spreadRadius: 10,
  blurRadius: 20,
  offset: const Offset(7, 7), // changes position of shadow
);
BoxShadow kboxshadow1 = BoxShadow(
  blurRadius: 10.0,
  spreadRadius: -10,
  offset: const Offset(0, 0),
  color: Colors.grey.shade700,
);
BoxShadow kboxshadow2 = BoxShadow(
  color: Colors.grey.withOpacity(0.5),
  spreadRadius: 2,
  blurRadius: 7,
);
BoxShadow kboxshadow3 = const BoxShadow(
  blurRadius: 7.0,
  spreadRadius: 2,
  color: Colors.black,
);
BoxShadow kboxshadow4 = const BoxShadow(
  blurRadius: 7.0,
  spreadRadius: 2,
  color: Colors.grey,
);
Gradient kmixWhite =
    LinearGradient(colors: [Colors.white.withOpacity(0.7), kwhite]);
