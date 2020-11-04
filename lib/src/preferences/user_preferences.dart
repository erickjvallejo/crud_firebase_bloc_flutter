import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _intance = new UserPreferences._internal();

  String _token;

  bool _secondaryColor;
  int _genre;
  String _lastPage;

  factory UserPreferences() {
    return _intance;
  }

  UserPreferences._internal();

  SharedPreferences _preferences;

  initPrefs() async {
    this._preferences = await SharedPreferences.getInstance();

    this._token = _preferences.getString('token') ?? '';
    this._lastPage = _preferences.getString('lastPage') ?? 'home';
    this._secondaryColor = _preferences.getBool('secondaryColor') ?? false;
    this._genre = _preferences.getInt('genre') ?? 1;
  }

  // Name
  String get token => _token;

  set token(String value) {
    _preferences.setString('token', value);
    _token = value;
  }

  //Genre
  int get genre => _genre;

  set genre(int value) {
    _preferences.setInt('genre', value);
    _genre = value;
  }

  // Secondary Color
  bool get secondaryColor => _secondaryColor;

  set secondaryColor(bool value) {
    _preferences.setBool('secondaryColor', value);
    _secondaryColor = value;
  }

  //last Page
  String get lastPage => _lastPage;

  set lastPage(String value) {
    _preferences.setString('lastPage', value);
    _lastPage = value;
  }
}
