
abstract class Registerstates {}

class RegisterInitialgState extends Registerstates {}

class RegisterLoadingState extends Registerstates {}

class RegisterErrorState extends Registerstates {
  String errorMessage;
  RegisterErrorState({required this.errorMessage});
}

class RegisterSuccessState extends Registerstates {
  
 
}
