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
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      List<dynamic> body = jsonDecode(response.body);

      List<Skill> skills = body
          .map((dynamic item) => Skill.fromJson(item as Map<String, dynamic>))
          .toList();

      return skills;
    } catch (e) {
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

    await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "description": description,
        "long": long,
        "lat": lat,
      }),
    );
  }
}
