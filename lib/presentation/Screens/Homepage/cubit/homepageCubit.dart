import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_app/data/Apimanager.dart';
import 'package:mp3_app/data/model/SuwarResponse.dart';
import 'package:mp3_app/data/model/reciterResponse.dart';

import 'package:mp3_app/presentation/Screens/Homepage/cubit/homepageStates.dart';

class Homepagecubit extends Cubit<Homepagestates> {
  Homepagecubit() : super(HomepageInitState());
  //

  List<Reciters> reciters = [];

  void getRecitersData() async {
    try {
      emit(HomepageLoadingState());
      var response = await Apimanager.getReciterData();
      // print(response);
      reciters = response.reciters ?? [];
      emit(HomepageSuccessState(response: response));
    } catch (e) {
      emit(HomepageErrorState(ErrorMessage: e.toString()));
    }
  }
}
