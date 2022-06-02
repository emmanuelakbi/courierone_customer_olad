import 'package:country_code_picker/country_localizations.dart';
import 'package:courierone/authentication/bloc/auth_bloc.dart';
import 'package:courierone/authentication/bloc/auth_event.dart';
import 'package:courierone/authentication/bloc/auth_state.dart';
import 'package:courierone/authentication/login_navigator.dart';
import 'package:courierone/bottom_navigation/bottom_navigation.dart';
import 'package:courierone/language_cubit.dart';
import 'package:courierone/locale/locales.dart';
import 'package:courierone/network/one_signal_config.dart';
import 'package:courierone/routes/routes.dart';
import 'package:courierone/second_splash_screen.dart';
import 'package:courierone/theme/colors.dart';
import 'package:courierone/theme/style.dart';
import 'package:courierone/utility_functions/bloc_delegate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:simple_moment/simple_moment.dart';

import 'bottom_navigation/account/language_page.dart';
import 'utils/moment_locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp();
  await OneSignalConfig.initOneSignal();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kTransparentColor,
      statusBarIconBrightness: Brightness.dark));
  Moment.setLocaleGlobally(ShortLocaleEn());
  runApp(
    Phoenix(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(AppStarted()),
          ),
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit()..getCurrentLanguage(),
          )
        ],
        child: CourierOne(),
      ),
    ),
  );
}

class CourierOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) => MaterialApp(
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: AppLocalizations.getSupportedLocales(),
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          locale: locale,
          home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            print("state.runtimeType: ${state.runtimeType}");
            switch (state.runtimeType) {
              case Initialized:
                return LanguagePage(true);
              case Unauthenticated:
                return LoginNavigator();
              case Authenticated:
                return BottomNavigation();
              default:
                return SecondSplashScreen();
            }
          }),
          routes: PageRoutes().routes(),
        ),
      );
}
