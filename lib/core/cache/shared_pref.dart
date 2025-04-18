import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();

  factory SharedPrefService() => _instance;

  SharedPrefService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // 🔐 Write methods
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  // 🔓 Read methods
  String? getString(String key) => _prefs?.getString(key);

  bool? getBool(String key) => _prefs?.getBool(key);

  int? getInt(String key) => _prefs?.getInt(key);

  double? getDouble(String key) => _prefs?.getDouble(key);

  // 🧼 Remove specific or clear all
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}

extension FocusTimePrefs on SharedPrefService {
  static final String _focusTimesKey = 'focus_times';

  Future<void> setFocusTimes(List<int> times) async {
    final List<String> stringList = times.map((e) => e.toString()).toList();
    await _prefs?.setStringList(_focusTimesKey, stringList);
  }

  List<int> getFocusTimes() {
    final defaultTimes = [5, 10, 15, 20, 25, 30, 45];
    final stored = _prefs?.getStringList(_focusTimesKey);
    if (stored == null || stored.isEmpty) {
      return defaultTimes;
    }
    final all =
        stored.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
    final uniqueTimes =
        {...defaultTimes, ...all}.toList(); // دمج الاتنين بدون تكرار
    uniqueTimes.sort();
    return uniqueTimes;
  }

  Future<void> addFocusTime(int time) async {
    final current = getFocusTimes();
    if (!current.contains(time)) {
      current.add(time);
      current.sort();
      await setFocusTimes(current);
    }
  }
}
