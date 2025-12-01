import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _globalUserLocation =
          latLngFromString(prefs.getString('ff_globalUserLocation')) ??
              _globalUserLocation;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  LatLng? _globalUserLocation;
  LatLng? get globalUserLocation => _globalUserLocation;
  set globalUserLocation(LatLng? value) {
    _globalUserLocation = value;
    value != null
        ? prefs.setString('ff_globalUserLocation', value.serialize())
        : prefs.remove('ff_globalUserLocation');
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
