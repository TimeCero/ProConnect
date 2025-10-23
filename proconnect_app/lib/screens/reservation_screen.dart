import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/professional.dart';
import '../models/space.dart';
import '../services/reservation_service.dart';
import '../services/mock_service.dart';

class ReservationScreen extends StatefulWidget {
  static const routeName = '/reservation';
  
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  Professional? professional;
  Space? selectedSpace;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtener el profesional pasado como argumento
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Professional) {
      professional = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (professional == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Reserva')),
        body: Center(child: Text('Error: Profesional no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar con ${professional!.name}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del profesional
            _buildProfessionalInfo(),
            SizedBox(height: 24),
            
            // Selección de espacio
            _buildSpaceSelection(),
            SizedBox(height: 24),
            
            // Selección de fecha
            _buildDateSelection(),
            SizedBox(height: 24),
            
            // Selección de horario
            if (selectedDate != null) _buildTimeSelection(),
            
            SizedBox(height: 32),
            
            // Botón de reserva
            _buildReserveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(professional!.name[0]),
              backgroundColor: Colors.indigo,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional!.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    professional!.role,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona un espacio',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...professional!.spaces.map((space) => _buildSpaceCard(space)),
      ],
    );
  }

  Widget _buildSpaceCard(Space space) {
    final isSelected = selectedSpace?.id == space.id;
    
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.indigo[50] : null,
      child: ListTile(
        title: Text(space.name),
        subtitle: Text(space.description),
        trailing: Text(
          '\$${space.price.toStringAsFixed(0)}/h',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        onTap: () {
          setState(() {
            selectedSpace = space;
            selectedDate = null;
            selectedTimeSlot = null;
          });
        },
        leading: isSelected 
          ? Icon(Icons.check_circle, color: Colors.indigo)
          : Icon(Icons.room, color: Colors.grey),
      ),
    );
  }

  Widget _buildDateSelection() {
    final availableDates = MockService.getAvailableDates();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona una fecha',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            itemBuilder: (context, index) {
              final date = availableDates[index];
              final isSelected = selectedDate?.day == date.day;
              
              return Container(
                margin: EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = date;
                      selectedTimeSlot = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.indigo : Colors.grey[300],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDayName(date.weekday),
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    if (selectedSpace == null) return SizedBox.shrink();
    
    final availableSlots = Provider.of<ReservationService>(context, listen: false)
        .getAvailableTimeSlots(selectedSpace!.id, selectedDate!);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona un horario',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableSlots.map((slot) {
            final isSelected = selectedTimeSlot == slot;
            final isAvailable = availableSlots.contains(slot);
            
            return ElevatedButton(
              onPressed: isAvailable ? () {
                setState(() {
                  selectedTimeSlot = slot;
                });
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.indigo : Colors.grey[300],
                foregroundColor: isSelected ? Colors.white : Colors.black,
              ),
              child: Text(slot),
            );
          }).toList(),
        ),
        if (availableSlots.isEmpty) ...[
          SizedBox(height: 8),
          Text(
            'No hay horarios disponibles para esta fecha',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }

  Widget _buildReserveButton() {
    final canReserve = selectedSpace != null && 
                      selectedDate != null && 
                      selectedTimeSlot != null;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canReserve && !isLoading ? _createReservation : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
              'Confirmar Reserva',
              style: TextStyle(fontSize: 16),
            ),
      ),
    );
  }

  Future<void> _createReservation() async {
    if (selectedSpace == null || selectedDate == null || selectedTimeSlot == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final reservationService = Provider.of<ReservationService>(context, listen: false);
    
    final error = await reservationService.createReservation(
      spaceId: selectedSpace!.id,
      professionalId: professional!.id,
      date: selectedDate!,
      timeSlot: selectedTimeSlot!,
    );

    setState(() {
      isLoading = false;
    });

    if (error == null) {
      // Éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Reserva creada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getDayName(int weekday) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[weekday - 1];
  }
}
