import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedTabIndex = 0; 
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopUtilityBar(),
              _buildMainHeader(),
              if (_isMenuOpen) _buildDrawerMenu(),
              _buildHeroSection(),
              _buildFeatureCarousel(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Barra negra superior
  Widget _buildTopUtilityBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.facebook, color: Colors.white, size: 18),
          const Spacer(),
          const Text('🇧🇴', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          const Text('ES', style: TextStyle(color: Colors.white, fontSize: 12)),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'INICIAR SESIÓN',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Encabezado principal con Logo y Menú Hamburguesa
  Widget _buildMainHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.add_box, color: Color(0xFF00A3E0), size: 32),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Caduceo',
                    style: TextStyle(color: Color(0xFF1E293B), fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'MI RECORRIDO EN SALUD',
                    style: TextStyle(color: Colors.grey, fontSize: 8, letterSpacing: 0.5),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(_isMenuOpen ? Icons.close : Icons.menu, color: Colors.grey[700], size: 28),
            onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
          ),
        ],
      ),
    );
  }

  // Menú desplegable cuando se activa la hamburguesa
  Widget _buildDrawerMenu() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(leading: Icon(Icons.home, color: Color(0xFF00A3E0)),),
          const ListTile(leading: Icon(Icons.search, color: Colors.grey),),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('¿ES USTED UN PROFESIONAL?', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  // 3. Sección Principal con la Card de Búsqueda y Fondo Ilustrado
  Widget _buildHeroSection() {
    return Stack(
      children: [
        // Ilustración de fondo simulada con contenedor de color
        Container(
          height: 480,
          width: double.infinity,
          color: const Color(0xFFE8F5E9),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pestañas "Citas" / "Resultados"
                Row(
                  children: [
                    _buildTabButton(title: 'Citas', index: 0),
                    _buildTabButton(title: 'Resultados', index: 1),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _selectedTabIndex == 0 ? _buildCitasForm() : _buildResultadosForm(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({required String title, required int index}) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFFF1F0F5),
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isSelected ? const Color(0xFF4A4A4A) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Formulario para pestaña "Citas"
  Widget _buildCitasForm() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            hintText: 'Nombre, Especialidad',
            suffixIcon: Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '¿Dónde?',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
            Container(
              height: 48,
              width: 48,
              color: const Color(0xFF4DD0E1),
              child: const Icon(Icons.location_on, color: Colors.white),
            )
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE67E22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            ),
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text('Buscar', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Centros de Radiología',
            style: TextStyle(color: Color(0xFF00A3E0), decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  // Formulario para pestaña "Resultados"
  Widget _buildResultadosForm() {
    return Column(
      children: [
        Container(
          color: const Color(0xFFF0FDF4),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Clave Secreta Resultante (RSK)',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: const Color(0xFFF0FDF4),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Fecha de nacimiento',
              suffixIcon: Icon(Icons.cake, color: Colors.grey),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE67E22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            ),
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text('Buscar', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  // 4. Sección de Carrusel / Indicadores
  Widget _buildFeatureCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF4DD0E1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.calendar_today, color: Color(0xFF4DD0E1), size: 32),
          ),
          const SizedBox(height: 12),
          const Text(
            'Haga citas de manera mas eficiente',
            style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(isActive: true),
              _buildDot(isActive: false),
              _buildDot(isActive: false),
              _buildDot(isActive: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF007AFF) : Colors.grey.shade300,
      ),
    );
  }

  // 5. Pie de página
  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SOPORTE', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.grey),
          _buildFooterLink('Acerca de nosotros'),
          _buildFooterLink('Contáctenos'),
          const SizedBox(height: 20),
          const Text('INFORMACIÓN DE CONTACTO', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          const Text('Av. America E-0435\nEdif. Jaque, Planta Baja, Local 3\nCochabamba - Bolivia\nTel: +591 (4)4796096\nEmail: info@caduceo.bo',
              style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 13)),
          const SizedBox(height: 24),
          const Divider(color: Colors.grey),
          const Center(
            child: Text(
              'Operado por caduceo.bo © 2016 - 2026 WDS Technologies SA, Group medspazio.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}