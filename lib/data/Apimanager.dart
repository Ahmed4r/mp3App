import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:noon/data/model/SuwarResponse.dart';
import 'package:noon/data/model/reciterResponse.dart';

class Apimanager {
  static String baseUrl = 'api.alquran.cloud';
  static Future<SuwarResponse> getSuwar() async {
    try {
      Uri url = Uri.parse('https://mp3quran.net/api/v3/suwar');
      // print('urllllllllllll :  $url');

      var response = await http.get(url);
      if (response.statusCode == 200 && response.statusCode < 300) {
        // print(response);
      } else {}
      // print('API Response: ${response.body}');

      return SuwarResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  static Future<reciterResponse> getReciterData() async {
    try {
      Uri url = Uri.parse('https://mp3quran.net/api/v3/reciters');
      // print('Requesting URL: $url');

      var response = await http.get(url);
      // print('API Response Status Code: ${response.statusCode}');
      // print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse and return the audioResponse
        return reciterResponse.fromJson(jsonDecode(response.body));
      } else {
        // Handle error response
        // print('Error fetching data: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load audio data');
      }
    } catch (e) {
      print('Caught error: $e');
      rethrow; // Rethrow the error for further handling
    }
  }
}
