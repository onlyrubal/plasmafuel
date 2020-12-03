import 'package:flutter/material.dart';
import './screens/donor_submission_screen.dart';
import 'package:provider/provider.dart';
import './screens/tabs_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import './screens/favorite_screen.dart';
import 'screens/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import './providers/donor_info.dart';
import './providers/covid_tracker.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import 'notifiers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Donors(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CovidTrackers(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider<MultipleNotifier>(
          create: (_) => MultipleNotifier([]),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Plasma Fuel',
          theme: ThemeData(
            brightness: Brightness.light,
            accentColor: const Color(0xff0d47a1),
            primaryColor: const Color(0xffbc2738),
            textTheme:
                GoogleFonts.muliTextTheme(Theme.of(context).textTheme).copyWith(
              bodyText1: GoogleFonts.muli(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              bodyText2: GoogleFonts.muli(
                textStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle1: GoogleFonts.muli(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle2: GoogleFonts.muli(
                textStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              headline1: GoogleFonts.muli(
                textStyle: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                ),
              ),
              headline2: GoogleFonts.muli(
                textStyle: TextStyle(
                  fontSize: 22,
                ),
              ),
              headline5: GoogleFonts.muli(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          home: auth.isAuth ? TabsScreen() : AuthScreen(),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            DonorSubmissionScreen.routeName: (ctx) => DonorSubmissionScreen(),
          },
        ),
      ),
    );
  }
}
