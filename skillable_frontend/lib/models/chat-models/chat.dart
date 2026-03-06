class Chat {
  final int user2Id;
  final String username;

  Chat({required this.user2Id, required this.username});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(user2Id: json['user2id'] as int, username: json['username']);
  }

  Map<String, dynamic> toJson() => {'user2id': user2Id, 'username': username};
}
