import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillable_frontend/models/chat-models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ChatConnectionState { disconnected, connecting, connected, error }

//AI prompt 7
class ChatService {
  final String serverUrl;
  final String jwtToken;
  final http.Client _client;

  ChatService({
    http.Client? client,
    required this.serverUrl,
    required this.jwtToken,
  }) : _client = client ?? http.Client();

  IO.Socket? _socket;
  ChatConnectionState _connectionState = ChatConnectionState.disconnected;

  final _messageReceivedController = StreamController<Message>.broadcast();
  final _messageSentController = StreamController<Message>.broadcast();
  final _connectionStateController =
      StreamController<ChatConnectionState>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  Stream<Message> get onMessageReceived => _messageReceivedController.stream;
  Stream<Message> get onMessageSent => _messageSentController.stream;
  Stream<ChatConnectionState> get onConnectionStateChanged =>
      _connectionStateController.stream;
  Stream<String> get onError => _errorController.stream;

  ChatConnectionState get connectionState => _connectionState;
  bool get isConnected => _connectionState == ChatConnectionState.connected;

  void connect() {
    if (_connectionState == ChatConnectionState.connecting ||
        _connectionState == ChatConnectionState.connected)
      return;

    _updateConnectionState(ChatConnectionState.connecting);

    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': jwtToken})
          .build(),
    );

    _setupListeners();
    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _updateConnectionState(ChatConnectionState.disconnected);
  }

  bool sendMessage({required int receiverId, required String content}) {
    if (!isConnected || content.trim().isEmpty) return false;
    _socket!.emit('send_message', {
      'receiverId': receiverId,
      'content': content,
    });
    return true;
  }

  Future<List<Message>?> getMessages({required int user2Id}) async {
    final uri = Uri.parse('$serverUrl/chat/messages?user2=$user2Id');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final List<dynamic> body = jsonDecode(response.body);
      return body
          .map((item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _errorController.add('Fehler beim Laden der Nachrichten: $e');
      return null;
    }
  }

  void _setupListeners() {
    _socket!
      ..onConnect((_) => _updateConnectionState(ChatConnectionState.connected))
      ..onDisconnect(
        (_) => _updateConnectionState(ChatConnectionState.disconnected),
      )
      ..onConnectError((data) {
        _updateConnectionState(ChatConnectionState.error);
        _errorController.add('Verbindungsfehler: $data');
      })
      ..onError((data) => _errorController.add('Socket-Fehler: $data'))
      ..on('receive_message', (data) {
        try {
          _messageReceivedController.add(
            Message.fromJson(Map<String, dynamic>.from(data)),
          );
        } catch (e) {
          _errorController.add('Fehler beim Parsen der Nachricht: $e');
        }
      })
      ..on('message_sent', (data) {
        try {
          _messageSentController.add(
            Message.fromJson(Map<String, dynamic>.from(data)),
          );
        } catch (e) {
          _errorController.add(
            'Fehler beim Parsen der gesendeten Nachricht: $e',
          );
        }
      })
      ..on('error', (data) {
        _errorController.add(
          data is Map ? (data['message'] as String?) ?? 'Fehler' : '$data',
        );
      });
  }

  void _updateConnectionState(ChatConnectionState state) {
    _connectionState = state;
    _connectionStateController.add(state);
  }

  void dispose() {
    disconnect();
    _client.close(); // ✅ Only close when service is fully disposed
    _messageReceivedController.close();
    _messageSentController.close();
    _connectionStateController.close();
    _errorController.close();
  }
}
