class AppConstants {
  // API Configuration
  // Use machine's WiFi IP so physical devices/emulators can connect.
  // For Android emulator use 10.0.2.2 instead. For web use localhost.
  static const String apiBaseUrl = 'http://localhost:8080';
  static const String apiActionPrefix = '?q=';

  // App Info
  static const String appName = 'ForHim Pass';
  static const String appVersion = '2.0.0';

  // Storage Keys
  static const String keyReservationToken = 'reservation_token';
  static const String keyFingerprint = 'browser_fingerprint';
  static const String keyLanguage = 'language';
  static const String keyAdminToken = 'admin_token';
  static const String keyFormState = 'form_state';

  // Grades
  static const List<String> parentGrades = ['G1', 'G2', 'G3', 'G4', 'G5', 'G6'];
  static const List<String> studentGrades = ['G7', 'G8', 'G9', 'G10', 'G11', 'G12', '已毕业'];

  // Admin
  static const String adminPasswordHash = 'admin_access_allowed'; // Mocking hash

  // Social Features
  static const List<String> clubTypes = [
    'Electronics Research',
    'Robotics',
    'Coding & AI',
    'Hardware Design',
    'Physics Club',
    'Maker Space'
  ];

  static const List<String> postCategories = [
    'Announcement',
    'Research',
    'Project Show',
    'Event',
    'General'
  ];
}
