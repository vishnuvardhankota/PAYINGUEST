import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinguest/auth/auth_type.dart';
import 'package:payinguest/common/theme_helper.dart';
import 'package:payinguest/widgets/header_widget.dart';
import 'package:payinguest/widgets/loading_view.dart';
import '../main.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String manager = 'Manager';
  String owner = 'Owner';
  bool isLoading = false;
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                  child: HeaderWidget(
                    200,
                  ),
                ),
                SafeArea(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      margin: const EdgeInsets.fromLTRB(
                          20, 0, 20, 10), // This will be the login form
                      child: Column(
                        children: [
                          const Text(
                            'PAYINGUEST',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'SignIn into your Account',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30.0),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.email),
                                        labelText: 'Email',
                                        hintText: 'Enter your Email address',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Please enter your Email";
                                        }
                                        if ((val.isEmpty) &&
                                            RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                .hasMatch(val)) {
                                          return "Enter a valid email address";
                                        }
                                        return null;
                                      },
                                    ),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 5),
                                      )
                                    ]),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Container(
                                    child: TextFormField(
                                      obscureText: obscureText,
                                      controller: passwordController,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Please enter your password";
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: obscureText == true
                                              ? const Icon(Icons.visibility_off)
                                              : const Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                          },
                                        ),
                                        labelText: 'Password',
                                        hintText: 'Enter your password',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade400)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2.0)),
                                      ),
                                    ),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 5),
                                      )
                                    ]),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 20),
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPasswordPage()),
                                        );
                                      },
                                      child: const Text(
                                        "Forgot your password?",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: ThemeHelper()
                                        .buttonBoxDecoration(context),
                                    child: ElevatedButton(
                                      style: ThemeHelper().buttonStyle(),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 10, 40, 10),
                                        child: Text(
                                          'Sign In'.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          try {
                                            UserCredential userCredential =
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                                        email: emailController
                                                            .text,
                                                        password:
                                                            passwordController
                                                                .text);
                                            if (userCredential
                                                .user!.emailVerified) {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MyApp()),
                                                      (route) => false);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Please Verify Email'),
                                                backgroundColor: Colors.orange,
                                              ));
                                              setState(() {
                                                isLoading = false;
                                              });
                                              return;
                                            }
                                          } on PlatformException catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(e.code),
                                              backgroundColor: Colors.orange,
                                            ));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            return;
                                          } on FirebaseAuthException catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(e.code),
                                              backgroundColor:
                                                  Theme.of(context).errorColor,
                                            ));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            return;
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                          return;
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 20),
                                    child: Text.rich(TextSpan(children: [
                                      const TextSpan(
                                          text: "Don't have an account? "),
                                      TextSpan(
                                        text: 'Create Account',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AuthType()));
                                          },
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                    ])),
                                  ),
                                ],
                              )),
                        ],
                      )),
                ),
              ],
            ),
          ),
          if (isLoading == true)
            Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: SizedBox(height: 100, child: LoadingView()))),
        ],
      ),
    );
  }
}
