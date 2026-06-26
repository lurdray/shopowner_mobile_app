import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';
import 'package:shopowner_mobile_app/presentation/dashboard/cubit/dashboard_cubit.dart';
import 'package:shopowner_mobile_app/presentation/dashboard/dashboard_page.dart';
import 'package:shopowner_mobile_app/presentation/home/cubit/home_cubit.dart';
import 'package:shopowner_mobile_app/presentation/orders/cubit/orders_cubit.dart';
import 'package:shopowner_mobile_app/presentation/orders/orders_page.dart';
import 'package:shopowner_mobile_app/presentation/products/cubit/products_cubit.dart';
import 'package:shopowner_mobile_app/presentation/products/products_page.dart';
import 'package:shopowner_mobile_app/presentation/profile/profile_page.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load shop data once the owner is in the app.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardCubit>().load();
      context.read<ProductsCubit>().load();
      context.read<OrdersCubit>().load();
    });
  }

  final List<Widget> _pages = const [
    DashboardPage(),
    ProductsPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  final List<IconData> _icons = [
    Icons.dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.shopping_bag_outlined,
    CupertinoIcons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (!state.isAuthenticated) {
          showScaffoldSnackBar(context, text: 'You have been logged out');
        }
      },
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: ScaleIndexedStack(
              beginScale: 0.0,
              index: _activeIndex,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 250),
              children: _pages,
            ),
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
              blurEffect: true,
              height: 80,
              elevation: 10,
              backgroundColor: AppColors.primaryClr,
              itemCount: _icons.length,
              tabBuilder: (index, isActive) {
                return Transform.scale(
                  scale: 0.7,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secClr),
                    ),
                    child: CircleAvatar(
                      backgroundColor:
                          isActive ? AppColors.secClr : Colors.transparent,
                      child: Icon(
                        _icons[index],
                        color: _activeIndex == index
                            ? AppColors.primaryClr
                            : AppColors.secClr,
                        size: 35,
                      ),
                    ),
                  ),
                );
              },
              gapLocation: GapLocation.none,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              activeIndex: _activeIndex,
              onTap: (value) {
                setState(() => _activeIndex = value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
