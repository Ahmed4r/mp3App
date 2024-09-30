import 'package:mp3_app/data/model/audioReponse.dart';

class Showsurstates {}

class ShowsurInitstates extends Showsurstates {}

class ShowsurLoadingstates extends Showsurstates {}

class ShowsurSucessstates extends Showsurstates {
  audioResponse response;
  ShowsurSucessstates({required this.response});
}

class ShowsurErrorstates extends Showsurstates {
  String ErrorMessage;
  ShowsurErrorstates({required this.ErrorMessage});
}
