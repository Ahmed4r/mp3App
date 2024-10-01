import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/data/sharedpref/sharedprefUtils.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/register.dart';
import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const String routeName = 'login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController? EmailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool issecured = true;
  bool isLoading = false; // For handling loading state

  bool isSecured() {
    return issecured = !issecured;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ن.png',
                scale: 5,
              ),
              SizedBox(
                height: 10.h,
              ),
              const Text(
                'Sign In',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Satoshi', fontSize: 30),
              ),
              SizedBox(
                height: 25.h,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 360.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff3C3B3B),
                            ),
                            borderRadius: BorderRadius.circular(30.sp)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: TextFormField(
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.sp),
                            decoration: const InputDecoration(
                              hintText: 'Enter Your Email',
                              hintStyle: TextStyle(color: Color(0xff6F6F6F)),
                              border: InputBorder.none,
                            ),
                            controller: EmailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' please Enter Your Email';
                              }

                              final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                              if (!emailValid) {
                                return 'Please Enter a valid Email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: 360.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff3C3B3B),
                            ),
                            borderRadius: BorderRadius.circular(30.sp)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: TextFormField(
                            obscureText: issecured,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.sp),
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    issecured = !issecured;
                                  });
                                },
                                child: Icon(
                                  issecured
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off,
                                ),
                              ),
                              suffixIconColor: Appcolors.secondaryColor,
                              errorMaxLines: 2,
                              hintText: 'Password',
                              hintStyle:
                                  const TextStyle(color: Color(0xff6F6F6F)),
                              border: InputBorder.none,
                            ),
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' please Enter Your Password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at lease 8 character';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  )),
              SizedBox(
                height: 30.h,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                      onTap: () {
                        checkLogin();
                      },
                      child: Container(
                        width: 329.w,
                        height: 92.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.sp),
                            color: Appcolors.ButtonColor),
                        child: const Center(
                          child: Text('Sign In',
                              style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  color: Colors.white,
                                  fontSize: 20)),
                        ),
                      ),
                    ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                children: [
                  Image.asset('assets/divider.png'),
                  SizedBox(
                    width: 49.w,
                  ),
                  Text(
                    'or',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi'),
                  ),
                  SizedBox(
                    width: 49.w,
                  ),
                  Image.asset('assets/divider.png')
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: Image.asset('assets/google.png')),
                  SizedBox(
                    width: 50.w,
                  ),
                  Image.asset('assets/apple.png'),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account ?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Satoshi'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Register.routeName);
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 14, fontFamily: 'Satoshi'),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkLogin() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading
      });
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: EmailController!.text,
                password: passwordController!.text);

        print(credential.user?.uid ?? '');
        String token = await credential.user!.getIdToken() ?? '';

        // Save the token
        await saveToken(token);

        print('User signed in and token saved: $token');
        Navigator.pushReplacementNamed(context, Homepage.routeName);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          print('Error: ${e.message}');
        }
      } catch (e) {
        print('An unexpected error occurred: $e');
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }

  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Sharedprefutils.saveData(key: 'usertoken', value: token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, navigate to Homepage
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, Homepage.routeName);
    } catch (error) {
      print('Google Sign-In error: $error');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }
}
