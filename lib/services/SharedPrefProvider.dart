import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefProvider {
  bool _firstTime;
  int _version;

  bool get firstTime => _firstTime;
  int get version => _version;

  SharedPrefProvider._private();
  static final SharedPrefProvider _singleInstance =
      SharedPrefProvider._private();
  static SharedPrefProvider get instance => _singleInstance;

  Future<void> initialize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _firstTime = sharedPreferences.containsKey('firstTime') ? false : true;
    if (sharedPreferences.containsKey('version')) {
      _version = sharedPreferences.getInt('version');
    }
  }

  Future<void> setfirstTimeFalse() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('firstTime', false);
    _firstTime = false;
  }

  Future<void> setVersion(int version) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('version', version);
    _version = version;
  }
}
