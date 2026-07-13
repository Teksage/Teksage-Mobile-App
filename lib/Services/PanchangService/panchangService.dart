import 'dart:convert';
import 'dart:typed_data';
import 'package:astro_prompt/Model/panchang_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:intl/intl.dart';

class PanchangService {
  /// [date] — optional calendar day (local). Sent as `?date=YYYY-MM-DD` (±365 days on API).
  Future<PanchangModel> getPanchang({DateTime? date}) async {
    var url = ApiEndpoint.panchang;
    if (date != null) {
      final iso = DateFormat('yyyy-MM-dd').format(date);
      url = '$url?date=$iso';
    }

    var response = await APIRequest.getRequest(url);

    if (response.statusCode == 200) {
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
      final response =
          await APIRequest.postRequest(ApiEndpoint.panchangShare, body);
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
