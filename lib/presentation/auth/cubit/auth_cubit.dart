import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/data/repositories/auth_repository.dart';
import 'package:shopowner_mobile_app/presentation/auth/models/auth_model.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    // Restore the token into the network layer after hydration.
    TokenStore.set(state.authModel?.token);
  }

  final _repo = AuthRepository();

  Future<void> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final model = await _repo.login(email: email, password: password);
      TokenStore.set(model.token);
      emit(state.copyWith(authModel: model, isLoading: false));
    } catch (e) {
      final msg = ApiClient.messageFromError(e);
      emit(state.copyWith(isLoading: false, errorMsg: msg));
      if (context.mounted) {
        showScaffoldSnackBar(context, text: 'Sign in failed: $msg');
      }
    }
  }

  Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
    required String shopName,
    required String market,
    required String subMarket,
    required String country,
    required String countryState,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final model = await _repo.register(
        email: email,
        password: password,
        shopName: shopName,
        market: market,
        subMarket: subMarket,
        country: country,
        state: countryState,
      );
      TokenStore.set(model.token);
      emit(state.copyWith(authModel: model, isLoading: false));
    } catch (e) {
      final msg = ApiClient.messageFromError(e);
      emit(state.copyWith(isLoading: false, errorMsg: msg));
      if (context.mounted) {
        showScaffoldSnackBar(context, text: 'Sign up failed: $msg');
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    await _repo.logout();
    TokenStore.clear();
    emit(const AuthState());
  }

  void updateProfile(AuthModel updated) {
    emit(state.copyWith(authModel: updated));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final model = json['authModel'];
    if (model == null) return const AuthState();
    return AuthState(
      authModel: AuthModel.fromJson(Map<String, dynamic>.from(model)),
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {'authModel': state.authModel?.toJson()};
  }
}
