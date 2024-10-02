import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noon/data/Apimanager.dart';
import 'package:noon/data/model/reciterResponse.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageStates.dart';

class Homepagecubit extends Cubit<Homepagestates> {
  Homepagecubit() : super(HomepageInitState());

  List<Reciters> reciters = [];

  void getRecitersData() async {
    try {
      emit(HomepageLoadingState());
      var response = await Apimanager.getReciterData();
      reciters = response.reciters ?? [];
      emit(HomepageSuccessState(response: response));
    } catch (e) {
      emit(HomepageErrorState(ErrorMessage: e.toString()));
    }
  }

  // Add a method to reset the state (used during logout)
  void resetState() {
    emit(HomepageInitState());
  }
}
