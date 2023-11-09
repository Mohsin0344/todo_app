import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todos_app/routes/app_routes.dart';
import 'package:todos_app/utils/app_colors.dart';
import 'package:todos_app/utils/app_fonts.dart';
import 'package:todos_app/utils/app_strings.dart';

import 'firebase_options.dart';
import 'view_models/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.primaryColor,
                centerTitle: true,
              ),
              textTheme: TextTheme(
                bodyLarge: AppFonts.bodyFont(
                  color: AppColors.primaryColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
                titleLarge: AppFonts.bodyFont(
                  color: AppColors.textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
                bodyMedium: AppFonts.bodyFont(
                  color: AppColors.successColor,
                  fontSize: 16.sp,
                ),
                bodySmall: AppFonts.bodyFont(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ),
            onGenerateRoute: AppRoutes().generateRoute,
          );
        },
      ),
    );
  }
}
