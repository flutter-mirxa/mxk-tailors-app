import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mxk_tailors_app/pages/dashboard.dart';
import 'package:mxk_tailors_app/pages/loginPage.dart';
import 'package:mxk_tailors_app/pages/register.dart';
import 'package:mxk_tailors_app/utils/routes.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCXvKs0XUQW1kS_pKVX2bPLIHTJoyadRi0",
        appId: "1:276526125581:web:75824c703e99dfa2dafb44",
        messagingSenderId: "276526125581",
        projectId: "mxk-tailors-app"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mxk Tailors App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: MyRoutes.loginRoute,
      routes: {
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.dashboardRoute: (context) => const Dashboard(),
        MyRoutes.registerRoute: (context) => const RegisterPage(),
      },
    );
  }
}
