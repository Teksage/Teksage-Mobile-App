import 'dart:convert';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

class CountryCodeService {
  static const int maxRetries = 3;

  // Singleton instance
  static final CountryCodeService _instance = CountryCodeService._internal();
  factory CountryCodeService() => _instance;
  CountryCodeService._internal();

  // Cache for the country list
  static List<Country>? _cachedCountries;

  // Future to track in-flight requests (prevents duplicate calls)
  static Future<List<Country>>? _fetchFuture;

  Future<List<Country>> fetchCountries({int retryCount = 0, bool forceRefresh = false}) async {
    // Return cached data if available and not forcing refresh
    if (!forceRefresh && _cachedCountries != null) {
      print('Returning cached countries');
      return _cachedCountries!;
    }

    // If a fetch is already in progress, return the same future
    if (_fetchFuture != null) {
      print('Fetch already in progress, waiting for it...');
      return _fetchFuture!;
    }

    // Start a new fetch
    print('Fetching countries from API');
    _fetchFuture = _fetchFromApi(retryCount: retryCount).then((countries) {
      _cachedCountries = countries;
      _fetchFuture = null;
      return countries;
    }).catchError((error) {
      _fetchFuture = null;
      throw error;
    });

    return _fetchFuture!;
  }

  Future<List<Country>> _fetchFromApi({int retryCount = 0}) async {
    final response = await http.get(Uri.parse(ApiEndpoint.getCountyCode));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<Country> countries = jsonData.map((item) => Country.fromJson(item)).toList();
      countries.sort((a, b) => a.countryName.compareTo(b.countryName));
      return countries;
    } else {
      throw Exception('Failed to load countries');
    }
  }

  // Method to clear cache if needed
  void clearCache() {
    _cachedCountries = null;
  }
}
