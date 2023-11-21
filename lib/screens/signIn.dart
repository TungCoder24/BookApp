import 'package:bai_test_intern/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwdCtrl = TextEditingController();

  void SignIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameCtrl.text, password: _passwdCtrl.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameCtrl.text = "tung1@gmail.com";
    _passwdCtrl.text = "123123";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpg"),
                    fit: BoxFit.cover)),
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        "WELLCOME BACK!!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: colorBlack,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _usernameCtrl,
                      decoration: InputDecoration(
                          hintText: "Tài khoản",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14)))),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextField(
                      controller: _passwdCtrl,
                      decoration: InputDecoration(
                          hintText: "Mật khẩu",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14)))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorWhite),
                          onPressed: () {
                            SignIn();
                          },
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(color: colorBlack),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
