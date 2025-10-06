// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/mock_service.dart';
import '../widgets/professional_card.dart';
import '../models/professional.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Professional> all = [];
  List<Professional> filtered = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    all = MockService.getProfessionals();
    filtered = List.from(all);
  }

  void applyFilter(String q) {
    setState(() {
      query = q;
      if (q.trim().isEmpty) {
        filtered = List.from(all);
      } else {
        final lower = q.toLowerCase();
        filtered =
            all
                .where(
                  (p) =>
                      p.name.toLowerCase().contains(lower) ||
                      p.role.toLowerCase().contains(lower),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final featured = all.where((p) => p.featured).toList();

    return Stack(
      children: [
        // Fondo: imagen atenuada con colorBlendMode (opción fácil y eficiente)
        Positioned.fill(
          child: Image.asset(
            'assets/images/mi_foto.jpg', // <- tu imagen
            fit: BoxFit.cover,
            // color + blend para atenuar; ajusta opacity entre 0.25 y 0.6
            color: Colors.black.withOpacity(0.45),
            colorBlendMode: BlendMode.darken,
          ),
        ),

        // Contenido encima
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent, // importante para ver el fondo
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Inicio', style: TextStyle(color: Colors.white)),
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await auth.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // Buscador: fondo sutil (blanco semitransparente) para legibilidad
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.12,
                      ), // ligero, prueba 0.12..0.9
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ), // texto blanco para contraste
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre o rol',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                      onChanged: applyFilter,
                    ),
                  ),

                  SizedBox(height: 14),

                  // Sección "Destacados" (horizontal)
                  if (featured.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Destacados',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: featured.length,
                        itemBuilder: (context, i) {
                          final p = featured[i];
                          return Container(
                            width: 220,
                            margin: EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    '/professional',
                                    arguments: p,
                                  ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.12),
                                      Colors.white.withOpacity(0.06),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      p.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      p.role,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pushNamed(
                                            context,
                                            '/professional',
                                            arguments: p,
                                          ),
                                      child: Text('Ver'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors
                                                .white, // botón claro para contraste
                                        foregroundColor: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                  ],

                  // Lista filtrada (tarjetas)
                  Expanded(
                    child:
                        filtered.isEmpty
                            ? Center(
                              child: Text(
                                'No hay resultados para "$query"',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                            : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder:
                                  (context, i) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: ProfessionalCard(
                                      p: filtered[i],
                                    ), // tu widget existente
                                  ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
