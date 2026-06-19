import 'dart:convert';
import 'dart:typed_data';
import 'package:astro_prompt/Model/life_prediction_model.dart';
import 'package:astro_prompt/Model/weekly_prediction_model.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PredictionService {
  static Future<Map<String, dynamic>> getDailyPrediction() async {
    var response = await APIRequest.getRequest(ApiEndpoint.dailyPrediction);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data'];
      return {
        'predictions': [
          {'title': 'Career', 'data': data['career']},
          {'title': 'Relationship', 'data': data['relationship']},
          {'title': 'Wealth', 'data': data['wealth']},
          {'title': 'Health', 'data': data['health']},
        ],
        'thara_bala': data['thara_bala'],
        'chandra_bala': data['chandra_bala'],
        'quote': data['quote'],
        'predictionId': jsonData['prediction_id'],
      };
    } else if (response.statusCode == 401) {
      await AuthService().logout();
      Get.offAllNamed('/home');
      return {};
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<({int predictionId, List<WeeklyPredictionModel> predictions})>
      getWeeklyPredictions() async {
    var response = await APIRequest.getRequest(ApiEndpoint.weeklyPrediction);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final rawData = decoded['data'];
      if (rawData is! Map<String, dynamic>) {
        throw Exception('Invalid data format: ${decoded['data']}');
      }

      final int predictionId = decoded['prediction_id'] ?? -1;
      final predictions = rawData.entries.map((entry) {
        return WeeklyPredictionModel.fromJson(entry.key, entry.value);
      }).toList();

      return (predictionId: predictionId, predictions: predictions);
    } else if (response.statusCode == 401) {
      await AuthService().logout();
      Get.offAllNamed('/home');
      throw Exception('Unauthorized – user logged out');
    } else {
      final data = jsonDecode(response.body);
      print('Error Unauthorised: ${data['detail']}');
      throw Exception('Failed to load predictions');
    }
  }

  Future<YearlyPredictionModel?> getYearlyPrediction() async {
    try {
      var response = await APIRequest.getRequest(
          '${ApiEndpoint.yearlyPrediction}?generate=false');
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null && decodedResponse.containsKey('data')) {
          var data = decodedResponse['data'];
          int? predictionId = decodedResponse['prediction_id'];

          // Check if data is null or not a valid map
          if (data == null || data is! Map<String, dynamic>) {
            if (kDebugMode) {
              print('Yearly prediction data is null or not a valid map: $data');
            }
            return null; // This will trigger the landing page
          }

          return YearlyPredictionModel.fromJson(data,
              predictionId: predictionId);
        } else {
          if (kDebugMode) {
            print('Yearly prediction response missing data key');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('Yearly prediction failed with status: ${response.statusCode}');
        }
        return null; // Return null instead of throwing to show landing page
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getYearlyPrediction: $e');
      }
      return null; // Return null instead of rethrowing to show landing page
    }
  }

  Future<YearlyPredictionModel?> regenerateYearlyPrediction() async {
    try {
      var response = await APIRequest.getRequest(
          '${ApiEndpoint.yearlyPrediction}?generate=true');

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null && decodedResponse.containsKey('data')) {
          var data = decodedResponse['data'];
          int? predictionId = decodedResponse['prediction_id'];

          // Check if data is null or not a valid map
          if (data == null || data is! Map<String, dynamic>) {
            if (kDebugMode) {
              print('Yearly prediction data is null or not a valid map: $data');
            }
            return null;
          }

          return YearlyPredictionModel.fromJson(data,
              predictionId: predictionId);
        } else {
          if (kDebugMode) {
            print('Yearly prediction response missing data key');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print(
              'Yearly prediction regeneration failed with status: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in regenerateYearlyPrediction: $e');
      }
      return null;
    }
  }

  Future<LifePredictionModel?> getLifePrediction() async {
    try {
      var response = await APIRequest.getRequest(
          '${ApiEndpoint.lifePrediction}?generate=false');

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null && decodedResponse.containsKey('data')) {
          var data = decodedResponse['data'];
          int? predictionId = decodedResponse['prediction_id'];

          // Check if data is null or not a valid map
          if (data == null || data is! Map<String, dynamic>) {
            if (kDebugMode) {
              print('Life prediction data is null or not a valid map: $data');
            }
            return null; // This will trigger the landing page
          }

          return LifePredictionModel.fromJson(data, predictionId: predictionId);
        } else {
          if (kDebugMode) {
            print('Life prediction response missing data key');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('Life prediction failed with status: ${response.statusCode}');
        }
        return null; // Return null instead of throwing to show landing page
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getLifePrediction: $e');
      }
      return null; // Return null instead of rethrowing to show landing page
    }
  }

  Future<LifePredictionModel?> regenerateLifePrediction() async {
    try {
      var response = await APIRequest.getRequest(
          '${ApiEndpoint.lifePrediction}?generate=true');

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse != null && decodedResponse.containsKey('data')) {
          var data = decodedResponse['data'];
          int? predictionId = decodedResponse['prediction_id'];

          // Check if data is null or not a valid map
          if (data == null || data is! Map<String, dynamic>) {
            if (kDebugMode) {
              print('Life prediction data is null or not a valid map: $data');
            }
            return null;
          }

          return LifePredictionModel.fromJson(data, predictionId: predictionId);
        } else {
          if (kDebugMode) {
            print('Life prediction response missing data key');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print(
              'Life prediction regeneration failed with status: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in regenerateLifePrediction: $e');
      }
      return null;
    }
  }

  Future<Uint8List?> shareDailyPrediction(int predictionId) async {
    try {
      var body = {
        "prediction_id": predictionId,
      };
      final response =
          await APIRequest.postRequest(ApiEndpoint.dailyShare, body);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to get Daily Prediction share file');
      }
    } catch (e) {
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }

  Future<Uint8List?> shareWeeklyPrediction(int predictionId) async {
    try {
      var body = {
        "prediction_id": predictionId,
      };
      final response =
          await APIRequest.postRequest(ApiEndpoint.weeklyShare, body);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to get Weekly Prediction share file');
      }
    } catch (e) {
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }

  Future<Uint8List?> shareYearlyPrediction(int predictionId) async {
    print('Od: $predictionId');
    try {
      var body = {
        "prediction_id": predictionId,
      };
      final response =
          await APIRequest.postRequest(ApiEndpoint.yearlyShare, body);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Error: ${response.reasonPhrase}');
        throw Exception('Failed to get Yearly Prediction share file');
      }
    } catch (e) {
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }

  Future<Uint8List?> shareLifePrediction(int predictionId) async {
    print('Od: $predictionId');
    try {
      var body = {
        "prediction_id": predictionId,
      };
      final response =
          await APIRequest.postRequest(ApiEndpoint.lifeShare, body);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to get Life Prediction share file');
      }
    } catch (e) {
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }

  Future<Uint8List?> sharePanchangPrediction(int predictionId) async {
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
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }
}
