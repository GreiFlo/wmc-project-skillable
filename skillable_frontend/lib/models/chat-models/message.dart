class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final DateTime createdAt;
  final String? sender;
  final String? receiver;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    this.sender,
    this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      sender: json['sender'] as String?,
      receiver: json['receiver'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'content': content,
    'created_at': createdAt.toIso8601String(),
    if (sender != null) 'sender': sender,
    if (receiver != null) 'receiver': receiver,
  };

  @override
  String toString() =>
      'Message(id: $id, from: $senderId, to: $receiverId, content: $content)';
}
