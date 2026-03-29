import 'package:app/core/utils/command/command.dart';

class LoginInput extends CommandInput {
  final String email;
  final String password;

  LoginInput(this.email, this.password);
}

class LoginCommand extends Command<LoginInput> {
  LoginCommand(super.action);
}

class RegisterInput extends CommandInput {
  final String email;
  final String password;

  RegisterInput(this.email, this.password);
}

class RegisterCommand extends Command<RegisterInput> {
  RegisterCommand(super.action);
}

class LogoutInput extends CommandInput {}

class LogoutCommand extends Command<LogoutInput> {
  LogoutCommand(super.action);
}

class RecoverPasswordInput extends CommandInput {
  final String email;

  RecoverPasswordInput(this.email);
}

class RecoverPasswordCommand extends Command<RecoverPasswordInput> {
  RecoverPasswordCommand(super.action);
}
