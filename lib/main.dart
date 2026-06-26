import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopowner_mobile_app/app_bloc_providers.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/theme/theme_config.dart';
import 'package:shopowner_mobile_app/presentation/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Persist auth (token + shop) across restarts so the user stays signed in.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  runApp(
    MultiBlocProvider(
      providers: AppBlocProviders.blocProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(
      const AssetImage(AppAssets.ASSETS_IMAGES_SPLASH_BG_JPG),
      context,
    );
    precacheImage(
      const AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
      context,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;
        return ScreenUtilInit(
          designSize: Size(
            screenWidth == 0 ? 390 : screenWidth,
            screenHeight == 0 ? 844 : screenHeight,
          ),
          minTextAdapt: true,
          useInheritedMediaQuery: true,
          child: MaterialApp(
            title: 'ShopOwner',
            debugShowCheckedModeBanner: false,
            theme: appLightTheme,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
