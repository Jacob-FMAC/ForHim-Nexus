class User {
  final String id;
  final String email;
  final String nickname;
  final String? avatar;
  final String? coverImage;
  final String gender;
  final DateTime? birthday;
  final String? country;
  final String? province;
  final String? city;
  final String? favoriteAircraft;
  final String? bio;
  final int virtualFlightHours;
  final int realFlightHours;
  final int experiencePoints;
  final String rank;
  final List<String> badges;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    this.avatar,
    this.coverImage,
    this.gender = 'Other',
    this.birthday,
    this.country,
    this.province,
    this.city,
    this.favoriteAircraft,
    this.bio,
    this.virtualFlightHours = 0,
    this.realFlightHours = 0,
    this.experiencePoints = 0,
    this.rank = 'New Pilot',
    this.badges = const [],
    this.isAdmin = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String?,
      coverImage: json['coverImage'] as String?,
      gender: json['gender'] as String? ?? 'Other',
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      country: json['country'] as String?,
      province: json['province'] as String?,
      city: json['city'] as String?,
      favoriteAircraft: json['favoriteAircraft'] as String?,
      bio: json['bio'] as String?,
      virtualFlightHours: json['virtualFlightHours'] as int? ?? 0,
      realFlightHours: json['realFlightHours'] as int? ?? 0,
      experiencePoints: json['experiencePoints'] as int? ?? 0,
      rank: json['rank'] as String? ?? 'New Pilot',
      badges:
          (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isAdmin: json['isAdmin'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'avatar': avatar,
      'coverImage': coverImage,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'country': country,
      'province': province,
      'city': city,
      'favoriteAircraft': favoriteAircraft,
      'bio': bio,
      'virtualFlightHours': virtualFlightHours,
      'realFlightHours': realFlightHours,
      'experiencePoints': experiencePoints,
      'rank': rank,
      'badges': badges,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? nickname,
    String? avatar,
    String? coverImage,
    String? gender,
    DateTime? birthday,
    String? country,
    String? province,
    String? city,
    String? favoriteAircraft,
    String? bio,
    int? virtualFlightHours,
    int? realFlightHours,
    int? experiencePoints,
    String? rank,
    List<String>? badges,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      country: country ?? this.country,
      province: province ?? this.province,
      city: city ?? this.city,
      favoriteAircraft: favoriteAircraft ?? this.favoriteAircraft,
      bio: bio ?? this.bio,
      virtualFlightHours: virtualFlightHours ?? this.virtualFlightHours,
      realFlightHours: realFlightHours ?? this.realFlightHours,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      rank: rank ?? this.rank,
      badges: badges ?? this.badges,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  int get age {
    if (birthday == null) return 0;
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month ||
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age--;
    }
    return age;
  }

  String get zodiacSign {
    if (birthday == null) return '';
    final month = birthday!.month;
    final day = birthday!.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
      return 'Scorpio';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return 'Sagittarius';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return 'Capricorn';
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return 'Aquarius';
    return 'Pisces';
  }
}
