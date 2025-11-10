/// API endpoint constants
class ApiEndpoints {
  // Base
  
  static const String health = '/health';
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  
  // Patients
  static const String patients = '/patients';
  static String patient(int id) => '/patients/$id';
  static String patientRecords(int id) => '/patients/$id/records';
  
  // Doctors
  static const String doctors = '/doctors';
  static String doctor(int id) => '/doctors/$id';
  
  // Departments
  static const String departments = '/departments';
  static String department(int id) => '/departments/$id';
  
  // Inventory
  static const String inventory = '/inventory';
  static String inventoryItem(int id) => '/inventory/$id';
  
  // Prescriptions
  static const String prescriptions = '/prescriptions';
  static String prescription(int id) => '/prescriptions/$id';
  
  // Audit
  static const String auditLogs = '/audit/logs';
}
