import 'package:flutter/material.dart';
import 'package:skillable_frontend/models/skillmodels/skill.dart';
import 'package:skillable_frontend/pages/detail_skill.dart';
import 'package:skillable_frontend/pages/theme_settings.dart';
import 'package:skillable_frontend/services/skills_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  var skills = List<Skill>.empty();

  @override
  void initState() {
    loadSkills();
    super.initState();
  }

  Future<void> loadSkills() async {
    List<Skill>? listSkills;

    listSkills = await SkillsService().getOwn();

    setState(() {
      skills = listSkills!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dein Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              child: IconButton(
                icon: Icon(Icons.settings),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThemeSettingsPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    child: InkWell(
                      //bei klick auf ein Skill
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SkillDetail(skill: skill),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              skill.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Von ${skill.username}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              skill.creationDate,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
