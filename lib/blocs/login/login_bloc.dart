import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  static final RegExp _emailRegExp =
  RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  static final RegExp _passwordRegExp =
  // at least 8 chars, one uppercase, one lowercase, one digit, one special
  RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&\-\_#^()+=<>]).{8,}$');

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final isValid = _emailRegExp.hasMatch(event.email);
    emit(state.copyWith(email: event.email, isEmailValid: isValid));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final isValid = _passwordRegExp.hasMatch(event.password);
    emit(state.copyWith(password: event.password, isPasswordValid: isValid));
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final isEmailValid = _emailRegExp.hasMatch(state.email);
    final isPasswordValid = _passwordRegExp.hasMatch(state.password);
    if (!isEmailValid || !isPasswordValid) {
      emit(state.copyWith(isEmailValid: isEmailValid, isPasswordValid: isPasswordValid));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));
    await Future.delayed(const Duration(milliseconds: 600)); // simulate auth
    // In this assignment there is no backend. We'll accept any valid credentials.
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }
}
