import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> fetchData(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/$category'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['data']; // Adjust based on your response structure
    } else {
      throw Exception('Failed to load data');
    }
  }
}
