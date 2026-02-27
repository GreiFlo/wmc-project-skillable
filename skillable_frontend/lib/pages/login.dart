import 'package:flutter/material.dart';
import 'package:skillable_frontend/components/password_field.dart';
import 'package:skillable_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }

}

class _LoginScreen extends State {

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController usernameController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Benutzername',
                border: const OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-Mail',
                border: const OutlineInputBorder(),
              ),
            ),
            PasswordField(controller: passwordController),
            ElevatedButton(
              onPressed: () async {
                var result = await AuthService().register(username: usernameController.text, email: emailController.text, password: passwordController.text);
                if (result.token.isNotEmpty){
                  var sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setString('token', result.token);
                  print(sharedPreferences.getString('token'));
                  Navigator.pushReplacementNamed(context, '/main');
                }
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
