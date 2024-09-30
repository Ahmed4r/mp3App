import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_app/data/Apimanager.dart';
import 'package:mp3_app/data/model/RecitionResponse.dart';

import 'package:mp3_app/presentation/Screens/Homepage/cubit/homepageStates.dart';

class Homepagecubit extends Cubit<Homepagestates> {
  Homepagecubit() : super(HomepageInitState());

  List<Data> recitersData = [];
  
  
  void getReciterData() async {
    try {
      emit(HomepageLoadingState());
      var response = await Apimanager.getReciter();
      // print(response);
      recitersData = response.data ?? [];
      emit(HomepageSuccessState(response: response));
    } catch (e) {
      emit(HomepageErrorState(ErrorMessage: e.toString()));
    }
  }
  
}
