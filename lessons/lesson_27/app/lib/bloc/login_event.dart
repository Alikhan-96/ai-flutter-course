import 'package:equatable/equatable.dart';

// События для логина
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// Событие изменения email
class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

// Событие изменения пароля
class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

// Событие отправки формы
class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

// Событие сброса формы
class LoginReset extends LoginEvent {
  const LoginReset();
}
