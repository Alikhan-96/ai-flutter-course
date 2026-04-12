import 'package:flutter/material.dart';

void main() {
  runApp(const Lesson37App());
}

class Lesson37App extends StatelessWidget {
  const Lesson37App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 37: Singleton and Factory',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const PatternShowcasePage(),
    );
  }
}

class LoggerService {
  LoggerService._internal();

  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() => _instance;

  final List<String> _entries = [];

  void log(String message) {
    _entries.insert(0, '${DateTime.now().toIso8601String()} | $message');
  }

  List<String> get entries => List.unmodifiable(_entries);

  void reset() {
    _entries.clear();
  }
}

class AnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  final Map<String, int> _events = {};

  void track(String event) {
    _events[event] = (_events[event] ?? 0) + 1;
    LoggerService().log('Analytics event: $event');
  }

  Map<String, int> get events => Map<String, int>.unmodifiable(_events);

  void reset() {
    _events.clear();
  }
}

enum StatusState { loading, success, error }

class StatusCardFactory {
  static Widget create(StatusState state, {String? message}) {
    return switch (state) {
      StatusState.loading => const ListTile(
          leading: CircularProgressIndicator(),
          title: Text('Loading'),
          subtitle: Text('Fetching latest API result'),
        ),
      StatusState.success => ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.green),
          title: const Text('Success'),
          subtitle: Text(message ?? 'Operation completed'),
        ),
      StatusState.error => ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: const Text('Error'),
          subtitle: Text(message ?? 'Something went wrong'),
        ),
    };
  }
}

sealed class ApiPayload {
  const ApiPayload();
}

class UserPayload extends ApiPayload {
  const UserPayload(this.name, this.email);

  final String name;
  final String email;
}

class ErrorPayload extends ApiPayload {
  const ErrorPayload(this.message);

  final String message;
}

class UnknownPayload extends ApiPayload {
  const UnknownPayload(this.raw);

  final Map<String, dynamic> raw;
}

class ApiPayloadFactory {
  static ApiPayload parse(Map<String, dynamic> json) {
    final type = json['type'];
    if (type == 'user') {
      return UserPayload(
        json['name']?.toString() ?? 'Unknown',
        json['email']?.toString() ?? 'missing@example.com',
      );
    }
    if (type == 'error') {
      return ErrorPayload(json['message']?.toString() ?? 'Unknown API error');
    }
    return UnknownPayload(json);
  }
}

class PatternShowcasePage extends StatefulWidget {
  const PatternShowcasePage({super.key});

  @override
  State<PatternShowcasePage> createState() => _PatternShowcasePageState();
}

class _PatternShowcasePageState extends State<PatternShowcasePage> {
  StatusState _state = StatusState.loading;
  String _message = 'Waiting for action';
  late ApiPayload _payload;

  @override
  void initState() {
    super.initState();
    LoggerService().log('App started');
    AnalyticsService().track('app_started');
    _payload = ApiPayloadFactory.parse(
      const {
        'type': 'user',
        'name': 'Aruzhan',
        'email': 'student@example.com',
      },
    );
  }

  void _loadSuccess() {
    LoggerService().log('Success state requested');
    AnalyticsService().track('success_viewed');
    setState(() {
      _state = StatusState.success;
      _message = 'Factory produced a success widget';
      _payload = ApiPayloadFactory.parse(
        const {
          'type': 'user',
          'name': 'Flutter Student',
          'email': 'homework@course.dev',
        },
      );
    });
  }

  void _loadError() {
    LoggerService().log('Error state requested');
    AnalyticsService().track('error_viewed');
    setState(() {
      _state = StatusState.error;
      _message = 'Factory produced an error widget';
      _payload = ApiPayloadFactory.parse(
        const {'type': 'error', 'message': 'API request failed with 500'},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final logs = LoggerService().entries;
    final events = AnalyticsService().events;

    return Scaffold(
      appBar: AppBar(title: const Text('Lesson 37: Design Patterns')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: StatusCardFactory.create(_state, message: _message)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: _loadSuccess,
                child: const Text('Show success'),
              ),
              FilledButton.tonal(
                onPressed: _loadError,
                child: const Text('Show error'),
              ),
              OutlinedButton(
                onPressed: () {
                  LoggerService().log('Loading state requested');
                  AnalyticsService().track('loading_viewed');
                  setState(() {
                    _state = StatusState.loading;
                    _message = 'Factory produced a loading widget';
                  });
                },
                child: const Text('Show loading'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Parsed API payload',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.data_object),
              title: Text(_describePayload(_payload)),
              subtitle: const Text('Created via factory based on response type'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Analytics singleton',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...events.entries.map(
            (entry) => Card(
              child: ListTile(
                leading: const Icon(Icons.query_stats),
                title: Text(entry.key),
                trailing: Text(entry.value.toString()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Logger singleton',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...logs.take(6).map(
            (entry) => Card(
              child: ListTile(
                dense: true,
                title: Text(entry),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _describePayload(ApiPayload payload) {
    return switch (payload) {
      UserPayload(:final name, :final email) => 'User payload: $name <$email>',
      ErrorPayload(:final message) => 'Error payload: $message',
      UnknownPayload(:final raw) => 'Unknown payload: $raw',
    };
  }
}
