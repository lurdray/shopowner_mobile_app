import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopowner_mobile_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:shopowner_mobile_app/presentation/dashboard/cubit/dashboard_cubit.dart';
import 'package:shopowner_mobile_app/presentation/home/cubit/home_cubit.dart';
import 'package:shopowner_mobile_app/presentation/orders/cubit/orders_cubit.dart';
import 'package:shopowner_mobile_app/presentation/products/cubit/products_cubit.dart';

class AppBlocProviders {
  static List<BlocProvider> get blocProviders => [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),
        BlocProvider<ProductsCubit>(
          create: (context) => ProductsCubit(),
        ),
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit(),
        ),
        BlocProvider<DashboardCubit>(
          create: (context) => DashboardCubit(),
        ),
      ];
}
