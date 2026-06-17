import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/presentation/auth/models/auth_model.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<void> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await Future.delayed(const Duration(seconds: 2));
      final model = AuthModel(
        id: '1',
        email: email,
        name: 'Shop Owner',
        shopName: 'My Shop',
        token: 'mock_token_123',
      );
      emit(state.copyWith(authModel: model, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMsg: e.toString()));
      showScaffoldSnackBar(context, text: 'Sign in failed: ${e.toString()}');
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
      await Future.delayed(const Duration(seconds: 2));
      final model = AuthModel(
        id: '1',
        email: email,
        shopName: shopName,
        market: market,
        subMarket: subMarket,
        country: country,
        state: countryState,
        token: 'mock_token_123',
      );
      emit(state.copyWith(authModel: model, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMsg: e.toString()));
      showScaffoldSnackBar(context, text: 'Sign up failed: ${e.toString()}');
    }
  }

  Future<void> logout(BuildContext context) async {
    emit(const AuthState());
  }

  void updateProfile(AuthModel updated) {
    emit(state.copyWith(authModel: updated));
  }
}
