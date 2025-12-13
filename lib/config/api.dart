// class Api {
//   // static const baseUrl = "http://10.0.2.2:8000/api"; // emulator
//   // http://127.0.0.1:8000
//   static const baseUrl = "http://192.168.54.146:8000/api"; // HP asli
// }

// class Api {
//   static const String baseUrl = "http://192.168.39.146:7000/api";
//   static const String login = "$baseUrl/login";
//   static const String register = "$baseUrl/register";
//   static const String upload = "$baseUrl/sampah";
//   static const String list = "$baseUrl/sampah";
//   static const String dashboard = "$baseUrl/dashboard";
// }
class Api {
  static const String baseUrl = "http://192.168.193.146:7000/api";

  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";

  static const String sampahStore = "$baseUrl/sampah/store";
  static const String list = "$baseUrl/sampah";
  static const String dashboard = "$baseUrl/dashboard";
  static const String baseUrlStorage =
      "http://192.168.193.146:7000/api/uploads";
}
