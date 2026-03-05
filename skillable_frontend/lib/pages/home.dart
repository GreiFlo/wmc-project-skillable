import 'package:flutter/material.dart';
import 'package:skillable_frontend/models/skillmodels/skill.dart';
import 'package:skillable_frontend/pages/detail_skill.dart';
import 'package:skillable_frontend/services/skills_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
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

  var _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return // State-Variablen in der Klasse:
    // String _selectedFilter = 'All';
    // Die Filter-Icons/Labels kannst du später mit Logik belegen
    Scaffold(
      appBar: AppBar(
        title: const Text(
          'Skillable',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              child: Icon(
                Icons.person_outline_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  _FilterChip(
                    icon: Icons.location_on_outlined,
                    label: null,
                    isSelected: _selectedFilter == 'location',
                    onTap: () => setState(() => _selectedFilter = 'location'),
                  ),
                  _FilterChip(
                    icon: Icons.access_time_rounded,
                    label: null,
                    isSelected: _selectedFilter == 'recent',
                    onTap: () => setState(() => _selectedFilter = 'recent'),
                  ),
                  _FilterChip(
                    icon: null,
                    label: 'All',
                    isSelected: _selectedFilter == 'All',
                    onTap: () => setState(() => _selectedFilter = 'All'),
                  ),
                ],
              ),
            ),
          ),

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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SkillDetail(skill: skill)));
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
                              'By ${skill.username}',
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

class _FilterChip extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    this.icon,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: icon != null
            ? Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              )
            : Text(
                label!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }
}
