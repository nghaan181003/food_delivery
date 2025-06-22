import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/bindings/general_bindings.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/login_screen.dart';
import 'package:food_delivery_h2d/routes/app_routes.dart';
import 'package:food_delivery_h2d/utils/themes/theme.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GeneralBindings(),
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      getPages: kIsWeb ? AppRoutes.pages : [],
      title: "H2D Delivery",
      //navigatorObservers: [RouteObserver()],
      locale: const Locale('vi'),
      supportedLocales: const [
        Locale('en'), // English
        Locale('vi'), // Vietnamese
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}
