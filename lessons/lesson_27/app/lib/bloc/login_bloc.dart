import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    // Обработка изменения email
    on<EmailChanged>(_onEmailChanged);

    // Обработка изменения пароля
    on<PasswordChanged>(_onPasswordChanged);

    // Обработка отправки формы
    on<LoginSubmitted>(_onLoginSubmitted);

    // Обработка сброса формы
    on<LoginReset>(_onLoginReset);
  }

  // Валидация email
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email не может быть пустым';
    }
    // Простая проверка формата email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Неверный формат email';
    }
    return null;
  }

  // Валидация пароля
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Пароль не может быть пустым';
    }
    if (password.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  // Обработчик изменения email
  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final emailError = _validateEmail(event.email);
    emit(
      state.copyWith(
        email: event.email,
        emailError: emailError,
        status: LoginStatus.initial,
      ),
    );
  }

  // Обработчик изменения пароля
  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final passwordError = _validatePassword(event.password);
    emit(
      state.copyWith(
        password: event.password,
        passwordError: passwordError,
        status: LoginStatus.initial,
      ),
    );
  }

  // Обработчик отправки формы
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Валидация всех полей
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          status: LoginStatus.error,
          errorMessage: 'Исправьте ошибки в форме',
        ),
      );
      return;
    }

    // Состояние загрузки
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      // Имитация запроса к API
      await Future.delayed(const Duration(seconds: 2));

      // Симуляция проверки учётных данных
      if (state.email == 'test@example.com' &&
          state.password == 'password123') {
        emit(state.copyWith(status: LoginStatus.success, errorMessage: null));
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.error,
            errorMessage: 'Неверный email или пароль',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: 'Ошибка подключения: ${e.toString()}',
        ),
      );
    }
  }

  // Обработчик сброса формы
  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(LoginState.initial());
  }
}
