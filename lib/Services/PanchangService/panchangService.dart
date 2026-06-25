import 'dart:convert';
import 'dart:typed_data';
import 'package:astro_prompt/Model/panchang_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class PanchangService {
  Future<PanchangModel> getPanchang() async {
    var response = await APIRequest.getRequest(ApiEndpoint.panchang);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return PanchangModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Panchang');
    }
  }

  Future<Uint8List?> sharePanchangPrediction(int predictionId) async {
    print('id: $predictionId');
    try {
      var body = {
        "prediction_id": predictionId,
      };
      final response = await APIRequest.postRequest(ApiEndpoint.panchangShare, body);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to get Panchang share file');
      }
    } catch (e) {
      print("❌ Error downloading or saving Panchang: $e");
      rethrow;
    }
  }
}
