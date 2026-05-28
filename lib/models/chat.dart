class ChatMessage {
  final String id;
  final String senderId;
  final String senderNickname;
  final String? senderAvatar;
  final String content;
  final String messageType; // 'text', 'image', 'file'
  final String? fileUrl;
  final DateTime sentAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderNickname,
    this.senderAvatar,
    required this.content,
    this.messageType = 'text',
    this.fileUrl,
    required this.sentAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderNickname: json['senderNickname'] as String,
      senderAvatar: json['senderAvatar'] as String?,
      content: json['content'] as String,
      messageType: json['messageType'] as String? ?? 'text',
      fileUrl: json['fileUrl'] as String?,
      sentAt: DateTime.parse(json['sentAt']),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderNickname': senderNickname,
      'senderAvatar': senderAvatar,
      'content': content,
      'messageType': messageType,
      'fileUrl': fileUrl,
      'sentAt': sentAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}

class GroupChat {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final List<String> tags;
  final String ownerId;
  final int memberCount;
  final int? minFlightHours;
  final String? regionRequirement;
  final bool isWorldChat;
  final DateTime createdAt;

  GroupChat({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    this.tags = const [],
    required this.ownerId,
    this.memberCount = 0,
    this.minFlightHours,
    this.regionRequirement,
    this.isWorldChat = false,
    required this.createdAt,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) {
    return GroupChat(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      ownerId: json['ownerId'] as String,
      memberCount: json['memberCount'] as int? ?? 0,
      minFlightHours: json['minFlightHours'] as int?,
      regionRequirement: json['regionRequirement'] as String?,
      isWorldChat: json['isWorldChat'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'tags': tags,
      'ownerId': ownerId,
      'memberCount': memberCount,
      'minFlightHours': minFlightHours,
      'regionRequirement': regionRequirement,
      'isWorldChat': isWorldChat,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Notification {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String content;
  final String? relatedId;
  final String? relatedType;
  final bool isRead;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    this.relatedId,
    this.relatedType,
    this.isRead = false,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      relatedId: json['relatedId'] as String?,
      relatedType: json['relatedType'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'content': content,
      'relatedId': relatedId,
      'relatedType': relatedType,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
