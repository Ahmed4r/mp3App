import 'dart:convert';

import 'package:mp3_app/data/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:mp3_app/data/model/RecitionResponse.dart';
import 'package:mp3_app/data/model/audioReponse.dart';

class Apimanager {
  static String baseUrl = 'api.alquran.cloud';
  static Future<Recitations> getReciter() async {
    try {
      Uri url = Uri.https(baseUrl, Endpoints.Get_Recitations_List,
          {'language': 'ar', 'format': 'audio'});
      // print('urllllllllllll :  $url');

      var response = await http.get(url);
      if (response.statusCode == 200 && response.statusCode < 300) {
        // print(response);
      } else {}
      // print('API Response: ${response.body}');

      return Recitations.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw e;
    }
  }

  static Future<audioResponse> getReciterAudio(String reciterId) async {
    try {
      Uri url = Uri.parse('http://api.alquran.cloud/v1/quran/$reciterId');
      print('Requesting URL: $url');

      var response = await http.get(url);
      print('API Response Status Code: ${response.statusCode}');
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse and return the audioResponse
        return audioResponse.fromJson(jsonDecode(response.body));
      } else {
        // Handle error response
        print('Error fetching data: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load audio data');
      }
    } catch (e) {
      print('Caught error: $e');
      throw e; // Rethrow the error for further handling
    }
  }
}
