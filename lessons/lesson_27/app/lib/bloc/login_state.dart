import 'package:equatable/equatable.dart';

// Статусы формы логина
enum LoginStatus { initial, loading, success, error }

// Состояние формы логина
class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    this.errorMessage,
    this.emailError,
    this.passwordError,
  });

  // Начальное состояние
  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
    );
  }

  // Копирование состояния с изменениями
  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? errorMessage,
    String? emailError,
    String? passwordError,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  // Проверка валидности формы
  bool get isValid => emailError == null && passwordError == null;

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    errorMessage,
    emailError,
    passwordError,
  ];
}
