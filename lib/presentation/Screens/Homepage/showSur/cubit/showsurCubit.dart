import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noon/data/Apimanager.dart';
import 'package:noon/data/model/SuwarResponse.dart';

import 'package:noon/presentation/Screens/Homepage/showSur/cubit/showsurStates.dart';

class ShowsurCubit extends Cubit<Showsurstates> {
  ShowsurCubit() : super(ShowsurInitstates());

  List<Suwar> suwar = [];

  void getSwarData() async {
    try {
      emit(ShowsurLoadingstates());
      var response = await Apimanager.getSuwar();

      print(response);

      suwar = response.suwar ?? [];
      emit(ShowsurSucessstates(response: response));
    } catch (e) {
      throw e.toString();
      // emit(ShowsurErrorstates(ErrorMessage: e.toString()));
    }
  }
}
