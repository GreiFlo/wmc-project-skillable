import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillable_frontend/models/skillmodels/skill.dart';

class SkillsService {
  final String baseUrl = 'http://10.0.2.2:3000/skills';
  final http.Client _client;

  SkillsService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Skill>> getNearby({
    required double lat,
    required double long,
  }) async {
    final uri = Uri.parse('$baseUrl/nearby?lat=$lat&long=$long');

    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString('token');
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      _client.close();

      List<dynamic> body = jsonDecode(response.body);

      List<Skill> skills = body
          .map((dynamic item) => Skill.fromJson(item as Map<String, dynamic>))
          .toList();

      return skills;
    } catch (e) {
      return List<Skill>.empty();
    }
  }

  Future<List<Skill>> getAll() async {
    final uri = Uri.parse('$baseUrl/all');
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString('token');

      final response = await _client
          .get(
            // _client statt http.get
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'Connection': 'close', // wichtig für lokale Server
            },
          )
          .timeout(const Duration(seconds: 5));

      _client.close();

      if (response.statusCode != 200) {
        print('Error: ${response.statusCode} - ${response.body}');
        return List<Skill>.empty();
      }

      List<dynamic> body = jsonDecode(response.body);
      return body
          .map((dynamic item) => Skill.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('getAll error: $e'); // zeigt dir den echten Fehler
      return List<Skill>.empty();
    }
  }

  Future<void> addSkill({
    required String title,
    required String description,
    required double long,
    required double lat,
  }) async {
    final uri = Uri.parse(baseUrl);

    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    
    await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "title": title,
        "description": description,
        "long": long,
        "lat": lat,
      }),
    );

    _client.close();
  }
}
