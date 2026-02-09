import 'package:securite_mobile/model/auth/session_token.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/services/user_service.dart';

class Session {
  final User user;
  final SessionToken token;

  Session({required this.user, required this.token});
}

class SessionModel {
  static final SessionModel _instance = SessionModel._internal();

  factory SessionModel() => _instance;

  SessionModel._internal();

  final _userModel = UserModel();

  Session? session;

  Future<bool> get isLoggedIn async {
    final token = await SessionTokenModel.getTokens();
    return token != null;
  }

  Future<void> createSession(User user, SessionToken token) async {
    await SessionTokenModel.storeTokens(token);
    await _userModel.saveUserToCache(user);
    session = Session(user: user, token: token);
  }

  Future<void> destroySession() async {
    await SessionTokenModel.deleteTokens();
    await _userModel.clearUserFromCache();
  }

  Future<void> resumeSession() async {
    try {
      final sessionToken = await SessionTokenModel.getTokens();
      if (sessionToken == null) {
        return;
      }

      UserServiceResponse userResponse = await _userModel.getUserFromServer();
      if (userResponse.statusCode == 404) {
        SessionTokenModel.deleteTokens();
        _userModel.clearUserFromCache();
        return;
      }

      User? user = userResponse.data?.first;
      user ??= await _userModel.getUserFromCache();

      if (user == null) {
        SessionTokenModel.deleteTokens();
        _userModel.clearUserFromCache();
        return;
      }

      session = Session(user: user, token: sessionToken);
    } catch (e) {
      SessionTokenModel.deleteTokens();
      _userModel.clearUserFromCache();
    }
  }
}
