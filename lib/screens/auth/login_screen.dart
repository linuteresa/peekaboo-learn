// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:learning/provider/auth_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../util/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.isLogin = true});
  final bool isLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SignupData signupData = SignupData();
  // form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("Peekaboo Learn",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                    height: 200,
                    // width: 250,
                    child: Lottie.asset("assets/lottie/login.json")),

                // welcome text
                Text(
                  widget.isLogin ? 'Welcome Back!' : 'Welcome!',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Your Email',
                      label: Text("Email"),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      // validate email
                      if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      signupData.email = value;
                    },
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onChanged: (value) => signupData.email = value,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      label: Text("Password"),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      // length of password should be greater than 6
                      if (value.length < 6) {
                        return 'Password should be greater than 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      signupData.password = value;
                    },
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onChanged: (value) => signupData.password = value,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (!widget.isLogin)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Your Name',
                        label: Text("Your Name"),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        signupData.name = value;
                      },
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      onChanged: (value) => signupData.name = value,
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        final provider =
                            Provider.of<AuthProv>(context, listen: false);
                        _formKey.currentState!.save();
                        showAlertDialog(context);

                        // provider signup
                        if (widget.isLogin) {
                          await provider.login(
                              signupData.email!, signupData.password!);
                        } else {
                          await provider.signup(signupData);
                        }
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, "/");
                      }
                    } catch (e) {
                      // show error message
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 10),
                    child: Text(widget.isLogin ? 'Login' : 'Register',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  isLogin: !widget.isLogin,
                                )));
                  },
                  child: Text(
                      widget.isLogin
                          ? 'Create an account'
                          : 'Already have an account?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
