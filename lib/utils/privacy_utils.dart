class PrivacyUtils {
  static String maskChineseName(String name) {
    if (name.isEmpty) return name;
    if (name.length == 1) return name;
    return name[0] + '*' * (name.length - 1);
  }

  static String maskEnglishName(String name) {
    if (name.isEmpty) return name;
    if (name.length <= 2) {
      if (name.length == 2) {
        return name[0] + '*';
      }
      return name;
    }
    return name[0] + '*' * (name.length - 2) + name[name.length - 1];
  }
  
  static String maskTicketNumber(String token, String status) {
    final s = status.toLowerCase();
    if (s.contains('cancelled') || 
        s.contains('已取消') ||
        s.contains('used') ||
        s.contains('已使用') ||
        s.contains('expired') ||
        s.contains('已过期')) {
      return 'FH-XXXXX';
    }
    return token;
  }
}
