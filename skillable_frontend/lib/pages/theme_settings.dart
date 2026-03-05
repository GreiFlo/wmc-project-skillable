import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillable_frontend/appthemes.dart';
import 'package:skillable_frontend/providers/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Einstellungen")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "App-Design anpassen",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Das Dropdown-Menü
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ThemeData>(
                  value: themeNotifier.currentTheme,
                  isExpanded: true,
                  icon: const Icon(Icons.palette_outlined),
                  onChanged: (ThemeData? newValue) {
                    if (newValue != null) {
                      themeNotifier.setTheme(newValue);
                    }
                  },
                  items: [
                    DropdownMenuItem(value: AppThemes.system, child: const Text("System")),
                    DropdownMenuItem(value: AppThemes.darkTheme, child: const Text("Dark")),
                    DropdownMenuItem(value: AppThemes.lightTheme, child: const Text("Light")),
                    DropdownMenuItem(value: AppThemes.darkGreenTheme, child: const Text("Green")),
                    DropdownMenuItem(value: AppThemes.redTheme, child: const Text("Red")),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            
            // Vorschau-Karten zur Demonstration
            Card(
              child: ListTile(
                leading: Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                title: const Text("Vorschau"),
                subtitle: Text("Aktuell gewählt: ${themeNotifier.currentTheme.toString().split('.').last}"),
              ),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {},
              child: const Text("Beispiel Button"),
            ),
          ],
        ),
      ),
    );
  }
}