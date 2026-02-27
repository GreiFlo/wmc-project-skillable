import 'package:flutter/material.dart';
import 'package:skillable_frontend/components/password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-Mail',
                border: const OutlineInputBorder(),
              ),
            ),
            PasswordField(controller: passwordController),
            ElevatedButton(
              onPressed: () {
                
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
