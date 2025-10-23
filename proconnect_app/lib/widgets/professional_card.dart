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
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  child: Text(
                    p.name.isNotEmpty ? p.name[0] : '?',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.indigo,
                ),
                SizedBox(width: 12),
                // Información del profesional
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (p.featured) ...[
                            SizedBox(width: 8),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                          ],
                        ],
                      ),
                      Text(
                        p.role,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (p.bio.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          p.bio,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            
            // Información de espacios disponibles
            if (p.spaces.isNotEmpty) ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.room, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${p.spaces.length} espacio${p.spaces.length > 1 ? 's' : ''} disponible${p.spaces.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Desde \$${p.spaces.map((s) => s.price).reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}/h',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
            
            // Botones de acción
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navegar a pantalla de detalle del profesional
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ver perfil de ${p.name} (próximamente)')),
                      );
                    },
                    icon: Icon(Icons.person, size: 16),
                    label: Text('Ver Perfil'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: p.spaces.isNotEmpty ? () {
                      Navigator.pushNamed(
                        context,
                        '/reservation',
                        arguments: p,
                      );
                    } : null,
                    icon: Icon(Icons.calendar_today, size: 16),
                    label: Text('Reservar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
