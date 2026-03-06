import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<FoodItem>> fetchFoodItems(String filter) async {
    try {
      String url;
      if (filter == 'All') {
        url = '$baseUrl/search.php?s=a'; // Get meals starting with 'a'
      } else {
        url = '$baseUrl/filter.php?a=$filter';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<dynamic> meals = data['meals'];
          return meals.map((json) => FoodItem.fromJson(json)).toList();
        } else {
          throw Exception('No meals found');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
