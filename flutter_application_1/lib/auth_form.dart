import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthForm extends StatefulWidget {
  final TextEditingController emailHolder;
  final TextEditingController passwordHolder;
  final Future<void> Function() onSubmit;
  final String buttonText;
  final String errorMessage;

  const AuthForm({
    required this.emailHolder,
    required this.passwordHolder,
    required this.onSubmit,
    required this.buttonText,
    this.errorMessage = '',
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(); // Trigger the submit function if valid
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            controller: widget.emailHolder,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            controller: widget.passwordHolder,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.go("/"); // Navigates back to the initial screen
                },
                child: const Text("Go back"),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: _validateAndSubmit, // Validate before submission
                child: Text(widget.buttonText),
              ),
            ],
          ),
          if (widget.errorMessage.isNotEmpty)
            Text(
              widget.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
