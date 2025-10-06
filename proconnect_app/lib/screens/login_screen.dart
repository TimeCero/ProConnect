import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

/// Pantalla de login con validación básica.
/// Usa AuthService (Provider) para autenticar localmente.
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Iniciar sesión')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo email
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa correo';
                  if (!v.contains('@')) return 'Correo inválido';
                  return null;
                },
                onSaved: (v) => email = v!.trim(),
              ),
              SizedBox(height: 12),
              // Campo contraseña
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Ingresa contraseña';
                  if (v.trim().length < 4) return 'Mínimo 4 caracteres';
                  return null;
                },
                onSaved: (v) => password = v!.trim(),
              ),
              SizedBox(height: 20),
              // Botón de entrar
              ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : () async {
                          // Validamos y guardamos los campos
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState!.save();

                          setState(() => loading = true);

                          // Llamada al servicio de auth
                          final err = await auth.login(email, password);

                          setState(() => loading = false);

                          if (err != null) {
                            // Mostrar error (aunque puedes mapear mensajes según necesidad)
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(err)));
                          } else {
                            // Al loguear con éxito navegamos a home y removemos historial
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                child:
                    loading
                        ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text('Entrar'),
              ),

              // Link a registro
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
