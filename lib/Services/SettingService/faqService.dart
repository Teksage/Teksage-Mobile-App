import 'dart:convert';
import 'package:astro_prompt/Model/faq_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class FaqService {
  Future<List<FaqModel>> fetchFaqs() async {
    try {
      var response = await APIRequest.getRequest(ApiEndpoint.getFaq);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<FaqModel> faqs = data.map((item) => FaqModel.fromJson(item)).toList();
        return faqs;
      } else {
        throw Exception('Failed to load FAQs: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching FAQs: $e');
    }
  }
}
