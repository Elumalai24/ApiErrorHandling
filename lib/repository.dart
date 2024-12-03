import 'dart:convert';
import 'api_client.dart';
import 'model.dart';

class ApiRepository {
  static Future<List<Coffee>> getCoffees() async {
    ApiClient apiClient = ApiClient();
    final  response = await apiClient.get("coffee/hot", queryParameters: {});
     final List<dynamic> data = response.data;
    final List<Coffee> coffees = data.map((e) =>
      Coffee.fromJson(e)
    ).toList();
    return coffees;
  }
}


