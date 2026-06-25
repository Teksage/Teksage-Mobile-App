class PanchangModel {
  final int panchangId;
  final Panchang panchang;

  PanchangModel({
    required this.panchangId,
    required this.panchang,
  });

  factory PanchangModel.fromJson(Map<String, dynamic> json) {
    return PanchangModel(
      panchangId: json['panchang_id'],
      panchang: Panchang.fromJson(json['data']),
    );
  }
}


class Panchang {
  final String time;
  final String date;
  final String weekday;
  final String eng_weekday;
  final String timeZoneId;
  final String sunrise;
  final String sunset;
  final Nakshathra nakshathra;
  final Thithi thithi;
  final Yoga yoga;
  final Karna karna;
  final String paksha;
  final AmirthathiYoga amirthathiYoga;
  final String rahuKala;
  final String yamaKanda;
  final List<String> auspiciousTime;
  final int tharaBala;
  final int chandraBala;
  final bool tharaBalaIsPositive;
  final bool chandraBalaIsPositive;

  Panchang({
    required this.time,
    required this.date,
    required this.weekday,
    required this.eng_weekday,
    required this.timeZoneId,
    required this.sunrise,
    required this.sunset,
    required this.nakshathra,
    required this.thithi,
    required this.yoga,
    required this.karna,
    required this.paksha,
    required this.amirthathiYoga,
    required this.rahuKala,
    required this.yamaKanda,
    required this.auspiciousTime,
    required this.tharaBala,
    required this.chandraBala,
    required this.tharaBalaIsPositive,
    required this.chandraBalaIsPositive,
  });

  factory Panchang.fromJson(Map<String, dynamic> json) {
    return Panchang(
      time: json['time'],
      date: json['date'],
      weekday: json['weekday'],
      eng_weekday: json['eng_weekday'],
      timeZoneId: json['timeZoneId'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      nakshathra: Nakshathra.fromJson(json['nakshathra']),
      thithi: Thithi.fromJson(json['thithi']),
      yoga: Yoga.fromJson(json['yoga']),
      karna: Karna.fromJson(json['karna']),
      paksha: json['paksha'],
      amirthathiYoga: AmirthathiYoga.fromJson(json['amirthathiYoga']),
      rahuKala: json['rahuKala'],
      yamaKanda: json['yamaKanda'],
      auspiciousTime: List<String>.from(json['auspiciousTime']),
      tharaBala: json['thara_bala'],
      chandraBala: json['chandra_bala'],
      tharaBalaIsPositive: json['thara_bala_is_positive'],
      chandraBalaIsPositive: json['chandra_bala_is_positive'],
    );
  }
}

class Nakshathra {
  final String name;
  final String endTime;
  final String next;

  Nakshathra({required this.name, required this.endTime, required this.next});

  factory Nakshathra.fromJson(Map<String, dynamic> json) {
    return Nakshathra(
      name: json['name'],
      endTime: json['endTime'],
      next: json['next'],
    );
  }
}

class Thithi {
  final String name;
  final String endTime;
  final String next;

  Thithi({required this.name, required this.endTime, required this.next});

  factory Thithi.fromJson(Map<String, dynamic> json) {
    return Thithi(
      name: json['name'],
      endTime: json['endTime'],
      next: json['next'],
    );
  }
}

class Yoga {
  final String name;
  final String endTime;
  final String next;

  Yoga({required this.name, required this.endTime, required this.next});

  factory Yoga.fromJson(Map<String, dynamic> json) {
    return Yoga(
      name: json['name'],
      endTime: json['endTime'],
      next: json['next'],
    );
  }
}

class Karna {
  final KarnaDetail first;
  final KarnaDetail second;

  Karna({required this.first, required this.second});

  factory Karna.fromJson(Map<String, dynamic> json) {
    return Karna(
      first: KarnaDetail.fromJson(json['first']),
      second: KarnaDetail.fromJson(json['second']),
    );
  }
}

class KarnaDetail {
  final String name;
  final String endTime;

  KarnaDetail({required this.name, required this.endTime});

  factory KarnaDetail.fromJson(Map<String, dynamic> json) {
    return KarnaDetail(
      name: json['name'],
      endTime: json['endTime'],
    );
  }
}

class AmirthathiYoga {
  final String name;
  final String endTime;
  final String next;

  AmirthathiYoga({required this.name, required this.endTime, required this.next});

  factory AmirthathiYoga.fromJson(Map<String, dynamic> json) {
    return AmirthathiYoga(
      name: json['name'],
      endTime: json['endTime'],
      next: json['next'],
    );
  }
}
