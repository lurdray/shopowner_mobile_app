import 'package:shopowner_mobile_app/presentation/auth/models/auth_model.dart';

class AuthState {
  final AuthModel? authModel;
  final bool isLoading;
  final String? errorMsg;

  const AuthState({
    this.authModel,
    this.isLoading = false,
    this.errorMsg,
  });

  bool get isAuthenticated => authModel != null;

  AuthState copyWith({
    AuthModel? authModel,
    bool? isLoading,
    String? errorMsg,
    bool clearError = false,
    bool clearAuth = false,
  }) {
    return AuthState(
      authModel: clearAuth ? null : authModel ?? this.authModel,
      isLoading: isLoading ?? this.isLoading,
      errorMsg: clearError ? null : errorMsg ?? this.errorMsg,
    );
  }
}
