import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noon/data/Apimanager.dart';
import 'package:noon/data/model/reciterResponse.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageStates.dart';

class Homepagecubit extends Cubit<Homepagestates> {
  bool isLoading = false;

  Homepagecubit() : super(HomepageInitState());

  List<Reciters> reciters = [];

  void getRecitersData() async {
    if (isLoading || isClosed)
      return; // Prevent multiple calls and emit after close
    try {
      isLoading = true;
      emit(HomepageLoadingState());

      var response = await Apimanager.getReciterData();
      reciters = response.reciters ?? [];
      if (!isClosed) emit(HomepageSuccessState(response: response));
    } catch (e) {
      if (!isClosed) emit(HomepageErrorState(ErrorMessage: e.toString()));
    } finally {
      isLoading = false;
    }
  }

  // Add a method to reset the state (used during logout)
  void resetState() {
    emit(HomepageInitState());
  }

  @override
  Future<void> close() {
    // Clean up resources, if any
    return super.close();
  }
}
