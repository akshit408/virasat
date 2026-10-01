class EnvConfig {
  static const String appName = 'VIRASAT - Crafted by India';
  static const String apiVersion = 'v1';

  // Base URL loaded from environment parameters or default endpoint
  static const String baseUrl = String.fromEnvironment(
    'VIRASAT_API_BASE_URL',
    defaultValue: 'https://api.virasat.in/api/v1',
  );

  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://192.168.31.84:5000/api',
  );

  static const String mongoDbUri = String.fromEnvironment(
    'MONGODB_URI',
    defaultValue: '',
  );

  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const String grokApiKey = String.fromEnvironment(
    'GROK_API_KEY',
    defaultValue: '',
  );

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vjvikwtrnunseaxkwodu.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_3ypDaFi6LsuBU7XIRJnOGQ__kRrQzmZ',
  );

  static const String supabaseServiceRoleKey = String.fromEnvironment(
    'SUPABASE_SERVICE_ROLE_KEY',
    defaultValue: 'sb_publishable_3ypDaFi6LsuBU7XIRJnOGQ__kRrQzmZ',
  );

  static const String supabaseDbUrl = String.fromEnvironment(
    'SUPABASE_DB_URL',
    defaultValue: '',
  );

  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '771608231166-b89jpe8kdbs4f50ko5ctuho4f9ptrt46.apps.googleusercontent.com',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static const String dataGovApiKey = String.fromEnvironment(
    'DATA_GOV_API_KEY',
    defaultValue: '',
  );

  static const String jwtSecret = String.fromEnvironment(
    'JWT_SECRET',
    defaultValue: '',
  );

  static const int connectTimeout = 15000; // 15 seconds
  static const int receiveTimeout = 15000;

  // MongoDB Collection Registry Names
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String artisansCollection = 'artisans';
  static const String sellerVerificationsCollection = 'seller_verifications';
  static const String wishlistCollection = 'wishlist';
  static const String cartCollection = 'cart';
  static const String ordersCollection = 'orders';

  // Feature Flags
  static const bool enableOfflineMocking = true;
  static const bool enableAIGenerativeStudio = true;
}
