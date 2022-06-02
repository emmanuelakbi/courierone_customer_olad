import 'package:courierone/models/auth/responses/login_response.dart';

class AuthResponseSocial {
  String userName;
  String userEmail;
  String userImageUrl;
  LoginResponse authResponse;

  AuthResponseSocial(
      this.userName, this.userEmail, this.userImageUrl, this.authResponse);

  @override
  String toString() {
    return 'AuthResponseSocial(userName: $userName, userEmail: $userEmail, userImageUrl: $userImageUrl, authResponse: $authResponse)';
  }
}
