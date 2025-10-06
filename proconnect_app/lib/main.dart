import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(
    // Proveedor global del AuthService para acceder desde cualquier pantalla.
    ChangeNotifierProvider(create: (_) => AuthService(), child: MyApp()),
  );
}

/// Widget que decide qué pantalla mostrar según el estado de auth.
/// Esto evita problemas con initialRoute cuando AuthService carga datos async.
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Escucha cambios en AuthService (reconstruye cuando notifyListeners() se llame)
    final auth = Provider.of<AuthService>(context);

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
      },
    );
  }
}
