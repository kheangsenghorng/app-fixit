// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class AuthState {
//   final String? token;
//
//   AuthState({this.token});
//
//   AuthState copyWith({String? token}) {
//     return AuthState(token: token ?? this.token);
//   }
// }
//
// class AuthController extends StateNotifier<AuthState> {
//   AuthController() : super(AuthState());
//
//   void setToken(String token) {
//     state = state.copyWith(token: token);
//   }
//
//   void logout() {
//     state = AuthState();
//   }
// }
//
// final authControllerProvider =
// StateNotifierProvider<AuthController, AuthState>(
//       (ref) => AuthController(),
// );
//
// final authTokenProvider = Provider<String?>(
//       (ref) => ref.watch(authControllerProvider).token,
// );
