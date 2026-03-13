import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skillable_frontend/components/password_field.dart';
import 'package:skillable_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillable_frontend/services/skills_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      var skills = await SkillsService().getAll();
      if (skills != null) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController usernameController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceVariant,
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.bolt_rounded,
                            size: 36,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Skillable',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isLogin
                              ? 'Schön, dich wiederzusehen!'
                              : 'Starte deine Lernreise',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Toggle Tab
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: _isLogin
                                    ? Theme.of(context).colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _isLogin
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _isLogin = true),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Anmelden',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: _isLogin
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: !_isLogin
                                    ? Theme.of(context).colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: !_isLogin
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _isLogin = false),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Registrieren',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: !_isLogin
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Benutzername nur bei Register
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: _isLogin
                                  ? const SizedBox.shrink()
                                  : Column(
                                      children: [
                                        TextFormField(
                                          validator: (value) {
                                            if ((value == null ||
                                                    value.isEmpty) &&
                                                _isLogin == false) {
                                              return 'Bitte gib einen Benutzernamen ein';
                                            }
                                            if (value!.length < 3) {
                                              return 'Benutzername muss mindestens 3 Zeichen lang sein';
                                            }
                                            return null;
                                          },
                                          controller: usernameController,
                                          decoration: InputDecoration(
                                            labelText: 'Benutzername',
                                            prefixIcon: const Icon(
                                              Icons.person_outline_rounded,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant
                                                .withOpacity(0.5),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 14,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                      ],
                                    ),
                            ),

                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Bitte gib eine E-Mail ein';
                                }
                                if (!value.contains('@')) {
                                  return 'Bitte gib eine gültige E-Mail ein';
                                }
                                return null;
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'E-Mail',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceVariant.withOpacity(0.5),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            PasswordField(controller: passwordController),
                            const SizedBox(height: 24),

                            FilledButton(
                              onPressed: () async {
                                if (_isLogin) {
                                  try {
                                    if (_formKey.currentState!.validate()) {
                                      var result = await AuthService().login(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );

                                      if (result.token.isNotEmpty) {
                                        var sharedPreferences =
                                            await SharedPreferences.getInstance();
                                        sharedPreferences.setString(
                                          'token',
                                          result.token,
                                        );
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/main',
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "E-Mail oder Passwort ist nicht korrekt",
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                  }
                                } else {
                                  try {
                                    if (_formKey.currentState!.validate()) {
                                      var result = await AuthService().register(
                                        username: usernameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );

                                      if (result.token.isNotEmpty) {
                                        var sharedPreferences =
                                            await SharedPreferences.getInstance();
                                        sharedPreferences.setString(
                                          'token',
                                          result.token,
                                        );
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/main',
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                      msg: "Diese E-Mail existiert bereits!",
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                  }
                                }
                              },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _isLogin ? 'Anmelden' : 'Konto erstellen',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
