import 'package:flutter/material.dart';
import 'package:whatsapp/pages/loginpage.dart';
import 'package:whatsapp/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State <LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially show the login screen
   bool showLogInPage=true;

   //toggle between login and register page
   void togglePages() {
    setState(() {
      showLogInPage=!showLogInPage;
    });
   }
  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}