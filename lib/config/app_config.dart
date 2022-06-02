import 'package:courierone/locale/arabic.dart';
import 'package:courierone/locale/english.dart';
import 'package:courierone/locale/french.dart';
import 'package:courierone/locale/indonesia.dart';
import 'package:courierone/locale/italian.dart';
import 'package:courierone/locale/portuguese.dart';
import 'package:courierone/locale/spanish.dart';
import 'package:courierone/locale/swahili.dart';
import 'package:courierone/locale/turkey.dart';

class AppConfig {
  static final String appName = "Olad";
  static const String packageName = "com.olad.org";
  static const String baseUrl = 'https://olad.org/';
  static final String oneSignalAppId = "d161b91d-84a6-407d-ab36-82453c1ac402";
  static const String mapsApiKey = 'AIzaSyBCjJGTp__kOJb2mMUsBeKQkuOlwbiJipQ';
  static final bool isDemoMode = false;
  static final String languageDefault = "en";
  static final Map<String, AppLanguage> languagesSupported = {
    'en': AppLanguage("English", english()),
    'ar': AppLanguage("عربى", arabic()),
    'pt': AppLanguage("Portugal", portuguese()),
    'fr': AppLanguage("Français", french()),
    'id': AppLanguage("Bahasa Indonesia", indonesian()),
    'es': AppLanguage("Español", spanish()),
    'it': AppLanguage("italiano", italian()),
    'sw': AppLanguage("Kiswahili", swahili()),
    'tr': AppLanguage("Türk", turkey()),
  };
}

class AppLanguage {
  final String name;
  final Map<String, String> values;

  AppLanguage(this.name, this.values);
}

class HeaderKeys {
  static const String authHeaderKey = "Authorization";
  static const String noAuthHeaderKey = 'NoAuth';
}
