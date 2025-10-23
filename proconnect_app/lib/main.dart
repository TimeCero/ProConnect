import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/reservation_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/my_reservations_screen.dart';
import 'screens/write_review_screen.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(
    // Múltiples providers para manejar estado global
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ReservationService()),
      ],
      child: MyApp(),
    ),
  );
}

/// Widget que decide qué pantalla mostrar según el estado de auth.
/// Esto evita problemas con initialRoute cuando AuthService carga datos async.
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Escucha cambios en AuthService (reconstruye cuando notifyListeners() se llame)
    final auth = Provider.of<AuthService>(context);
    final reservationService = Provider.of<ReservationService>(context, listen: false);

    // Inicializar ReservationService con el usuario actual si está logueado
    if (auth.isLoggedIn && auth.userEmail != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (reservationService.currentUserId != auth.userEmail) {
          reservationService.initializeWithUser(auth.userEmail!);
        }
      });
    }

    // Si está logueado mostramos Home, si no Login.
    // (AuthService carga SharedPreferences en su constructor y luego notifica)
    if (auth.isLoggedIn) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProConnect',
      theme: AppTheme.theme, // <-- Usa el tema personalizado
      // Usamos AuthWrapper como home para manejar el estado de sesión
      home: AuthWrapper(),
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        ReservationScreen.routeName: (_) => ReservationScreen(),
        MyReservationsScreen.routeName: (_) => MyReservationsScreen(),
        WriteReviewScreen.routeName: (_) => WriteReviewScreen(),
      },
    );
  }
}
