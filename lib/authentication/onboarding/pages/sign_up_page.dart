import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth services/auth_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import './sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  bool showPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNoController.dispose();
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
                        controller: _nameController,
                        hintText: 'Name',
                        keyboardType: TextInputType.text,
                        sufficIcon: Icons.person,
                        obscureText: false,
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
                      CustomTextField(
                        maxLength: 10,
                        controller: _phoneNoController,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        sufficIcon: Icons.phone,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Sign Up',
                        onPressed: () {
                          authServices.signUp(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            phoneNo: int.parse(_phoneNoController.text),
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
                        const Text('Already have an account?'),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            // Navigate to login page
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignInPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Log In',
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
