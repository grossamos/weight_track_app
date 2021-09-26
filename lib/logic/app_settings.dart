import 'package:localstorage/localstorage.dart';

class AppSettings {
  static const SMART_LOGGING_KEY = 'smartLoggingIsEnabled';
  static const SMART_LOGGING_DEFAULT = false;
  
  static bool _isInitialized = SMART_LOGGING_DEFAULT;
  static bool _smartLoggingIsEnabled;
  static final LocalStorage _storage = new LocalStorage('app_settings.json');

  static Future<void> initialize() async {
    if (_isInitialized)
      return;

    await _storage.ready;

    bool tmpSmartLoggingIsEnabled = _storage.getItem(SMART_LOGGING_KEY);
    if (tmpSmartLoggingIsEnabled == null) {
      _storage.setItem(SMART_LOGGING_KEY, SMART_LOGGING_DEFAULT);
      tmpSmartLoggingIsEnabled = false;
    }
    _smartLoggingIsEnabled = tmpSmartLoggingIsEnabled;

    _isInitialized = true;
  }

  static bool get smartLoggingIsEnabled {
    if (_isInitialized)
      return _smartLoggingIsEnabled;
    else {
      // just give a harmless default, let's hope this is okay
      initialize();
      return SMART_LOGGING_DEFAULT;
    }
  }

  static set smartLoggingIsEnabled(bool value) {
    _storage.setItem(SMART_LOGGING_KEY, value);
    _smartLoggingIsEnabled = value;
  }
}