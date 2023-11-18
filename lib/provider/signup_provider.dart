import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';
import 'package:flutter_todo_app/state/states.dart';

class SignupProvider extends BaseChangeNotifier {
  Future<void> saveData(String email) async {
    try {
      loadingState();
      await CustomSharedPrefrences.setString(StorageKeys.email, email);

      loadedState();
    } catch (e) {
      failureState(e.toString());
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
