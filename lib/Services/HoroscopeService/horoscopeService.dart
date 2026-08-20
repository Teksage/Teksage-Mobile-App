import 'dart:convert';
import 'dart:typed_data';
import 'package:astro_prompt/Model/horoscope_model.dart';
import 'package:astro_prompt/Services/HoroscopeService/fileStorageService.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class HoroscopeService {
  Future<Horoscope> getHoroscope() async {
    var response = await APIRequest.getRequest(ApiEndpoint.horoscope);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Horoscope.fromJson(data);
    } else {
      throw Exception('Failed to load horoscope data');
    }
  }

  Future<List<HoroscopeDivisionalChart>> getHoroscopeCharts() async {
    var response = await APIRequest.getRequest(ApiEndpoint.horoscopeCharts);
    if (response.statusCode != 200) {
      throw Exception('Failed to load horoscope charts');
    }
    final data = jsonDecode(response.body);
    final raw = data is Map ? data['charts'] : null;
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => HoroscopeDivisionalChart.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .where((chart) => chart.html.trim().isNotEmpty)
        .toList();
  }

  Future<Uint8List?> downloadHoroscope() async {
    try {
      final response = await APIRequest.getRequest(ApiEndpoint.horoscopeDownload);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load horoscope data');
      }
    } catch (e) {
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }
}
