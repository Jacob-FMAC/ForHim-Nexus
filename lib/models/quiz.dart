class Question {
  final String id;
  final String category;
  final String difficulty;
  final String questionText;
  final String questionType; // 'multiple_choice', 'true_false', 'fill_blank'
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String? imageUrl;
  final int xpReward;

  Question({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.questionText,
    this.questionType = 'multiple_choice',
    this.options = const [],
    required this.correctAnswer,
    required this.explanation,
    this.imageUrl,
    this.xpReward = 10,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      questionText: json['questionText'] as String,
      questionType: json['questionType'] as String? ?? 'multiple_choice',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
      imageUrl: json['imageUrl'] as String?,
      xpReward: json['xpReward'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'difficulty': difficulty,
      'questionText': questionText,
      'questionType': questionType,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'imageUrl': imageUrl,
      'xpReward': xpReward,
    };
  }
}

class UserAnswer {
  final String id;
  final String userId;
  final String questionId;
  final String userAnswer;
  final bool isCorrect;
  final int timeSpent; // in seconds
  final DateTime answeredAt;

  UserAnswer({
    required this.id,
    required this.userId,
    required this.questionId,
    required this.userAnswer,
    required this.isCorrect,
    this.timeSpent = 0,
    required this.answeredAt,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      id: json['id'] as String,
      userId: json['userId'] as String,
      questionId: json['questionId'] as String,
      userAnswer: json['userAnswer'] as String,
      isCorrect: json['isCorrect'] as bool,
      timeSpent: json['timeSpent'] as int? ?? 0,
      answeredAt: DateTime.parse(json['answeredAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'questionId': questionId,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }
}

class QuizStreak {
  final String userId;
  final int currentStreak;
  final int highestStreak;
  final int totalQuestions;
  final int totalCorrect;
  final DateTime? lastQuizDate;

  QuizStreak({
    required this.userId,
    this.currentStreak = 0,
    this.highestStreak = 0,
    this.totalQuestions = 0,
    this.totalCorrect = 0,
    this.lastQuizDate,
  });

  factory QuizStreak.fromJson(Map<String, dynamic> json) {
    return QuizStreak(
      userId: json['userId'] as String,
      currentStreak: json['currentStreak'] as int? ?? 0,
      highestStreak: json['highestStreak'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      totalCorrect: json['totalCorrect'] as int? ?? 0,
      lastQuizDate: json['lastQuizDate'] != null
          ? DateTime.parse(json['lastQuizDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentStreak': currentStreak,
      'highestStreak': highestStreak,
      'totalQuestions': totalQuestions,
      'totalCorrect': totalCorrect,
      'lastQuizDate': lastQuizDate?.toIso8601String(),
    };
  }

  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return (totalCorrect / totalQuestions) * 100;
  }
}
