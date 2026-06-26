import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/data/models/dashboard_model.dart';
import 'package:shopowner_mobile_app/data/repositories/dashboard_repository.dart';

class DashboardState {
  final DashboardModel? data;
  final bool isLoading;
  final String? errorMsg;

  const DashboardState({this.data, this.isLoading = false, this.errorMsg});

  DashboardState copyWith({
    DashboardModel? data,
    bool? isLoading,
    String? errorMsg,
    bool clearError = false,
  }) {
    return DashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMsg: clearError ? null : errorMsg ?? this.errorMsg,
    );
  }
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  final _repo = DashboardRepository();

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final data = await _repo.fetch();
      emit(state.copyWith(data: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMsg: ApiClient.messageFromError(e),
      ));
    }
  }
}
