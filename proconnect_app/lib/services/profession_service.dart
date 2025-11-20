import 'package:flutter/material.dart';
import '../models/profession_category.dart';
import '../models/profession.dart';
import '../models/specialization.dart';

/// Servicio que maneja la obtención de datos de profesiones, categorías y especializaciones.
/// Por ahora usa datos mock, pero está preparado para conectarse con un API backend.
class ProfessionService extends ChangeNotifier {
  // Datos mock - reemplazar con llamadas a API real
  final List<ProfessionCategory> _categories = [
    ProfessionCategory(
      categoryId: 1,
      categoryName: 'Consultoría Legal',
      description: 'Servicios de asesoramiento legal y jurídico',
    ),
    ProfessionCategory(
      categoryId: 2,
      categoryName: 'Contabilidad y Finanzas',
      description: 'Servicios de contabilidad, auditoría y asesoramiento financiero',
    ),
    ProfessionCategory(
      categoryId: 3,
      categoryName: 'Diseño y Creativo',
      description: 'Servicios de diseño gráfico, web y creación de contenido',
    ),
    ProfessionCategory(
      categoryId: 4,
      categoryName: 'Tecnología',
      description: 'Servicios de desarrollo de software y consultoría IT',
    ),
    ProfessionCategory(
      categoryId: 5,
      categoryName: 'Marketing y Comunicación',
      description: 'Servicios de marketing digital, publicidad y comunicación',
    ),
  ];

  final List<Profession> _professions = [
    // Categoría 1: Consultoría Legal
    Profession(
      professionId: 1,
      categoryId: 1,
      professionName: 'Abogado(a)',
      description: 'Asesoramiento legal en diferentes áreas del derecho',
    ),
    Profession(
      professionId: 2,
      categoryId: 1,
      professionName: 'Notario(a)',
      description: 'Servicios notariales y autenticación de documentos',
    ),
    // Categoría 2: Contabilidad y Finanzas
    Profession(
      professionId: 3,
      categoryId: 2,
      professionName: 'Contador(a)',
      description: 'Servicios de contabilidad y gestión financiera',
    ),
    Profession(
      professionId: 4,
      categoryId: 2,
      professionName: 'Auditor(a)',
      description: 'Servicios de auditoría interna y externa',
    ),
    Profession(
      professionId: 5,
      categoryId: 2,
      professionName: 'Asesor(a) Financiero',
      description: 'Asesoramiento en inversiones y planificación financiera',
    ),
    // Categoría 3: Diseño y Creativo
    Profession(
      professionId: 6,
      categoryId: 3,
      professionName: 'Diseñador(a) Gráfico',
      description: 'Diseño de materiales gráficos y branding',
    ),
    Profession(
      professionId: 7,
      categoryId: 3,
      professionName: 'Diseñador(a) Web',
      description: 'Diseño de interfaces y experiencia de usuario web',
    ),
    // Categoría 4: Tecnología
    Profession(
      professionId: 8,
      categoryId: 4,
      professionName: 'Desarrollador(a) de Software',
      description: 'Desarrollo de aplicaciones y software personalizado',
    ),
    Profession(
      professionId: 9,
      categoryId: 4,
      professionName: 'Especialista en DevOps',
      description: 'Gestión de infraestructura y deployments',
    ),
    // Categoría 5: Marketing
    Profession(
      professionId: 10,
      categoryId: 5,
      professionName: 'Community Manager',
      description: 'Gestión de redes sociales y comunidades online',
    ),
  ];

