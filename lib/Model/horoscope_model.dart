class Horoscope {
  final String firstName;
  final String lastName;
  final String preferredLocation;
  final String dateOfBirth;
  final String timeOfBirth;
  final String birthLocation;
  final String rashi;
  final String nakshatra;
  final String lagna;
  final String rashiChart;
  final String navamsaChart;

  Horoscope({
    required this.firstName,
    required this.lastName,
    required this.preferredLocation,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.birthLocation,
    required this.rashi,
    required this.nakshatra,
    required this.lagna,
    required this.rashiChart,
    required this.navamsaChart,
  });

  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      preferredLocation: json['preferred_location'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      timeOfBirth: json['time_of_birth'] ?? '',
      birthLocation: json['birth_location'] ?? '',
      rashi: json['rashi'] ?? '',
      nakshatra: json['nakshatra'] ?? '',
      lagna: json['lagna'] ?? '',
      rashiChart: json['rashi_chart'] ?? '',
      navamsaChart: json['navamsa_chart'] ?? '',
    );
  }
}

class HoroscopeDivisionalChart {
  final String id;
  final String label;
  final String html;

  HoroscopeDivisionalChart({
    required this.id,
    required this.label,
    required this.html,
  });

  factory HoroscopeDivisionalChart.fromJson(Map<String, dynamic> json) {
    return HoroscopeDivisionalChart(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      html: json['html']?.toString() ?? '',
    );
  }
}

List<HoroscopeDivisionalChart> fallbackDivisionalCharts(Horoscope data) {
  return [
    if (data.rashiChart.trim().isNotEmpty)
      HoroscopeDivisionalChart(id: 'd1', label: 'Rasi', html: data.rashiChart),
    if (data.navamsaChart.trim().isNotEmpty)
      HoroscopeDivisionalChart(
        id: 'd9',
        label: 'Navamsa',
        html: data.navamsaChart,
      ),
  ];
}
