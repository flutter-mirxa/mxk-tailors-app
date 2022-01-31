import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mxk_tailors_app/utils/message.dart';
import 'package:mxk_tailors_app/utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";
  bool isAuthentication = false;
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _loginFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/login.png'),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 30.0,
                top: MediaQuery.of(context).size.height * 0.2,
              ),
              child: const Text(
                "Welcome\nback",
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.45,
                  left: 35.0,
                  right: 35.0,
                ),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      const Text(
                        "Mxk Tailors App",
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (val) {
                          _email = val;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter email first!";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          label: const Text(
                            "Email",
                            style: TextStyle(
                              color: Color(0xff4c505b),
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.account_circle,
                            color: Color(0xff4c505b),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (val) {
                          _password = val;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter password first!";
                          } else if (val.length < 6) {
                            return "Password should be atleast 6 characters!";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          label: const Text(
                            "Password",
                            style: TextStyle(
                              color: Color(0xff4c505b),
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xff4c505b),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff4c505b),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: const Color(0xff4c505b),
                            child: IconButton(
                              iconSize: 30.0,
                              onPressed: () async {
                                userAuthentication();
                              },
                              color: Colors.white,
                              icon: isAuthentication
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.registerRoute);
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0,
                                  color: Color(0xff4c505b),
                                ),
                              )),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forget Password",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0,
                                  color: Color(0xff4c505b),
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void userAuthentication() async {
    String msg = "";
    bool isEmailValid = emailRegex.hasMatch(emailController.text.toString());

    if (_loginFormKey.currentState!.validate()) {
      if (isEmailValid) {
        setState(() {
          isAuthentication = true;
        });
        try {
          // UserCredential userCredential =
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          setState(() {
            isAuthentication = false;
          });
          msg = "Successfully logged In";
          showMsgToBottom(context, msg);
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.dashboardRoute, (route) => false);
          return;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            // print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            // print(
            //     'Wrong password provided for that user.');
          }
          msg = "Invalid username or password!";
          setState(() {
            isAuthentication = false;
          });
        }
      } else {
        msg = "Invalid email format!";
      }
      showMsgToBottom(context, msg);
    }
  }
}
