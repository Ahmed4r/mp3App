import 'package:mp3_app/data/model/RecitionResponse.dart';

class Homepagestates {}

class HomepageInitState extends Homepagestates {}

class HomepageLoadingState extends Homepagestates {}

class HomepageSuccessState extends Homepagestates {
  Recitations response;
  HomepageSuccessState({required this.response});
}

class HomepageErrorState extends Homepagestates {
  String ErrorMessage;
  HomepageErrorState({required this.ErrorMessage});
}
