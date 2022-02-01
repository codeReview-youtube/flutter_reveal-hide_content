import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _selectedReveal = 0;

  int get selectedReveal => _selectedReveal;
  bool get isRevealEnabled => _selectedReveal != 0;

  void onSwitch(int choice) {
    _selectedReveal = choice;
    notifyListeners();
  }

  String get selectedChoice => _selectedReveal == 1
      ? 'onDoubleTap'
      : _selectedReveal == 2
          ? 'onLongPress'
          : '';

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('SelectedReveal', _selectedReveal));
  }
}
