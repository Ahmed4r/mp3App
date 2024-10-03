import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appTheme.dart';
import 'package:noon/data/model/myuser.dart';
import 'package:noon/data/sharedpref/sharedprefUtils.dart';
import 'package:noon/data/userprovider.dart';
import 'package:noon/data/utils/firebaseUtils.dart';
import 'package:noon/presentation/Screens/AuthScreen/dialogUtils.dart';
import 'package:noon/presentation/Screens/AuthScreen/register.dart';
import 'package:noon/presentation/Screens/Homepage/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
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
              // UI Components (Image, Sign In Text, etc.)

              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Email and Password Fields
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
                          // Sign In Button
                          ),
                    ),
              // Additional UI Components (Google Sign-In, Register Navigation)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    EmailController?.dispose();
    passwordController?.dispose();
    super.dispose();
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

        var user = await FirebaseUtils.readuserfromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        // var userprovider = Provider.of<Userprovider>(context, listen: false);
        // userprovider.updateUser(user);

        String userToken = await credential.user!.getIdToken() ?? '';
        await saveUserDetails(
            credential.user!.email, credential.user!.uid, userToken);

        Navigator.pushReplacementNamed(context, Homepage.routeName);
      } on FirebaseAuthException catch (e) {
        handleError(e);
      } catch (e) {
        Dialogutils.showMessage(
            context: context,
            content: 'An unexpected error occurred. Please try again.');
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }

  Future<void> saveUserDetails(String? email, String? uid, String token) async {
    try {
      await Sharedprefutils.saveData(key: 'usertoken', value: token);
      await Sharedprefutils.saveData(key: 'userEmail', value: email);
      await Sharedprefutils.saveData(key: 'userUid', value: uid);
    } catch (e) {
      Dialogutils.showMessage(
          context: context,
          content: 'Error saving user details. Please try again.');
    }
  }

  void handleError(FirebaseAuthException e) {
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
