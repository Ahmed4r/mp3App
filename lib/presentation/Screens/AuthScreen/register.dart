import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noon/appTheme.dart';
import 'package:noon/presentation/Screens/AuthScreen/dialogUtils.dart';
import 'package:noon/presentation/Screens/AuthScreen/login.dart';
import 'package:noon/presentation/Screens/AuthScreen/registerState.dart';
import 'package:noon/presentation/Screens/Homepage/homepage.dart';

class Register extends StatefulWidget {
  static const String routeName = 'register';
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController? nameController = TextEditingController();

  TextEditingController? emailController = TextEditingController();

  TextEditingController? passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool issecured = false;
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Image.asset(
                'assets/ن.png',
                scale: 5,
              ),
              SizedBox(
                height: 10.h,
              ),
              const Text(
                'Register',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Satoshi', fontSize: 30),
              ),
              SizedBox(
                height: 10.h,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 360.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Appcolors.secondaryColor),
                            borderRadius: BorderRadius.circular(30.sp)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter Your Name',
                              hintStyle: TextStyle(color: Color(0xff6F6F6F)),
                              border: InputBorder.none,
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' please Enter Your Name';
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
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter Your Email',
                              hintStyle: TextStyle(color: Color(0xff6F6F6F)),
                              border: InputBorder.none,
                            ),
                            controller: emailController,
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
                            style: const TextStyle(color: Colors.white),
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
                              hintText: 'Enter Your Password',
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
                    ],
                  )),
              SizedBox(
                height: 30.h,
              ),
              InkWell(
                onTap: () {
                  checkRegister();
                },
                child: Container(
                  width: 329.w,
                  height: 92.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.sp),
                      color: const Color(0xff16423C)),
                  child: const Center(
                    child: Text('Create Account',
                        style: TextStyle(
                            fontFamily: 'Satoshi',
                            color: Colors.white,
                            fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Image.asset('assets/divider.png'),
                  SizedBox(
                    width: 110.w,
                  ),
                  Image.asset('assets/divider.png')
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, Homepage.routeName);
                      },
                      child: Image.asset('assets/google.png')),
                  SizedBox(
                    width: 60.w,
                  ),
                  InkWell(onTap: () {}, child: Image.asset('assets/apple.png')),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Do you have an account ?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Satoshi'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Login.routeName);
                      },
                      child: const Text(
                        'Sign in',
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

  void checkRegister() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading state
      });

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController!.text,
          password: passwordController!.text,
        );
        // Clear the input fields
        nameController!.clear();
        emailController!.clear();
        passwordController!.clear();

        // Navigate to Login screen after successful registration
        Navigator.pushReplacementNamed(context, Login.routeName);
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        Dialogutils.showMessage(context: context, content: message);
      } catch (e) {
        print('Error: $e');
        Dialogutils.showMessage(
            context: context, content: 'An unexpected error occurred.');
      } finally {
        setState(() {
          isLoading = false; // Stop loading state
        });
      }
    } else {
      print('Form is invalid');
    }
  }
}
