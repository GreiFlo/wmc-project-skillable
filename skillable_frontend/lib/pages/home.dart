import 'package:flutter/material.dart';
import 'package:skillable_frontend/models/skillmodels/skill.dart';
import 'package:skillable_frontend/services/skills_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }

  
}

class _HomePage extends State<HomePage>{

  var skills = List<Skill>.empty();

  @override
  void initState() {
    loadSkills();
    super.initState();
  }

  Future<void> loadSkills() async {
    var listSkills = await SkillsService().getAll();
    setState(() {
      skills = listSkills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: skills.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(skills[index].title),
          subtitle: Text(skills[index].description),
        ),
      ),
    );
  }

}