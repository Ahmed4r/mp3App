import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appColors.dart';

import 'package:noon/data/sharedpref/sharedprefUtils.dart';
import 'package:noon/presentation/Screens/AuthScreen/dialogUtils.dart';
import 'package:noon/presentation/Screens/AuthScreen/register.dart';
import 'package:noon/presentation/Screens/Homepage/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';


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
                'assets/القران الكريم (1).png',
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
                            textInputAction: TextInputAction.next,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.sp),
                            decoration: const InputDecoration(
                              hintText: 'Enter Your Email',
                              hintStyle: TextStyle(
                                  color: Color(0xff6F6F6F), fontSize: 20),
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
                            textInputAction: TextInputAction.next,
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
                              hintStyle: const TextStyle(
                                  color: Color(0xff6F6F6F), fontSize: 20),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/divider.png'),
                  
                  Text(
                    'or',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Satoshi'),
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

        // Save user details in shared preferences
        String userToken = await credential.user!.getIdToken() ?? '';
        await saveUserDetails(
            credential.user!.email, credential.user!.uid, userToken);

        Navigator.pushReplacementNamed(context, Homepage.routeName);
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password provided for that user.';
            break;
          default:
            errorMessage = 'An error occurred. Please try again.';
        }
        Dialogutils.showMessage(context: context, content: errorMessage);
      } catch (e) {
        Dialogutils.showMessage(
            context: context,
            content: 'An unexpected error occurred. Please try again.');
      } finally {
        setState(() {
          isLoading = false; 
        });
      }
    }
  }

  Future<void> saveUserDetails(String? email, String? uid, String token) async {
    try {
    
      await Sharedprefutils.saveData(
          key: 'usertoken', value: token); // Use consistent key 'usertoken'
      await Sharedprefutils.saveData(key: 'userEmail', value: email);
      await Sharedprefutils.saveData(key: 'userUid', value: uid);
    } catch (e) {
      // Show error message in the UI or log it
      print('Error saving user details: $e');
      Dialogutils.showMessage(
          context: context,
          content: 'Error saving user details. Please try again.');
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      String? userToken = await userCredential.user!.getIdToken();
      await saveUserDetails(userCredential.user!.email,
          userCredential.user!.uid, userToken ?? '');

      Navigator.pushReplacementNamed(context, Homepage.routeName);
    } catch (error) {
      Dialogutils.showMessage(
          context: context, content: 'Google Sign-In error: $error');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }
}
