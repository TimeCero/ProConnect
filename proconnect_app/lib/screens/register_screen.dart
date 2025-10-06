import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

/// Pantalla de registro simple.
/// Llama a AuthService.register(...) y muestra mensajes.
class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email
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
              // Password
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
              ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : () async {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState!.save();

                          setState(() => loading = true);

                          final err = await auth.register(email, password);

                          setState(() => loading = false);

                          if (err != null) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(err)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Registrado con éxito. Inicia sesión.',
                                ),
                              ),
                            );
                            Navigator.pop(context); // volver al login
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
                        : Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
