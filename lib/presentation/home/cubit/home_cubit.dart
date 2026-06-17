import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState {
  final int activeIndex;

  const HomeState({this.activeIndex = 0});

  HomeState copyWith({int? activeIndex}) {
    return HomeState(activeIndex: activeIndex ?? this.activeIndex);
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(int index) => emit(state.copyWith(activeIndex: index));
}
