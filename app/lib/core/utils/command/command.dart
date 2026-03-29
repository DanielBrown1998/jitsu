// TODO: Commands for auth screen.
import 'package:flutter/material.dart';

class CommandInput {}

abstract class Command<T extends CommandInput> extends ChangeNotifier {
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  Exception? get error => _error;
  Exception? _error;

  final Future<void> Function(T) action;

  Command(this.action);

  Future<void> execute({required T input}) async {
    if (_isRunning) return;
    _isRunning = true;
    notifyListeners();

    try {
      await action(input);
    } catch (e) {
      _error = e is Exception ? e : Exception(e.toString());
      notifyListeners();
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }

  void clear() {
    _error = null;
    _isRunning = false;
    notifyListeners();
  }
}
