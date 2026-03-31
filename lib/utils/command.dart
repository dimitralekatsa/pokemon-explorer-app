import 'package:flutter/foundation.dart';

class Command0 extends ChangeNotifier {
  final Future<void> Function() _action;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  Exception? _error;
  bool get hasError => _error != null;
  Exception? get error => _error;

  Command0(this._action);

  Future<void> execute() async {
    if (_isRunning) return;

    _isRunning = true;
    _error = null;
    notifyListeners();

    try {
      await _action();
    } on Exception catch (e) {
      _error = e;
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }
}

class Command1<A> extends ChangeNotifier {
  final Future<void> Function(A) _action;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  Exception? _error;
  bool get hasError => _error != null;
  Exception? get error => _error;

  Command1(this._action);

  Future<void> execute(A argument) async {
    if (_isRunning) return;

    _isRunning = true;
    _error = null;
    notifyListeners();

    try {
      await _action(argument);
    } on Exception catch (e) {
      _error = e;
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }
}
