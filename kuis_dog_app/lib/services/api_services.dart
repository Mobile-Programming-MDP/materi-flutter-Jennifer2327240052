import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl = "https://dog.ceo/api/breeds/image/random";
  static Future<String> fetchRandomDogImage() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']; // Return the image URL
      } else {
        throw Exception('Failed to load dog image');
      }
    } catch (e) {
      throw Exception('Failed to load dog image: $e');
    }
  }
}
