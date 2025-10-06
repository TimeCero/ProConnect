import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de autenticación local muy simple.
/// - Guarda usuarios (email -> password) en SharedPreferences (JSON).
/// - Guarda el usuario "actual" (currentUser) para mantener sesión.
/// - Extiende ChangeNotifier para integrarse con Provider y notificar la UI.
class AuthService extends ChangeNotifier {
  bool _loggedIn = false; // Estado local de sesión
  String? userEmail; // email del usuario logueado (si hay)
  Map<String, String> _users = {}; // mapa local: email -> password

  bool get isLoggedIn => _loggedIn;

  AuthService() {
    // Al crear la instancia intentamos cargar datos desde SharedPreferences.
    // Notar: es async, por eso se usa un método separado.
    _loadFromPrefs();
  }

  // Carga usuarios y usuario actual desde SharedPreferences.
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // users se guarda como JSON string; si no existe devolvemos '{}'
    final usersJson = prefs.getString('users') ?? '{}';
    // currentUser almacena el email del usuario logueado (si hay)
    final current = prefs.getString('currentUser');

    // Convertimos JSON a Map<String, String>
    try {
      _users = Map<String, String>.from(json.decode(usersJson));
    } catch (e) {
      // Si falla el parseo, inicializamos vacío
      _users = {};
    }

    if (current != null) {
      _loggedIn = true;
      userEmail = current;
    }

    // Notificar para que la UI se actualice si ya había listeners.
    notifyListeners();
  }

  // Registra un usuario localmente.
  // Retorna null si OK, o un mensaje de error si falla.
  Future<String?> register(String email, String password) async {
    if (_users.containsKey(email)) return 'Usuario ya existe';
    _users[email] = password;
    await _saveUsers();
    return null;
  }

  // Login básico: comprueba email y password.
  // Retorna null si OK o mensaje de error.
  Future<String?> login(String email, String password) async {
    final stored = _users[email];
    if (stored == null) return 'Usuario no registrado';
    if (stored != password) return 'Contraseña incorrecta';

    // Guardamos el usuario actual en SharedPreferences para persistir sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', email);

    _loggedIn = true;
    userEmail = email;
    notifyListeners();
    return null;
  }

  // Cierra sesión: remueve currentUser y actualiza estado.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    _loggedIn = false;
    userEmail = null;
    notifyListeners();
  }

  // Guarda el mapa de usuarios en SharedPreferences como JSON.
  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', json.encode(_users));
  }
}
