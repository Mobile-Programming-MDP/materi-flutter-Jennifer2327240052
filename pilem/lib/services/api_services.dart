import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  // ganti dengan APIkey masing-masing
  static const String _apiKey = '363726ee172b090fc1d59e7fe0f44401';
  //1. mengambil list movie yag saat ini tayang
  Future<List<Map<String, dynamic>>> getAllMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movies/now_playing?api_key=$_apiKey'),
    );

    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // 2. mengambil list movie yang sedang trending minggu ini
  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movies/trending?api_key=$_apiKey'),
    );

    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // 3. mengambil list movie yang populer
  Future<Map<String, dynamic>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movies/popular?api_key=$_apiKey'),
    );

    final data = json.decode(response.body);
    return data;
  }

  // 4. mencari movie berdasarkan query
  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movies?query=$query&api_key=$_apiKey'),
    );

    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}
