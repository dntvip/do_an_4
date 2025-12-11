import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'providers/user_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/menu_provider.dart';
import 'themes/app_theme.dart';

// Screens
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/food_detail/food_detail_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/order_history/order_history_screen.dart';
import 'screens/edit_profile/edit_profile_screen.dart';
import 'screens/change_password/change_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Re-enable App Check for debugging
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // Load environment variables (if you are using them for Mapbox)
  // await dotenv.load(fileName: ".env");
  // MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);

  FirebaseDatabase.instance.setLoggingEnabled(true);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProxyProvider<UserProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, userProvider, cartProvider) {
            if (cartProvider == null) return CartProvider();
            final userId = userProvider.user?.uid;
            cartProvider.setUserId(userId);
            return cartProvider;
          },
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Food Delivery App',
            theme: HomeCookedTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(), 
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/food-detail': (context) => const FoodDetailScreen(),
              '/cart': (context) => const CartScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/order-history': (context) => const OrderHistoryScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/change-password': (context) => const ChangePasswordScreen(),
            },
          );
        },
      ),
    );
  }
}
