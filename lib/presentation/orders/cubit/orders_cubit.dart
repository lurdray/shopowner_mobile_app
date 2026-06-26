import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/data/models/order_model.dart';
import 'package:shopowner_mobile_app/data/repositories/order_repository.dart';

class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? errorMsg;
  final String filter;
  final String search;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMsg,
    this.filter = 'All',
    this.search = '',
  });

  List<OrderModel> get visible {
    return orders.where((o) {
      final matchStatus = filter == 'All' || o.status == filter;
      final q = search.toLowerCase();
      final matchSearch = search.isEmpty ||
          o.customer.toLowerCase().contains(q) ||
          o.id.toLowerCase().contains(q);
      return matchStatus && matchSearch;
    }).toList();
  }

  int get pendingCount => orders.where((o) => o.status == 'Pending').length;

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? errorMsg,
    bool clearError = false,
    String? filter,
    String? search,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMsg: clearError ? null : errorMsg ?? this.errorMsg,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState());

  final _repo = OrderRepository();

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final orders = await _repo.list();
      emit(state.copyWith(orders: orders, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMsg: ApiClient.messageFromError(e),
      ));
    }
  }

  void setFilter(String filter) => emit(state.copyWith(filter: filter));
  void setSearch(String search) => emit(state.copyWith(search: search));

  Future<OrderModel> detail(int pk) => _repo.detail(pk);

  Future<bool> updateStatus(int pk, String status) async {
    try {
      final updated = await _repo.updateStatus(pk, status);
      emit(state.copyWith(
        orders: state.orders
            .map((o) => o.pk == pk
                ? OrderModel(
                    pk: o.pk,
                    id: o.id,
                    customer: o.customer,
                    items: o.items,
                    total: o.total,
                    date: o.date,
                    status: updated.status,
                  )
                : o)
            .toList(),
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(errorMsg: ApiClient.messageFromError(e)));
      return false;
    }
  }
}
