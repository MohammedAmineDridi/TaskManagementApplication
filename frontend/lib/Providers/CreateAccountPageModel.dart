import 'package:my_app1/Providers/WelcomePageModel.dart';

class CreateAccountPageModel extends WelcomePageModel {

  bool _photoUsernameSelected = false;

  bool getphotoUsernameSelected() { 
    return _photoUsernameSelected;
  }

  void setphotoUsernameSelected(bool newPhotoName) {
    _photoUsernameSelected = newPhotoName;
    notifyListeners();
  }

}