  final List<Specialization> _specializations = [
    // Abogado(a) - Especialidades
    Specialization(
      specializationId: 1,
      professionId: 1,
      specializationName: 'Derecho Civil',
      description: 'Especialización en derecho civil y contratos',
    ),
    Specialization(
      specializationId: 2,
      professionId: 1,
      specializationName: 'Derecho Penal',
      description: 'Especialización en derecho penal y criminal',
    ),
    Specialization(
      specializationId: 3,
      professionId: 1,
      specializationName: 'Derecho Laboral',
      description: 'Especialización en derecho laboral y seguridad social',
    ),
    Specialization(
      specializationId: 4,
      professionId: 1,
      specializationName: 'Derecho Corporativo',
      description: 'Especialización en derecho empresarial y corporativo',
    ),
    // Contador(a) - Especialidades
    Specialization(
      specializationId: 5,
      professionId: 3,
      specializationName: 'Contabilidad Financiera',
      description: 'Especialización en contabilidad financiera e informes',
    ),
    Specialization(
      specializationId: 6,
      professionId: 3,
      specializationName: 'Contabilidad Tributaria',
      description: 'Especialización en tributación y cumplimiento fiscal',
    ),
    Specialization(
      specializationId: 7,
      professionId: 3,
      specializationName: 'Contabilidad de Costos',
      description: 'Especialización en análisis de costos y presupuestos',
    ),
    // Diseñador(a) Gráfico - Especialidades
    Specialization(
      specializationId: 8,
      professionId: 6,
      specializationName: 'Branding',
      description: 'Diseño de identidad visual y marcas',
    ),
    Specialization(
      specializationId: 9,
      professionId: 6,
      specializationName: 'Diseño Editorial',
      description: 'Diseño de publicaciones y materiales impresos',
    ),
    Specialization(
      specializationId: 10,
      professionId: 6,
      specializationName: 'Ilustración',
      description: 'Creación de ilustraciones digitales y análogas',
    ),
    // Desarrollador(a) de Software - Especialidades
    Specialization(
      specializationId: 11,
      professionId: 8,
      specializationName: 'Frontend',
      description: 'Desarrollo de interfaces de usuario web',
    ),
    Specialization(
      specializationId: 12,
      professionId: 8,
      specializationName: 'Backend',
      description: 'Desarrollo de servidores y APIs',
    ),
    Specialization(
      specializationId: 13,
      professionId: 8,
      specializationName: 'Full Stack',
      description: 'Desarrollo completo de aplicaciones web',
    ),
    Specialization(
      specializationId: 14,
      professionId: 8,
      specializationName: 'Mobile',
      description: 'Desarrollo de aplicaciones móviles',
    ),
  ];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Obtiene todas las categorías de profesiones
  Future<List<ProfessionCategory>> getAllCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulamos un delay de red
      await Future.delayed(Duration(milliseconds: 500));
      
      // TODO: Aquí irá la llamada real al backend:
      // final response = await http.get(
      //   Uri.parse('${ApiConfig.baseUrl}/profession-categories'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body) as List;
      //   return data.map((json) => ProfessionCategory.fromJson(json)).toList();
      // }

      return _categories;
    } catch (e) {
      print('Error obteniendo categorías: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene las profesiones de una categoría específica
  Future<List<Profession>> getProfessionsByCategory(int categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(milliseconds: 500));

      // TODO: Llamada real al backend:
      // final response = await http.get(
      //   Uri.parse('${ApiConfig.baseUrl}/professions?category_id=$categoryId'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );

      final filtered = _professions.where((p) => p.categoryId == categoryId).toList();
      return filtered;
    } catch (e) {
      print('Error obteniendo profesiones: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene las especializaciones de una profesión específica
  Future<List<Specialization>> getSpecializationsByProfession(int professionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(milliseconds: 500));

      // TODO: Llamada real al backend:
      // final response = await http.get(
      //   Uri.parse('${ApiConfig.baseUrl}/specializations?profession_id=$professionId'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );

      final filtered = _specializations.where((s) => s.professionId == professionId).toList();
      return filtered;
    } catch (e) {
      print('Error obteniendo especializaciones: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca una categoría por ID
  ProfessionCategory? getCategoryById(int categoryId) {
    try {
      return _categories.firstWhere((c) => c.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Busca una profesión por ID
  Profession? getProfessionById(int professionId) {
    try {
      return _professions.firstWhere((p) => p.professionId == professionId);
    } catch (e) {
      return null;
    }
  }

  /// Busca una especialización por ID
  Specialization? getSpecializationById(int specializationId) {
    try {
      return _specializations.firstWhere((s) => s.specializationId == specializationId);
    } catch (e) {
      return null;
    }
  }
}

