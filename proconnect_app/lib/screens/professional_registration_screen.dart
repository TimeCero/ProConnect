import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/profession_service.dart';
import '../models/profession_category.dart';
import '../models/profession.dart';
import '../models/specialization.dart';
import '../models/professional_registration.dart';
import '../theme/colors.dart';

class ProfessionalRegistrationScreen extends StatefulWidget {
  static const String routeName = '/professional-registration';

  @override
  State<ProfessionalRegistrationScreen> createState() =>
      _ProfessionalRegistrationScreenState();
}

class _ProfessionalRegistrationScreenState
    extends State<ProfessionalRegistrationScreen> {
  // Controllers
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _presentationController = TextEditingController();

  // Estado de selecciones
  ProfessionCategory? _selectedCategory;
  Profession? _selectedProfession;
  List<Specialization> _selectedSpecializations = [];

  // Datos cargados
  List<ProfessionCategory>? _categories;
  List<Profession>? _professions;
  List<Specialization>? _specializations;

  // Estados de carga
  bool _categoriesLoading = false;
  bool _professionsLoading = false;
  bool _specializationsLoading = false;

  late ProfessionService _professionService;

  @override
  void initState() {
    super.initState();
    _professionService = Provider.of<ProfessionService>(context, listen: false);
    _loadCategories();
  }

  /// Carga las categorías de profesiones
  Future<void> _loadCategories() async {
    setState(() {
      _categoriesLoading = true;
    });

    try {
      final categories = await _professionService.getAllCategories();
      setState(() {
        _categories = categories;
        _categoriesLoading = false;
      });
    } catch (e) {
      setState(() {
        _categoriesLoading = false;
      });
      _showErrorSnackbar('Error al cargar categorías: $e');
    }
  }

  /// Carga las profesiones de la categoría seleccionada
  Future<void> _onCategoryChanged(ProfessionCategory? category) async {
    setState(() {
      _selectedCategory = category;
      _selectedProfession = null;
      _selectedSpecializations = [];
      _professions = null;
      _specializations = null;
      _professionsLoading = true;
    });

    if (category != null) {
      try {
        final professions =
            await _professionService.getProfessionsByCategory(category.categoryId);
        setState(() {
          _professions = professions;
          _professionsLoading = false;
        });
      } catch (e) {
        setState(() {
          _professionsLoading = false;
        });
        _showErrorSnackbar('Error al cargar profesiones: $e');
      }
    }
  }

  /// Carga las especializaciones de la profesión seleccionada
  Future<void> _onProfessionChanged(Profession? profession) async {
    setState(() {
      _selectedProfession = profession;
      _selectedSpecializations = [];
      _specializations = null;
      _specializationsLoading = true;
    });

    if (profession != null) {
      try {
        final specializations =
            await _professionService.getSpecializationsByProfession(profession.professionId);
        setState(() {
          _specializations = specializations;
          _specializationsLoading = false;
        });
      } catch (e) {
        setState(() {
          _specializationsLoading = false;
        });
        _showErrorSnackbar('Error al cargar especializaciones: $e');
      }
    }
  }

  /// Alterna la selección de una especialización
  void _toggleSpecialization(Specialization specialization) {
    setState(() {
      if (_selectedSpecializations.contains(specialization)) {
        _selectedSpecializations.remove(specialization);
      } else {
        _selectedSpecializations.add(specialization);
      }
    });
  }

  /// Valida el formulario
  bool _validateForm() {
    if (_selectedCategory == null) {
      _showErrorSnackbar('Por favor selecciona una categoría de profesión');
      return false;
    }
    if (_selectedProfession == null) {
      _showErrorSnackbar('Por favor selecciona una profesión');
      return false;
    }
    if (_selectedSpecializations.isEmpty) {
      _showErrorSnackbar('Por favor selecciona al menos una especialización');
      return false;
    }
    if (_experienceController.text.trim().isEmpty) {
      _showErrorSnackbar('Por favor describe tu experiencia');
      return false;
    }
    if (_presentationController.text.trim().isEmpty) {
      _showErrorSnackbar('Por favor escribe una presentación');
      return false;
    }
    return true;
  }

  /// Envía el formulario
  Future<void> _submitForm() async {
    if (!_validateForm()) return;

    final registration = ProfessionalRegistration(
      experience: _experienceController.text.trim(),
      presentation: _presentationController.text.trim(),
      professionCategoryId: _selectedCategory!.categoryId,
      professionId: _selectedProfession!.professionId,
      specializationIds: _selectedSpecializations.map((s) => s.specializationId).toList(),
    );

    print('Datos a enviar al backend:');
    print(registration.toJson());

    _showSuccessSnackbar('Datos de profesional registrados correctamente');

    // TODO: Aquí iría la llamada al backend para guardar los datos
    // await Future.delayed(Duration(seconds: 2));
    // Navigator.pop(context);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _experienceController.dispose();
    _presentationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Profesional'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _categoriesLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado informativo
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                    ),
                    child: Text(
                      'Completa este formulario para registrarte como profesional en ProConnect',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Selector de Categoría
                  _buildSectionTitle('1. Categoría de Profesión'),
                  _buildCategoryDropdown(),
                  SizedBox(height: 24),

                  // Selector de Profesión (solo si hay categoría seleccionada)
                  if (_selectedCategory != null) ...[
                    _buildSectionTitle('2. Profesión'),
                    _buildProfessionDropdown(),
                    SizedBox(height: 24),
                  ],

                  // Selector de Especializaciones (solo si hay profesión seleccionada)
                  if (_selectedProfession != null) ...[
                    _buildSectionTitle('3. Especializaciones'),
                    _buildSpecializationsCheckboxes(),
                    SizedBox(height: 24),
                  ],

                  // Campos de texto
                  _buildSectionTitle('4. Información Profesional'),
                  _buildExperienceField(),
                  SizedBox(height: 16),
                  _buildPresentationField(),
                  SizedBox(height: 32),

                  // Botones
                  _buildSubmitButton(),
                  SizedBox(height: 12),
                  _buildCancelButton(),
                  SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButton<ProfessionCategory>(
        isExpanded: true,
        value: _selectedCategory,
        hint: Text('Selecciona una categoría'),
        underline: SizedBox(),
        items: _categories?.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.categoryName),
              );
            }).toList() ??
            [],
        onChanged: _onCategoryChanged,
      ),
    );
  }

  Widget _buildProfessionDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: _professionsLoading
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : DropdownButton<Profession>(
              isExpanded: true,
              value: _selectedProfession,
              hint: Text('Selecciona una profesión'),
              underline: SizedBox(),
              items: _professions?.map((profession) {
                    return DropdownMenuItem(
                      value: profession,
                      child: Text(profession.professionName),
                    );
                  }).toList() ??
                  [],
              onChanged: _onProfessionChanged,
            ),
    );
  }

  Widget _buildSpecializationsCheckboxes() {
    return _specializationsLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (_specializations?.isEmpty ?? true)
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('No hay especializaciones disponibles'),
                )
              else
                ..._specializations!.map((specialization) {
                  final isSelected = _selectedSpecializations.contains(specialization);
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? AppColors.accent : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.white,
                    ),
                    child: CheckboxListTile(
                      title: Text(specialization.specializationName),
                      subtitle: Text(specialization.description),
                      value: isSelected,
                      onChanged: (_) => _toggleSpecialization(specialization),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }).toList(),
            ],
          );
  }

  Widget _buildExperienceField() {
    return TextField(
      controller: _experienceController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Describe tu experiencia profesional (años, proyectos relevantes, logros)',
        labelText: 'Experiencia',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(Icons.work_outline),
      ),
    );
  }

  Widget _buildPresentationField() {
    return TextField(
      controller: _presentationController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Breve presentación personal (máximo 255 caracteres)',
        labelText: 'Presentación',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(Icons.person_outline),
        counterText: '${_presentationController.text.length}/255',
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.accent,
        ),
        child: Text(
          'Completar Registro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: AppColors.primary),
        ),
        child: Text(
          'Cancelar',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

