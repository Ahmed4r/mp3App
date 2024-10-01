import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:noon/data/Apimanager.dart';
import 'package:noon/data/model/reciterResponse.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageStates.dart';

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
