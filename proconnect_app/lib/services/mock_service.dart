import '../models/professional.dart';
import '../models/space.dart';

/// Servicio con datos mock (simulados) de profesionales y espacios.
/// Útil para desarrollo: luego lo cambias por una API real.
class MockService {
  static List<Professional> getProfessionals() {
    return [
      Professional(
        id: '1',
        name: 'Ana Ruiz',
        role: 'Abogada',
        avatarUrl: '', // vacío en mocks
        featured: true, // destacada
        phone: '+34 600 123 456',
        email: 'ana.ruiz@email.com',
        bio: 'Abogada especializada en derecho civil con más de 10 años de experiencia.',
        spaces: getSpacesForProfessional('1'),
      ),
      Professional(
        id: '2',
        name: 'Carlos Pérez',
        role: 'Contador',
        avatarUrl: '',
        featured: true,
        phone: '+34 600 234 567',
        email: 'carlos.perez@email.com',
        bio: 'Contador público con amplia experiencia en gestión fiscal y contable.',
        spaces: getSpacesForProfessional('2'),
      ),
      Professional(
        id: '3',
        name: 'María Gómez',
        role: 'Psicóloga',
        avatarUrl: '',
        featured: false,
        phone: '+34 600 345 678',
        email: 'maria.gomez@email.com',
        bio: 'Psicóloga clínica especializada en terapia cognitivo-conductual.',
        spaces: getSpacesForProfessional('3'),
      ),
      Professional(
        id: '4',
        name: 'Luis Díaz',
        role: 'Coach',
        avatarUrl: '',
        featured: false,
        phone: '+34 600 456 789',
        email: 'luis.diaz@email.com',
        bio: 'Coach ejecutivo y personal con certificación internacional.',
        spaces: getSpacesForProfessional('4'),
      ),
    ];
  }

  /// Obtiene los espacios disponibles para un profesional específico
  static List<Space> getSpacesForProfessional(String professionalId) {
    switch (professionalId) {
      case '1': // Ana Ruiz - Abogada
        return [
          Space(
            id: 'space_1_1',
            professionalId: '1',
            name: 'Consultorio Principal',
            description: 'Consultorio privado con escritorio y sala de espera',
            price: 50.0,
            isAvailable: true,
          ),
          Space(
            id: 'space_1_2',
            professionalId: '1',
            name: 'Sala de Reuniones',
            description: 'Sala para reuniones grupales y mediaciones',
            price: 30.0,
            isAvailable: true,
          ),
        ];
      case '2': // Carlos Pérez - Contador
        return [
          Space(
            id: 'space_2_1',
            professionalId: '2',
            name: 'Oficina Contable',
            description: 'Oficina equipada con computadoras y archivos',
            price: 40.0,
            isAvailable: true,
          ),
        ];
      case '3': // María Gómez - Psicóloga
        return [
          Space(
            id: 'space_3_1',
            professionalId: '3',
            name: 'Sala de Terapia',
            description: 'Sala tranquila y acogedora para sesiones individuales',
            price: 45.0,
            isAvailable: true,
          ),
          Space(
            id: 'space_3_2',
            professionalId: '3',
            name: 'Sala de Grupo',
            description: 'Sala amplia para terapias grupales',
            price: 35.0,
            isAvailable: true,
          ),
        ];
      case '4': // Luis Díaz - Coach
        return [
          Space(
            id: 'space_4_1',
            professionalId: '4',
            name: 'Sala de Coaching',
            description: 'Espacio dinámico para sesiones de coaching',
            price: 55.0,
            isAvailable: true,
          ),
        ];
      default:
        return [];
    }
  }

  /// Obtiene los horarios disponibles para reservas
  static List<String> getAvailableTimeSlots() {
    return [
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
    ];
  }

  /// Obtiene las próximas fechas disponibles (próximos 7 días)
  static List<DateTime> getAvailableDates() {
    final now = DateTime.now();
    final dates = <DateTime>[];
    
    for (int i = 1; i <= 7; i++) {
      dates.add(DateTime(now.year, now.month, now.day + i));
    }
    
    return dates;
  }

}
