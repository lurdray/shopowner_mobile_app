import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopowner_mobile_app/core/enums/route_enum.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/presentation/auth/auth_screen.dart';
import 'package:shopowner_mobile_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';
import 'package:shopowner_mobile_app/presentation/home/home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.isAuthenticated != curr.isAuthenticated,
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.pushAndRemoveUntil(
            const HomePage(),
            transition: RouteTransition.fadeIn,
          );
        } else {
          context.pushAndRemoveUntil(
            const AuthGatewayScreen(),
            transition: RouteTransition.fadeIn,
          );
        }
      },
      builder: (context, state) {
        if (state.isAuthenticated) return const HomePage();
        return const AuthGatewayScreen();
      },
    );
  }
}
