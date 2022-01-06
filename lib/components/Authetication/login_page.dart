import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:second_shopp/components/Authetication/registration.dart';
import 'package:second_shopp/model/auth%20service/autheticationService.dart';
import 'package:second_shopp/page_layout.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    Provider.of<User?>(context, listen: false);

    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 45),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            SafeArea(
              child: Column(children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  // color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                onChanged: (val) {
                                  setState(() {
                                    _email = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  // color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                onChanged: (val) {
                                  setState(() {
                                    _password = val;
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: TextButton(
                          onPressed: () {
                            try {
                              print("$_email  , $_password");
                              FocusManager.instance.primaryFocus?.unfocus();

                              // _auth.createUserWithEmailAndPassword(
                              //     email: _email, password: _password);
                            } catch (e) {
                              print("Error: $e");
                            }
                          },
                          child: Text("Forget Password")),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.only(top: 30, left: 3),
                    child: MaterialButton(
                        minWidth: 150,
                        height: 50,
                        onPressed: () async {
                          try {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await context.read<AuthenticationService>().signIn(
                                  email: _email.trim(),
                                  password: _password.trim(),
                                );
                            // await userID = _auth.currentUser;
                            // print("current user ID : $userID");
                            User? userToken = _auth.currentUser;
                            String? userID = userToken?.uid;

                            if (userID != null) {
                              print("userToken = $userID");
                              showSnackBar("Please wait ... ",
                                  Duration(milliseconds: 1200));
                            } else {
                              showSnackBar("Check the creditial and Try again",
                                  Duration(milliseconds: 1200));
                            }
                            ;
                          } catch (e) {
                            print("Error during login : $e");
                          }
                        },
                        // onPressed: () async {
                        //   print("$_email, $_password");
                        //   try {
                        //     await _auth.signInWithEmailAndPassword(
                        //         email: _email, password: _password);

                        // User? userToken = _auth.currentUser;
                        //     String? userID = userToken?.uid;
                        //     print("userToken = $userToken");
                        //     print("userToken passed = ${userToken?.uid}");
                        //     print("userToken = $userID");
                        //     if (userToken?.uid != null) {
                        //       Navigator.of(context).pushReplacement(
                        //           MaterialPageRoute(
                        //               builder: (context) => PageLayout()));
                        //     }
                        //   } catch (e) {
                        //     print("error: $e");
                        //   }
                        // },
                        color: Colors.orange.shade400,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text("Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                            ))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 17),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage()));
                        },
                        child: const Text(
                          "Registration",
                          style: TextStyle(fontSize: 18),
                        )),
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    ));
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
      backgroundColor: Colors.deepOrange.shade400,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Widget inputFile({label, obscureText = false}) {
  return Container(
    child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          // color: Colors.black87,
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    ]),
  );
}
