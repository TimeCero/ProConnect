import 'package:flutter/material.dart';
import '../models/professional.dart';

/// Widget que representa una tarjeta/listTile del profesional.
/// Lo dejamos simple: avatar circular, nombre, rol y un icono si está destacado.
class ProfessionalCard extends StatelessWidget {
  final Professional p;

  const ProfessionalCard({Key? key, required this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        // Si tienes avatarUrl real, reemplaza CircleAvatar por Image.network
        leading: CircleAvatar(
          child: Text(
            p.name.isNotEmpty ? p.name[0] : '?',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
        ),
        title: Text(p.name),
        subtitle: Text(p.role),
        trailing: p.featured ? Icon(Icons.star, color: Colors.amber) : null,
        onTap: () {
          // Acción al tocar la tarjeta: por ahora mostramos un SnackBar.
          // En futuro: navegar a pantalla de perfil profesional.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Abrir perfil de ${p.name} (pendiente)')),
          );
        },
      ),
    );
  }
}
