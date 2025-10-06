import '../models/professional.dart';

/// Servicio con datos mock (simulados) de profesionales.
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
      ),
      Professional(
        id: '2',
        name: 'Carlos Pérez',
        role: 'Contador',
        avatarUrl: '',
        featured: true,
      ),
      Professional(
        id: '3',
        name: 'María Gómez',
        role: 'Psicóloga',
        avatarUrl: '',
        featured: false,
      ),
      Professional(
        id: '4',
        name: 'Luis Díaz',
        role: 'Coach',
        avatarUrl: '',
        featured: false,
      ),
      // Agrega más objetos para probar el scroll/listado
    ];
  }
}
