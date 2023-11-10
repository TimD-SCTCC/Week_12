import 'package:dio/dio.dart';
import './DataService.dart';
import '../Models/AuthResponse.dart';
import '../Models/LoginStructure.dart';
import '../Models/User.dart';

const String BaseUrl = "https://cmsc2204-mobile-api.onrender.com/Auth";

class UserClient {
  final _dio = Dio(BaseOptions(baseUrl: BaseUrl));
  DataService _dataService = DataService();

  Future<AuthResponse?> Login(LoginStructure user) async {
    try {
      var response = await _dio.post("/login",
          data: {"username": user.username, "password": user.password});

      var data = response.data['data'];

      var authResponse = AuthResponse(data['userId'], data['token']);

      if (authResponse.token != null) {
        if (!await _dataService.AddItem("token", authResponse.token)) {
          await _dataService.UpdateItem("token", authResponse.token);
        }
      }

      return authResponse;
    } catch (error) {
      print("Login error: $error");
      return null;
    }
  }

  Future<List<User>?> GetUsersAsync() async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (token != null) {
        var response = await _dio.get("/GetUsers",
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }));

        if (response.statusCode == 200) {
          List<User> users = [];
          for (var user in response.data) {
            users.add(User(user["_id"], user["Username"], user["Password"],
                user["Email"], user["AuthLevel"]));
          }

          return users;
        } else {
          print("Failed to load users: ${response.statusCode}");
          return null;
        }
      } else {
        print("No token found.");
        return null;
      }
    } catch (error) {
      print("Error loading users: $error");
      return null;
    }
  }

  Future<String> GetApiVersion() async {
    try {
      var response = await _dio.get("/ApiVersion");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Failed to get API version: ${response.statusCode}");
        return "Unknown";
      }
    } catch (error) {
      print("Error getting API version: $error");
      return "Unknown";
    }
  }
}
