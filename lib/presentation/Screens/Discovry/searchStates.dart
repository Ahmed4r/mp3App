import 'package:noon/data/model/reciterResponse.dart';

abstract class Searchstates {}

class SearchInitState extends Searchstates {}

class SearchLoadingState extends Searchstates {}

class SearchSuccessState extends Searchstates {
  final List<Reciters> searchResults; // Store the list of matching reciters

  SearchSuccessState({required this.searchResults});
}

class SearchErrorState extends Searchstates {
  final String errorMessage;

  SearchErrorState({required this.errorMessage});
}
