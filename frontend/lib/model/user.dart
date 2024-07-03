class User {
  
  late int _userId;
  late String _username;
  late String _email;
  late String _password;
  late int _phoneNumber;
  late String _photoPath;
  
  User(String username, String email, String password, int phoneNumber, String photoPath) {
    _username = username;
    _email = email;
    _password = password;
    _phoneNumber = phoneNumber;
    _photoPath = photoPath;
  }

  int getuserId() {
    return _userId;
  }

  String getuserName() {
    return _username;
  }

  String getemail() {
    return _email;
  }

  String getpassword() {
    return _password;
  }

  int getphoneNumber() {
    return _phoneNumber;
  }

  String getphotoPath() {
    return _photoPath;
  }

  void setuserId(int userId) {
    _userId = userId;
  }

  void setuserName(String username) {
    _username = username;
  }

  void setemail(String email) {
    _email = email;
  }

  void setpassword(String password) {
    _password = password;
  }

  void setphoneNumber(int phoneNumber) {
    _phoneNumber = phoneNumber;
  }
  
  void setphotoPath(String photoPath) {
    _photoPath = photoPath;
  }

}