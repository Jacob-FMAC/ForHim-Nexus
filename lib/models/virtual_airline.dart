class VirtualAirline {
  final String id;
  final String name;
  final String iataCode;
  final String icaoCode;
  final String? logo;
  final String primaryColor;
  final String accentColor;
  final String hubAirport;
  final String slogan;
  final String description;
  final int fleetSize;
  final int routeCount;
  final int level;
  final double safetyScore;
  final String ownerId;
  final String ownerNickname;
  final DateTime foundedDate;
  final DateTime createdAt;

  VirtualAirline({
    required this.id,
    required this.name,
    required this.iataCode,
    required this.icaoCode,
    this.logo,
    this.primaryColor = '#0066CC',
    this.accentColor = '#00D9FF',
    required this.hubAirport,
    required this.slogan,
    required this.description,
    this.fleetSize = 0,
    this.routeCount = 0,
    this.level = 1,
    this.safetyScore = 100.0,
    required this.ownerId,
    required this.ownerNickname,
    required this.foundedDate,
    required this.createdAt,
  });

  factory VirtualAirline.fromJson(Map<String, dynamic> json) {
    return VirtualAirline(
      id: json['id'] as String,
      name: json['name'] as String,
      iataCode: json['iataCode'] as String,
      icaoCode: json['icaoCode'] as String,
      logo: json['logo'] as String?,
      primaryColor: json['primaryColor'] as String? ?? '#0066CC',
      accentColor: json['accentColor'] as String? ?? '#00D9FF',
      hubAirport: json['hubAirport'] as String,
      slogan: json['slogan'] as String,
      description: json['description'] as String,
      fleetSize: json['fleetSize'] as int? ?? 0,
      routeCount: json['routeCount'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      safetyScore: (json['safetyScore'] as num?)?.toDouble() ?? 100.0,
      ownerId: json['ownerId'] as String,
      ownerNickname: json['ownerNickname'] as String,
      foundedDate: DateTime.parse(json['foundedDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iataCode': iataCode,
      'icaoCode': icaoCode,
      'logo': logo,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'hubAirport': hubAirport,
      'slogan': slogan,
      'description': description,
      'fleetSize': fleetSize,
      'routeCount': routeCount,
      'level': level,
      'safetyScore': safetyScore,
      'ownerId': ownerId,
      'ownerNickname': ownerNickname,
      'foundedDate': foundedDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get operationDays {
    return DateTime.now().difference(foundedDate).inDays;
  }
}
