import 'dart:ui';

import 'package:bai_test_intern/models/bookModel.dart';
import 'package:flutter/material.dart';

const themeAppbar = Color.fromRGBO(0, 34, 66, 1.0);
const colorWhite = Color.fromRGBO(255, 255, 255, 1);
const colorBlack = Color.fromRGBO(18, 4, 4, 1);
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);

List<bookModel> listGlobal = [];
