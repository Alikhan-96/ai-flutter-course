import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  setUp(() {
    LoggerService().reset();
    AnalyticsService().reset();
  });

  test('LoggerService returns the same instance', () {
    expect(identical(LoggerService(), LoggerService()), isTrue);
  });

  test('AnalyticsService returns the same instance', () {
    expect(identical(AnalyticsService(), AnalyticsService()), isTrue);
  });

  test('LoggerService shares state across repeated calls', () {
    final loggerA = LoggerService();
    final loggerB = LoggerService();

    loggerA.log('first message');

    expect(loggerB.entries, hasLength(1));
    expect(loggerB.entries.single, contains('first message'));
  });

  test('AnalyticsService shares counters across repeated calls', () {
    final analyticsA = AnalyticsService();
    final analyticsB = AnalyticsService();

    analyticsA.track('button_clicked');

    expect(analyticsB.events['button_clicked'], 1);
  });

  test('ApiPayloadFactory parses user and error responses by type', () {
    final userPayload = ApiPayloadFactory.parse(
      const {
        'type': 'user',
        'name': 'Student',
        'email': 'student@example.com',
      },
    );
    final errorPayload = ApiPayloadFactory.parse(
      const {'type': 'error', 'message': 'Request failed'},
    );

    expect(userPayload, isA<UserPayload>());
    expect(errorPayload, isA<ErrorPayload>());
  });
}
