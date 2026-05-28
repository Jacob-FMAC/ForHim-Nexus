class Ticket {
  final String token;
  final String qrData;
  final String visitorNameCn;
  final String visitorNameEn;
  final String visitorGrade;
  final String visitorType;
  final String status;
  final DateTime? usedAt;

  Ticket({
    required this.token,
    required this.qrData,
    required this.visitorNameCn,
    required this.visitorNameEn,
    required this.visitorGrade,
    required this.visitorType,
    required this.status,
    this.usedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      token: json['ticket_token'],
      qrData: json['qr_data'],
      visitorNameCn: json['visitor_name_cn'],
      visitorNameEn: json['visitor_name_en'],
      visitorGrade: json['visitor_grade'],
      visitorType: json['visitor_type'],
      status: json['status'],
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
    );
  }
}
