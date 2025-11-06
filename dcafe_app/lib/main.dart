import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/menu_provider.dart';
import 'services/poster_api_service.dart';
import 'services/payment_service.dart';
import 'screens/home_screen.dart';
import 'utils/config.dart';

void main() {
  runApp(const DCafeApp());
}

class DCafeApp extends StatelessWidget {
  const DCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final posterApiService = PosterApiService();
    final paymentService = PaymentService();

    // TODO: Set your Poster API access token
    // Get it from: https://joinposter.com/manage/integration
    // posterApiService.setAccessToken('YOUR_ACCESS_TOKEN_HERE');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MenuProvider(posterApiService),
        ),
        Provider.value(value: posterApiService),
        Provider.value(value: paymentService),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
