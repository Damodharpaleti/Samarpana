import 'package:flutter/widgets.dart';

class LoaderProvider with ChangeNotifier {
  bool _isApiCallProcess = false;
  bool get isApiCallPocess => _isApiCallProcess;
  setLoadingStatus(bool status) {
    _isApiCallProcess = status;
    notifyListeners();
  }
}
