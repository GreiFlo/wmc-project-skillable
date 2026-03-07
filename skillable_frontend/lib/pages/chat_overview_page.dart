import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillable_frontend/models/chat-models/chat.dart';
import 'package:skillable_frontend/pages/chat_page.dart';
import 'package:skillable_frontend/pages/theme_settings.dart';

class ChatOverview extends StatefulWidget {
  const ChatOverview({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatOverview();
  }
}

class _ChatOverview extends State<ChatOverview> {
  List<Chat> chats = List.empty();

  @override
  void initState() {
    loadChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kürzliche Chats',
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
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      user2Id: chat.user2Id,
                      username: chat.username,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Text(
                          chat.username.isNotEmpty
                              ? chat.username[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          chat.username,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> rawChats = jsonDecode(prefs.getString('chats') ?? '[]');
    setState(() {
      chats = rawChats
          .map((item) => Chat.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
