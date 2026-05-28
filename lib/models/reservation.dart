class Reservation {
  final int? id;
  final String token;
  final String identityType;
  final String chineseName;
  final String englishName;
  final String grade;
  final DateTime reservationTime;
  final String status;
  final String? fingerprint;

  Reservation({
    this.id,
    required this.token,
    required this.identityType,
    required this.chineseName,
    required this.englishName,
    required this.grade,
    required this.reservationTime,
    required this.status,
    this.fingerprint,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      token: json['token'],
      identityType: json['identity_type'],
      chineseName: json['chinese_name'],
      englishName: json['english_name'],
      grade: json['grade'] ?? '',
      reservationTime: DateTime.parse(json['reservation_time']),
      status: json['status'],
      fingerprint: json['browser_fingerprint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'identity_type': identityType,
      'chinese_name': chineseName,
      'english_name': englishName,
      'grade': grade,
      'reservation_time': reservationTime.toIso8601String(),
      'status': status,
      'browser_fingerprint': fingerprint,
    };
  }
}
