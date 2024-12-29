import 'package:flutter/material.dart';
import 'auth_form.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  CreateScreenState createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  TextEditingController emailHolder = TextEditingController();
  TextEditingController passwordHolder = TextEditingController();
  TextEditingController usernameHolder = TextEditingController();
  String _errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<UserProvider>(context, listen: false).createAccount(
          email: emailHolder.text,
          password: passwordHolder.text,
          username: usernameHolder.text,
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
  }

//UI uses auth_form except for username which needs to be added seperately
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: usernameHolder,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  AuthForm(
                    emailHolder: emailHolder,
                    passwordHolder: passwordHolder,
                    onSubmit: _createAccount,
                    buttonText: 'Create account',
                    errorMessage: _errorMessage,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
