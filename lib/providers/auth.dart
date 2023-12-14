import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/services/center.dart';
import 'package:hirome_rental_center_web/services/messaging.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  FirebaseAuth? auth;
  User? _authUser;
  User? get authUser => _authUser;
  CenterService centerService = CenterService();
  MessagingService messagingService = MessagingService();

  TextEditingController loginId = TextEditingController();
  TextEditingController password = TextEditingController();

  void clearController() {
    loginId.clear();
    password.clear();
  }

  AuthProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> signIn() async {
    String? error;
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      String token = await messagingService.getToken();
      await auth?.signInAnonymously().then((value) async {
        _authUser = value.user;
        if (loginId.text == 'syokki' && password.text == 'hirome0101') {
          await setPrefsString('loginId', 'syokki');
          centerService.create({
            'id': value.user?.uid,
            'token': token,
            'createdAt': DateTime.now(),
          });
        } else {
          await auth?.signOut();
          error = 'ログインに失敗しました';
        }
      });
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }
    return error;
  }

  Future signOut() async {
    await auth?.signOut();
    _status = AuthStatus.unauthenticated;
    await removePrefs('loginId');
    centerService.delete({'id': _authUser?.uid});
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      String? tmpLoginId = await getPrefsString('loginId');
      if (tmpLoginId == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _status = AuthStatus.authenticated;
        String token = await messagingService.getToken();
        centerService.update({
          'id': _authUser?.uid,
          'token': token,
        });
      }
    }
    notifyListeners();
  }
}
