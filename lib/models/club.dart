class Club {
  final String id;
  final String name;
  final String type;
  final String description;
  final String? coverImage;
  final List<String> tags;
  final int memberCount;
  final int level;
  final int experiencePoints;
  final String ownerId;
  final String ownerNickname;
  final bool isMember;
  final DateTime createdAt;

  Club({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.coverImage,
    this.tags = const [],
    this.memberCount = 0,
    this.level = 1,
    this.experiencePoints = 0,
    required this.ownerId,
    required this.ownerNickname,
    this.isMember = false,
    required this.createdAt,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      memberCount: json['memberCount'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      experiencePoints: json['experiencePoints'] as int? ?? 0,
      ownerId: json['ownerId'] as String,
      ownerNickname: json['ownerNickname'] as String,
      isMember: json['isMember'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'coverImage': coverImage,
      'tags': tags,
      'memberCount': memberCount,
      'level': level,
      'experiencePoints': experiencePoints,
      'ownerId': ownerId,
      'ownerNickname': ownerNickname,
      'isMember': isMember,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ClubTask {
  final String id;
  final String clubId;
  final String title;
  final String description;
  final String difficulty;
  final int xpReward;
  final DateTime deadline;
  final bool isCompleted;
  final DateTime createdAt;

  ClubTask({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    this.difficulty = 'Simple',
    this.xpReward = 10,
    required this.deadline,
    this.isCompleted = false,
    required this.createdAt,
  });

  factory ClubTask.fromJson(Map<String, dynamic> json) {
    return ClubTask(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String? ?? 'Simple',
      xpReward: json['xpReward'] as int? ?? 10,
      deadline: DateTime.parse(json['deadline']),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clubId': clubId,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'xpReward': xpReward,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
