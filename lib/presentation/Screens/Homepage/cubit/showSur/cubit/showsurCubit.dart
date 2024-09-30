
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_app/data/Apimanager.dart';
import 'package:mp3_app/data/model/audioReponse.dart';


import 'package:mp3_app/presentation/Screens/Homepage/cubit/showSur/cubit/showsurStates.dart';

class ShowsurCubit extends Cubit<Showsurstates> {
  ShowsurCubit() : super(ShowsurInitstates());

  List<Surahs> AduioData = [];

  void getAudioData(String reciterId) async {
    try {
      emit(ShowsurLoadingstates());
      var response = await Apimanager.getReciterAudio(reciterId);
      if (response.code == 200 && response.code! < 300) {
        print(response);
        AduioData = response.data!.surahs ?? [];
        emit(ShowsurSucessstates(response: response));
      } else {
        emit(ShowsurErrorstates(
            ErrorMessage: response.status ?? 'error in cubit'));
      }
    } catch (e) {
      emit(ShowsurErrorstates(ErrorMessage: e.toString()));
    }
  }
}
