import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mxk_tailors_app/utils/message.dart';
import 'package:mxk_tailors_app/utils/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email = "";
  String _password = "";
  bool isRegistration = false;
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _registerFormKey = GlobalKey<FormState>();

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
          image: AssetImage('images/register.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 30.0,
                top: 30.0,
              ),
              child: const Text(
                "Create\nAccount",
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
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: 35.0,
                  right: 35.0,
                ),
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (val) {
                          _email = val;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter email first.";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          hintStyle: const TextStyle(color: Colors.black),
                          label: const Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.account_circle,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white),
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
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
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black),
                          hintText: "Enter Password",
                          label: const Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white),
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: const Color(0xff4c505b),
                            child: IconButton(
                              iconSize: 30.0,
                              onPressed: () async {
                                userRegistration();
                              },
                              color: Colors.white,
                              icon: isRegistration
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Color(0xff4c505b),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MyRoutes.loginRoute);
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
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

  void userRegistration() async {
    String msg = "";
    bool isEmailValid = emailRegex.hasMatch(emailController.text.toString());

    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        isRegistration = true;
      });
      if (isEmailValid) {
        try {
          // UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email, password: _password);
          msg = "Successfully Registered";
          showMsgToBottom(context, msg);
          setState(() {
            isRegistration = false;
          });
          // await Future.delayed(
          //     Duration(seconds: 2));
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.dashboardRoute, (route) => false);
          return;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            // print('The password provided is too weak.');
            msg = "Password is too weak";
          } else if (e.code == 'email-already-in-use') {
            msg = "Account already exists";
            // print('The account already exists for that email.');
          }
        } catch (e) {
          // print(e);
        }
      } else {
        msg = "Invalid email format";
      }
      setState(() {
        isRegistration = false;
      });
      showMsgToBottom(context, msg);
    }
  }
}
