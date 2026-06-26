import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/data/models/product_model.dart';
import 'package:shopowner_mobile_app/data/repositories/product_repository.dart';

class ProductsState {
  final List<ProductModel> products;
  final bool isLoading;
  final String? errorMsg;
  final String filter;
  final String search;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.errorMsg,
    this.filter = 'All',
    this.search = '',
  });

  List<ProductModel> get visible {
    return products.where((p) {
      final matchFilter = filter == 'All' || p.status == filter;
      final matchSearch =
          search.isEmpty || p.name.toLowerCase().contains(search.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

  ProductsState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? errorMsg,
    bool clearError = false,
    String? filter,
    String? search,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMsg: clearError ? null : errorMsg ?? this.errorMsg,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsState());

  final _repo = ProductRepository();

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final products = await _repo.list();
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMsg: ApiClient.messageFromError(e),
      ));
    }
  }

  void setFilter(String filter) => emit(state.copyWith(filter: filter));
  void setSearch(String search) => emit(state.copyWith(search: search));

  Future<bool> addProduct({
    required String name,
    required double price,
    required int stock,
    required String category,
    String description = '',
    String? imagePath,
  }) async {
    try {
      await _repo.create(
        name: name,
        price: price,
        stock: stock,
        category: category,
        description: description,
        imagePath: imagePath,
      );
      await load();
      return true;
    } catch (e) {
      emit(state.copyWith(errorMsg: ApiClient.messageFromError(e)));
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _repo.delete(id);
      emit(state.copyWith(
        products: state.products.where((p) => p.id != id).toList(),
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(errorMsg: ApiClient.messageFromError(e)));
      return false;
    }
  }
}
