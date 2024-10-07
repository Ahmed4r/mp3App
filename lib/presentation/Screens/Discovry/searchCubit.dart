import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noon/data/Apimanager.dart';
import 'package:noon/data/model/reciterResponse.dart';
import 'package:noon/presentation/Screens/Discovry/searchStates.dart';

class SearchCubit extends Cubit<Searchstates> {
  SearchCubit() : super(SearchInitState());

  List<Reciters> searchResults = [];

  void searchMovie({required String search}) async {
    try {
      emit(SearchLoadingState());

      // Get the list of reciters from API by search term (name or ID)
      var response = await Apimanager.searchReciter(search);
      searchResults = response.reciters ?? [];

      if (searchResults.isEmpty) {
        emit(SearchErrorState(errorMessage: 'No reciters found.'));
        return;
      }

      // Filter the reciters based on the search query
      List<Reciters> matchingReciters = searchResults
          .where((reciter) => reciter.name?.contains(search) ?? false)
          .toList();

      if (matchingReciters.isNotEmpty) {
        // Emit success state with the list of matching reciters
        emit(SearchSuccessState(searchResults: matchingReciters));
      } else {
        emit(SearchErrorState(
            errorMessage: 'Reciter not found with that name.'));
      }
    } on SocketException catch (e) {
      emit(SearchErrorState(
          errorMessage: 'SocketException. Seems to be no internet available'));
      // debugPrint('SocketException. Seems to be no internet available');
      // debugPrint(e.toString());
      // debugPrint('OS Errorcode: ${e.osError?.errorCode.toString()}');
    } catch (e) {
      emit(SearchErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> fetchReciterDetailsById(String reciterId) async {
    try {
      var reciterDetails = await Apimanager.searchReciter(reciterId);
      // Handle the reciter details here (e.g., store it, display more info)
      print('Reciter details fetched successfully: $reciterDetails');
    } catch (e) {
      print('Error fetching reciter details: $e');
    }
  }
}
