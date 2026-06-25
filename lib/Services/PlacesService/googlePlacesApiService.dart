import 'dart:convert';
import 'package:astro_prompt/config/googlePlaces.dart';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  static const String placesUrl = 'https://places.googleapis.com/v1/places:autocomplete';
  // static const String locationUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

  Future<List<Map<String, String>>> fetchPlaceSuggestions(String input) async {
    final Uri uri = Uri.parse('$placesUrl?input=$input');
    final response = await http.post(
      uri,
      headers: {
        'X-Goog-Api-Key': googlePlaceApiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List suggestions = data['suggestions'] ?? [];

      return suggestions.where((item) => (item['placePrediction']['types'] as List<dynamic>).contains("geocode")).map((item) {
        final prediction = item['placePrediction'];
        print('placePrediction: $prediction');
        final types = prediction['types'] as List<dynamic>;
        final mainTextLocal = prediction['structuredFormat']['secondaryText']['text'] as String;
        final mainTextCity = prediction['structuredFormat']['mainText']['text'] as String;

        // If types contains sublocality, split by comma and take first part
        final selectedText = types.contains('sublocality') || types.contains('premise') || types.contains('route')
            ? mainTextLocal.split(',').map((e) => e.trim())
            .toList()
            .reversed
            .elementAt(2)
            : mainTextCity;

        return {
          'displayText': prediction['text']['text'] as String,
          'selectedText': selectedText,
        };
      }).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  // static Future<String?> getCountryCode({
  //   required double lat,
  //   required double lng,
  // }) async {
  //   final Uri uri = Uri.parse(
  //     '$locationUrl?latlng=$lat,$lng&key=$googlePlaceApiKey',
  //   );
  //
  //   try {
  //     final response = await http.get(uri);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final results = data['results'] as List<dynamic>;
  //       print('Result: $data');
  //       if (results.isNotEmpty) {
  //         for (final component in results.first['address_components']) {
  //           if ((component['types'] as List).contains('country')) {
  //             return component['short_name']; // 'IN', 'US', etc.
  //           }
  //         }
  //       }
  //     } else {
  //       print('Geocoding API error: ${response.body}');
  //     }
  //   } catch (e) {
  //     print("Geocoding Error: $e");
  //   }
  //   return null;
  // }
}
