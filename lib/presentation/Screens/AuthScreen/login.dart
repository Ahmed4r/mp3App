import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp3_app/appTheme.dart';

import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';

class Login extends StatefulWidget {
  static const String routeName = 'login';
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController? EmailController =
      TextEditingController(text: 'ahmedrady03@gmail.com');

  TextEditingController? passwordController =
      TextEditingController(text: '12345678');

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool issecured = true;

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
              SizedBox(
                height: 30.h,
              ),
              Image.asset(
                'assets/ن.png',
                scale: 5,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Sign In',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Satoshi', fontSize: 30),
              ),
              SizedBox(
                height: 40.h,
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
                              color: Color(0xff3C3B3B),
                            ),
                            borderRadius: BorderRadius.circular(30.sp)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: TextFormField(
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.sp),
                            decoration: InputDecoration(
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
                              color: Color(0xff3C3B3B),
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
                              hintStyle: TextStyle(color: Color(0xff6F6F6F)),
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
              InkWell(
                onTap: () {
                  checkLogin();
                },
                child: Container(
                  width: 329.w,
                  height: 92.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.sp),
                      color: Appcolors.ButtonColor),
                  child: Center(
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
                  Image.asset('assets/google.png'),
                  SizedBox(
                    width: 60.w,
                  ),
                  Image.asset('assets/apple.png'),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkLogin() {
    if (formKey.currentState!.validate()) {
      print('form is valid');
      Navigator.pushReplacementNamed(context, Homepage.routeName);
    } else {
      print('form is unvalid');
    }
  }
}
