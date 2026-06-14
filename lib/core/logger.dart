class Logger {
  const Logger();

  void info(String message) {
    _write(message);
  }

  void success(String message) {
    _write('[OK] $message');
  }

  void error(String message) {
    _write('[ERROR] $message');
  }

  void detail(String message) {
    _write('  $message');
  }

  void _write(String message) {
    // ignore: avoid_print
    print(message);
  }
}
