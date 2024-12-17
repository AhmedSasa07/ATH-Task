import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../services/auth_cubit.dart';
import '../services/login_register_cubit.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _validateInputs(BuildContext context, LoginRegisterState state) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email cannot be empty')),
      );
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email address')),
      );
    } else if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password cannot be empty')),
      );
    } else if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
    } else {
      if (state is LoginMode) {
        context.read<LoginRegisterCubit>().signInWithEmailAndPassword(email, password);
      } else {
        context.read<LoginRegisterCubit>().createUserWithEmailAndPassword(email, password);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/SVG/arrow.svg',
            semanticsLabel: 'Go Back',
          ),
          onPressed: () {
            // Dismiss keyboard if it is visible
            FocusScope.of(context).unfocus();

            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
      ),

      body: BlocProvider(
        create: (context) => LoginRegisterCubit(context.read<AuthCubit>()),
        child: BlocConsumer<LoginRegisterCubit, LoginRegisterState>(
          listener: (context, state) {
            if (state is LoginRegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
              _emailController.clear();
              _passwordController.clear();
            } else if (state is LoginRegisterSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },

          builder: (context, state) {
            if (state is LoginRegisterLoading ){
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              );

            }
            return ScrollbarTheme(
              data: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.purple)
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Let's Sing you in.",
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: "CelebMF",
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Welcome back.\nYou've been missed!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Urbanist",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Your email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Password",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 150),
                        SizedBox(
                          width: double.infinity, // Makes the button take full width
                          child: ElevatedButton(
                            onPressed: () {
                              _validateInputs(context, state);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple, // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Consistent border radius
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16), // Adds vertical padding
                            ),
                            child: Text(
                              state is LoginMode ? 'Sign In' : 'Register',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Ensures text is readable
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state is LoginMode
                                ? "Don't have an account?"
                                : "Already have an account?"),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                if (state is LoginMode) {
                                  context.read<LoginRegisterCubit>().toggleMode();
                                } else {
                                  context.read<LoginRegisterCubit>().toggleMode();
                                }
                              },
                              child: Text(
                                state is LoginMode ? 'Register' : 'Login',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  }

