import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../models/professional.dart';
import '../models/space.dart';
import '../services/reservation_service.dart';
import '../services/mock_service.dart';

class MyReservationsScreen extends StatefulWidget {
  static const routeName = '/my-reservations';
  
  const MyReservationsScreen({Key? key}) : super(key: key);

  @override
  _MyReservationsScreenState createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Consultas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: Icon(Icons.schedule),
              text: 'Pendientes',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Historial',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingReservations(),
          _buildHistoryReservations(),
        ],
      ),
    );
  }

  Widget _buildPendingReservations() {
    return Consumer<ReservationService>(
      builder: (context, reservationService, child) {
        final reservations = reservationService.getUserReservations();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        final pendingReservations = reservations
            .where((r) {
              final reservationDate = DateTime(r.date.year, r.date.month, r.date.day);
              return r.status != 'cancelled' && reservationDate.isAfter(today);
            })
            .toList();

        if (pendingReservations.isEmpty) {
          return _buildEmptyState(
            icon: Icons.schedule,
            title: 'No tienes citas pendientes',
            subtitle: 'Reserva un espacio con un profesional',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: pendingReservations.length,
          itemBuilder: (context, index) {
            return _buildReservationCard(pendingReservations[index], isPending: true);
          },
        );
      },
    );
  }

  Widget _buildHistoryReservations() {
    return Consumer<ReservationService>(
      builder: (context, reservationService, child) {
        final reservations = reservationService.getUserReservations();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        final historyReservations = reservations
            .where((r) {
              final reservationDate = DateTime(r.date.year, r.date.month, r.date.day);
              return r.status == 'cancelled' || 
                     reservationDate.isBefore(today) || 
                     reservationDate.isAtSameMomentAs(today);
            })
            .toList();

        if (historyReservations.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history,
            title: 'No tienes historial de citas',
            subtitle: 'Tus citas pasadas aparecerán aquí',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: historyReservations.length,
          itemBuilder: (context, index) {
            return _buildReservationCard(historyReservations[index], isPending: false);
          },
        );
      },
    );
  }

  Widget _buildReservationCard(Reservation reservation, {required bool isPending}) {
    // Obtener información del profesional y espacio
    final professional = _getProfessionalById(reservation.professionalId);
    final space = _getSpaceById(reservation.spaceId);

    if (professional == null || space == null) {
      return SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con profesional y estado
            Row(
              children: [
                CircleAvatar(
                  child: Text(professional.name[0]),
                  backgroundColor: Colors.indigo,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        professional.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        professional.role,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(reservation.status),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Información del espacio
            Row(
              children: [
                Icon(Icons.room, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    space.name,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  '\$${space.price.toStringAsFixed(0)}/h',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            // Fecha y hora
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(_formatDate(reservation.date)),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(reservation.timeSlot),
              ],
            ),
            
            // Botones de acción
            if (isPending && reservation.status != 'cancelled') ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(reservation),
                      icon: Icon(Icons.cancel, size: 16),
                      label: Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            // Botón de reseña (solo en historial)
            if (!isPending) ...[
              SizedBox(height: 12),
              _buildReviewSection(reservation),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'Pendiente';
        icon = Icons.schedule;
        break;
      case 'confirmed':
        color = Colors.green;
        text = 'Confirmada';
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'Cancelada';
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        text = 'Desconocido';
        icon = Icons.help;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar Cita'),
        content: Text('¿Estás seguro de que quieres cancelar esta cita?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _cancelReservation(reservation);
            },
            child: Text('Sí, cancelar'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelReservation(Reservation reservation) async {
    final reservationService = Provider.of<ReservationService>(context, listen: false);
    
    final error = await reservationService.cancelReservation(reservation.id);
    
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cita cancelada exitosamente'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Professional? _getProfessionalById(String id) {
    final professionals = MockService.getProfessionals();
    try {
      return professionals.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Space? _getSpaceById(String id) {
    final professionals = MockService.getProfessionals();
    for (final professional in professionals) {
      try {
        return professional.spaces.firstWhere((s) => s.id == id);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildReviewSection(Reservation reservation) {
    final reservationService = Provider.of<ReservationService>(context, listen: false);
    final existingReview = reservationService.getReviewForReservation(reservation.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mostrar reseña si existe
        if (existingReview != null) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      existingReview.starsString,
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      _formatDate(existingReview.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  existingReview.content,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ] else ...[
          // Botón para dejar reseña
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/write-review',
                  arguments: reservation,
                );
              },
              icon: Icon(Icons.star, size: 18),
              label: Text('⭐ Dejar reseña'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

}
