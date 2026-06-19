import 'dart:convert';
import 'dart:typed_data';
import 'package:astro_prompt/Model/match_making_model.dart';
import 'package:astro_prompt/Model/nakshatram_model.dart';
import 'package:astro_prompt/Model/rasi_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class MatchMakingService {
  Future<List<RasiModel>> getRashiList() async {
    var response = await APIRequest.getRequest(ApiEndpoint.rashi);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      // return (data['data'] as List).map((item) => item['name'] as String).toList();
      return (data['data'] as List).map((item) => RasiModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Rashi list');
    }
  }

  Future<List<NakshatraModel>> getNakshatraList(int rasiId) async {
    var response = await APIRequest.getRequest('${ApiEndpoint.nakshatra}?sign_id=$rasiId');
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      // return (data['data'] as List).map((item) => item['name'] as String).toList();
      return (data['data'] as List).map((item) => NakshatraModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Nakshatra list');
    }
  }

  Future<GetNewMatchMakingModel?> postMatchMaking({
    required String boyName,
    required String girlName,
    required String boyRashi,
    required String boyNakshatra,
    required String girlRashi,
    required String girlNakshatra,
  }) async {
    try {
      final body = {
        "boy_name": boyName,
        "girl_name": girlName,
        "boy_rashi": boyRashi,
        "boy_nakshatra": boyNakshatra,
        "girl_rashi": girlRashi,
        "girl_nakshatra": girlNakshatra,
      };

      var response = await APIRequest.postRequest(ApiEndpoint.matchMaking, body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // return CompatibilityResult.fromJson(data["data"]);
        return GetNewMatchMakingModel.fromJson(data);
      } else {
        if (kDebugMode) {
          print("Error: ${response.reasonPhrase}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception matching: $e");
      }
      return null;
    }
  }

  Future<MatchMakingModel?> getMatchMaking() async {
    try {
      var response = await APIRequest.getRequest(ApiEndpoint.matchMaking);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || data["data"] == null) {
          return null;
        }
        return MatchMakingModel.fromJson(data);
      } else {
        print("Error Get Making: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Exception getMatchMaking: $e");
      return null;
    }
  }

  Future<Uint8List?> shareMatchMakingPrediction(int predictionId) async {
    print('id: $predictionId');
    try {
      var body = {
        "prediction_id": predictionId,
      };
      final response = await APIRequest.postRequest(ApiEndpoint.matchMakingShare, body);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to get Match Making share file');
      }
    } catch (e) {
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }
}
