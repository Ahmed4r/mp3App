
class Loginstates {}

class LoginErrorState extends Loginstates {
  String errorMessage;
  LoginErrorState({required this.errorMessage});
}

class LoginInitalState extends Loginstates {}

class LoginSuccessState extends Loginstates {

}

class LoginLoadingState extends Loginstates {}
