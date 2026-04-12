import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = false;
  String? userId;
  try {
    await Firebase.initializeApp();
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      final credential = await auth.signInAnonymously();
      userId = credential.user?.uid;
    } else {
      userId = auth.currentUser?.uid;
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    firebaseReady = true;
  } catch (_) {
    firebaseReady = false;
  }

  runApp(Lesson34App(firebaseReady: firebaseReady, userId: userId));
}

class Lesson34App extends StatelessWidget {
  const Lesson34App({
    super.key,
    required this.firebaseReady,
    required this.userId,
  });

  final bool firebaseReady;
  final String? userId;
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Lesson 34: Notifications',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: NotificationHomePage(
        firebaseReady: firebaseReady && userId != null,
        userId: userId,
      ),
    );
  }
}

class NotificationMessage {
  const NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.itemId,
    required this.receivedAt,
    required this.source,
  });

  final String id;
  final String title;
  final String body;
  final String itemId;
  final DateTime receivedAt;
  final String source;
}

class NotificationLogEntry {
  const NotificationLogEntry({
    required this.message,
    required this.timestamp,
  });

  final String message;
  final DateTime timestamp;
}

class NotificationStateSnapshot {
  const NotificationStateSnapshot({
    required this.deviceToken,
    required this.messages,
    required this.logs,
    required this.notificationsEnabled,
  });

  final String deviceToken;
  final List<NotificationMessage> messages;
  final List<NotificationLogEntry> logs;
  final bool notificationsEnabled;

  NotificationStateSnapshot copyWith({
    String? deviceToken,
    List<NotificationMessage>? messages,
    List<NotificationLogEntry>? logs,
    bool? notificationsEnabled,
  }) {
    return NotificationStateSnapshot(
      deviceToken: deviceToken ?? this.deviceToken,
      messages: messages ?? this.messages,
      logs: logs ?? this.logs,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

abstract class NotificationService {
  Stream<NotificationStateSnapshot> get stream;

  Future<void> initialize();
  Future<void> setNotificationsEnabled(bool value);
  Future<void> simulateIncomingMessage();
}

class MockNotificationService implements NotificationService {
  MockNotificationService()
      : _state = const NotificationStateSnapshot(
          deviceToken: 'mock-token-lesson-34',
          messages: [],
          logs: [],
          notificationsEnabled: true,
        );

  NotificationStateSnapshot _state;
  final _controller = StreamController<NotificationStateSnapshot>.broadcast();
  final _random = Random();

  @override
  Stream<NotificationStateSnapshot> get stream => _controller.stream;

  @override
  Future<void> initialize() async {
    _log('Mock notification service initialized');
    _emit();
  }

  @override
  Future<void> setNotificationsEnabled(bool value) async {
    _state = _state.copyWith(notificationsEnabled: value);
    _log('Notifications ${value ? 'enabled' : 'disabled'} locally');
    _emit();
  }

  @override
  Future<void> simulateIncomingMessage() async {
    final itemId = 'item-${100 + _random.nextInt(900)}';
    final message = NotificationMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: 'Homework reminder',
      body: 'Open task $itemId from notification payload.',
      itemId: itemId,
      receivedAt: DateTime.now(),
      source: 'mock-foreground',
    );
    _state = _state.copyWith(messages: [message, ..._state.messages]);
    _log('Foreground notification received for $itemId');
    _emit();
  }

  void _log(String text) {
    _state = _state.copyWith(
      logs: [
        NotificationLogEntry(message: text, timestamp: DateTime.now()),
        ..._state.logs,
      ],
    );
  }

  void _emit() {
    _controller.add(_state);
  }
}

class FirebaseNotificationService implements NotificationService {
  FirebaseNotificationService({required this.userId})
      : _state = const NotificationStateSnapshot(
          deviceToken: 'initializing...',
          messages: [],
          logs: [],
          notificationsEnabled: true,
        );

  final String userId;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final _controller = StreamController<NotificationStateSnapshot>.broadcast();
  NotificationStateSnapshot _state;

  @override
  Stream<NotificationStateSnapshot> get stream => _controller.stream;

  @override
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    _state = _state.copyWith(notificationsEnabled: enabled);

    final permission = await _messaging.requestPermission();
    _log('Notification permission: ${permission.authorizationStatus.name}');
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        final itemId = response.payload ?? 'unknown-item';
        _log('Local notification tapped for $itemId');
        _openNotificationDetails(
          NotificationMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: 'Opened from local notification',
            body: 'Foreground notification tap handled successfully.',
            itemId: itemId,
            receivedAt: DateTime.now(),
            source: 'local-notification-tap',
          ),
        );
        _emit();
      },
    );
    await _createNotificationChannel();

    final token = await _messaging.getToken() ?? 'token-unavailable';
    _state = _state.copyWith(deviceToken: token);
    await _saveToken(token);
    _log('Device token fetched');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      _state = _state.copyWith(deviceToken: newToken);
      await _saveToken(newToken);
      _log('Device token refreshed');
      _emit();
    });

    FirebaseMessaging.onMessage.listen((message) async {
      final record = _toMessage(message, 'fcm-foreground');
      _state = _state.copyWith(messages: [record, ..._state.messages]);
      _log('Foreground notification received for ${record.itemId}');

      if (_state.notificationsEnabled) {
        await _localNotifications.show(
          record.id.hashCode,
          record.title,
          record.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'lesson34',
              'Lesson 34 Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: record.itemId,
        );
      }

      _emit();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final record = _toMessage(message, 'fcm-opened');
      _state = _state.copyWith(messages: [record, ..._state.messages]);
      _log('Notification tap opened ${record.itemId}');
      _openNotificationDetails(record);
      _emit();
    });

    final launchMessage = await _messaging.getInitialMessage();
    if (launchMessage != null) {
      final record = _toMessage(launchMessage, 'fcm-terminated');
      _state = _state.copyWith(messages: [record, ..._state.messages]);
      _log('App launched from terminated state to ${record.itemId}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openNotificationDetails(record);
      });
    }

    _emit();
  }

  @override
  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    _state = _state.copyWith(notificationsEnabled: value);
    _log('Notifications ${value ? 'enabled' : 'disabled'} locally');
    _emit();
  }

  @override
  Future<void> simulateIncomingMessage() async {
    _log('Use Firebase Console to send a real test push notification');
    _emit();
  }

  NotificationMessage _toMessage(RemoteMessage message, String source) {
    return NotificationMessage(
      id: message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Untitled notification',
      body: message.notification?.body ?? 'Open details for payload data',
      itemId: message.data['itemId']?.toString() ?? 'unknown-item',
      receivedAt: DateTime.now(),
      source: source,
    );
  }

  Future<void> _saveToken(String token) async {
    await FirebaseFirestore.instance.collection('device_tokens').doc(userId).set(
      {
        'userId': userId,
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  void _log(String text) {
    _state = _state.copyWith(
      logs: [
        NotificationLogEntry(message: text, timestamp: DateTime.now()),
        ..._state.logs,
      ],
    );
  }

  void _emit() {
    _controller.add(_state);
  }

  void _openNotificationDetails(NotificationMessage message) {
    final context = Lesson34App.navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    Lesson34App.navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (_) => NotificationDetailsPage(message: message),
      ),
    );
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'lesson34_channel',
      'Lesson 34 Notifications',
      description: 'Foreground and test notifications for lesson 34',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    _log('Notification channel ready: ${channel.id}');
  }
}

