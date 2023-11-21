import 'package:bai_test_intern/auth_page.dart';
import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/firebase_options.dart';
import 'package:bai_test_intern/page/homepage/homePage.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:bai_test_intern/screens/settings.dart';
import 'package:bai_test_intern/screens/signIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).isDarkMode
          ? darkTheme
          : lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
