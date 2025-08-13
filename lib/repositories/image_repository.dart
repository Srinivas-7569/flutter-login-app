import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ImageRepository {
  Future<List<ImageModel>> fetchImages({int limit = 10}) async {
    final Uri url = Uri.parse('https://picsum.photos/v2/list?limit=$limit');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      return data.map((e) => ImageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