class NotificationHomePage extends StatefulWidget {
  const NotificationHomePage({
    super.key,
    required this.firebaseReady,
    required this.userId,
  });

  final bool firebaseReady;
  final String? userId;

  @override
  State<NotificationHomePage> createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  late final NotificationService _service;
  late final Future<void> _startup;

  @override
  void initState() {
    super.initState();
    _service = widget.firebaseReady
        ? FirebaseNotificationService(userId: widget.userId!)
        : MockNotificationService();
    _startup = _service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson 34: Push Notifications')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _service.simulateIncomingMessage,
        icon: const Icon(Icons.notifications_active),
        label: Text(widget.firebaseReady ? 'FCM hint' : 'Simulate push'),
      ),
      body: FutureBuilder<void>(
        future: _startup,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<NotificationStateSnapshot>(
            stream: _service.stream,
            builder: (context, stateSnapshot) {
              final state = stateSnapshot.data;
              if (state == null) {
                return const Center(child: Text('Waiting for notifications...'));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (!widget.firebaseReady)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Firebase is not configured here, so this lesson runs in mock mode. The app still demonstrates token handling, deep-link payloads, local settings, and notification logging.',
                        ),
                      ),
                    ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Notification settings'),
                      subtitle: const Text(
                        'Open the dedicated settings screen for notification preferences.',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => NotificationSettingsPage(
                              enabled: state.notificationsEnabled,
                              onChanged: _service.setNotificationsEnabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      title: const Text('Device token'),
                      subtitle: Text(state.deviceToken),
                      leading: const Icon(Icons.key),
                      trailing: IconButton(
                        tooltip: 'Copy token',
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: state.deviceToken),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Device token copied'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: SwitchListTile(
                      title: const Text('Notifications enabled'),
                      subtitle: const Text(
                        'Quick toggle mirrored from the settings screen.',
                      ),
                      value: state.notificationsEnabled,
                      onChanged: _service.setNotificationsEnabled,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Incoming messages',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (state.messages.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No messages yet. Trigger one to test payload navigation.'),
                      ),
                    ),
                  ...state.messages.map(
                    (message) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.mark_email_unread_outlined),
                        title: Text(message.title),
                        subtitle: Text(
                          '${message.body}\nPayload itemId: ${message.itemId}\nSource: ${message.source}',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => NotificationDetailsPage(message: message),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Debug log',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...state.logs.map(
                    (entry) => Card(
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.bug_report_outlined),
                        title: Text(entry.message),
                        subtitle: Text(entry.timestamp.toIso8601String()),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key, required this.message});

  final NotificationMessage message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(message.body),
            const SizedBox(height: 24),
            Text('Deep link target item: ${message.itemId}'),
            const SizedBox(height: 8),
            Text('Source: ${message.source}'),
            const SizedBox(height: 8),
            Text('Received at: ${message.receivedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final Future<void> Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Enable notifications'),
              subtitle: const Text(
                'This flag is stored locally and controls foreground display behavior.',
              ),
              value: enabled,
              onChanged: (value) async {
                await onChanged(value);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'When enabled, foreground FCM messages are displayed via local notifications and can open Notification Details with the payload item id.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
