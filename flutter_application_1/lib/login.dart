import 'package:flutter/material.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'auth_form.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  //holds user inputs for email and password
  TextEditingController emailHolder = TextEditingController();
  TextEditingController passwordHolder = TextEditingController();
  String _errorMessage = "";

  Future<void> _login() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).login(
        email: emailHolder.text,
        password: passwordHolder.text,
        context: context,
      );
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

//UI uses auth_form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: AuthForm(
          emailHolder: emailHolder,
          passwordHolder: passwordHolder,
          onSubmit: _login,
          buttonText: 'Login',
          errorMessage: _errorMessage,
        ),
      ),
    );
  }
}
