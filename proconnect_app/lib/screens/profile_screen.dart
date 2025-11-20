import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/profile_service.dart';
import '../theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileService _profileService;

  @override
  void initState() {
    super.initState();
    _profileService = Provider.of<ProfileService>(context, listen: false);
    _profileService.loadUserProfile(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<ProfileService>(
        builder: (context, profileService, child) {
          if (profileService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final user = profileService.userProfile;
          final professional = profileService.professionalProfile;

          if (user == null) {
            return Center(
              child: Text('No se pudo cargar el perfil'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Encabezado con foto y nombre
                _buildProfileHeader(user),

                SizedBox(height: 24),

                // Información de contacto
                _buildContactInfo(user),

                SizedBox(height: 24),

                // Si es profesional, mostrar información profesional
                if (profileService.isProfessional && professional != null) ...[
                  _buildProfessionalSection(professional),
                  SizedBox(height: 24),
                ],

                // Botón de editar perfil
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Editar perfil - Próximamente'),
                            backgroundColor: AppColors.accent,
                          ),
                        );
                      },
                      child: Text('Editar Perfil'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.accent, width: 3),
            ),
            child: user.photoUrl != null
                ? Image.network(user.photoUrl!, fit: BoxFit.cover)
                : Center(
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.accent,
                    ),
                  ),
          ),
          SizedBox(height: 16),
          Text(
            user.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(dynamic user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información de Contacto',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              _buildInfoRow(Icons.email, 'Email', user.email),
              SizedBox(height: 12),
              if (user.phoneNumber != null)
                _buildInfoRow(Icons.phone, 'Teléfono', user.phoneNumber),
              SizedBox(height: 12),
              _buildInfoRow(
                Icons.calendar_today,
                'Miembro desde',
                _formatDate(user.registrationDate),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalSection(dynamic professional) {
    if (professional == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Tarjeta de calificación
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calificación',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            professional.averageRating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: 8),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < professional.averageRating.toInt()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppColors.accent,
                                size: 20,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Reseñas',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${professional.totalReviews}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Tarjeta de presentación
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Presentación',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    professional.presentation ?? 'Sin presentación',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Tarjeta de experiencia
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experiencia',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    professional.experience ?? 'Sin experiencia registrada',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Especializaciones
          if (professional.specializations.isNotEmpty)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Especialidades',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: professional.specializations
                          .map<Widget>((spec) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.1),
                                  border: Border.all(color: AppColors.accent),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  spec.toString(),
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

