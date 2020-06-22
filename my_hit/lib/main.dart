import 'package:flutter/material.dart';
import './screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

import './screens/personal_info_screen.dart';
import './screens/tabs_screen.dart';
import './screens/event_details_screen.dart';
import './screens/canteen_screen.dart';
import './screens/timetable_screen.dart';
import './screens/events_screen.dart';
import './screens/accomodation_screen.dart';
import './screens/query_details_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/accommodation_summary_screen.dart';
import './providers/auth.dart';
import './providers/user_provider.dart';
import './screens/splash_screen.dart';
import './providers/timetable_provider.dart';
import './providers/query_provider.dart';
import './providers/events_provider.dart';
import './providers/accomodation_provider.dart';
import './providers/canteen_provider.dart';
import './screens/canteen_summary_screen.dart';
import './screens/canteen_purchase_screen.dart';
import './screens/canteen_make_payment.dart';
import './screens/canteen_buy_meal.dart';

void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // another way of registering a provider
        // ChangeNotifierProvider<UserProvider>(
        //     create: (context) => UserProvider()),
        //   can be used for authentication
        // ProxyProvider(update: (BuildContext context, userProvider, auth)=>Auth(''),),
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: Timetable()),
        ChangeNotifierProvider.value(value: Queryrovider()),
        ChangeNotifierProvider.value(value: EventsProvider()),
        ChangeNotifierProvider.value(value: AccomodationProvider()),
        ChangeNotifierProvider.value(value: CanteenProvider()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: Color(0xff00135D), primaryColor: Color(0xffFFB400)),
          home: auth.auth
              ? DashboardScreen()
              : FutureBuilder(
                  future: auth.tryAutologin(),
                  builder: (ctx, authDataSnapshot) =>
                      authDataSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            PersonalInfoScreen.namedRoute: (ctx) => PersonalInfoScreen(),
            TabsScreen.namedRoute: (ctx) => TabsScreen(),
            CanteenScreen.namedRoute: (ctx) => CanteenScreen(),
            TimetableScreen.namedRoute: (ctx) => TimetableScreen(),
            EventsScreen.namedRoute: (ctx) => EventsScreen(),
            EventDetailsScreen.namedRoute: (ctx) => EventDetailsScreen(),
            AccomodationScreen.namedRoute: (ctx) => AccomodationScreen(),
            AccommodationSummaryScreen.namedRoute: (ctx) =>
                AccommodationSummaryScreen(),
            SignUpScreen.namedRoute: (ctx) => SignUpScreen(),
            QueryDetailScreen.namedRoute: (ctx) => QueryDetailScreen(),
            CanteenSummaryScreen.namedRoute: (ctx) => CanteenSummaryScreen(),
            CanteenPurchaseScreen.namedRoute: (ctx) => CanteenPurchaseScreen(),
            CanteenMakePaymentScreen.namedRoute: (ctx) =>
                CanteenMakePaymentScreen(),
            CanteenBuyMealScreen.namedRoute: (ctx) => CanteenBuyMealScreen(),
          },
        ),
      ),
    );
  }
}
