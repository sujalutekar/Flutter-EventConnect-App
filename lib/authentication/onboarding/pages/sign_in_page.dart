import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth services/auth_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import './sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);

    return Scaffold(
      body: authServices.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Get Started with EventConnect!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sign up to explore more or log in if you already have an account.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        sufficIcon: Icons.email,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        isPassword: true,
                        obscureText: showPassword,
                        keyboardType: TextInputType.visiblePassword,
                        sufficIcon: showPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        sufficIconOnPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Sign In',
                        onPressed: () async {
                          await authServices.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            // Navigate to signup page
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
