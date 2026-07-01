import 'package:flutter/material.dart';

// --- GOLDENBOOKING SPORTS MOBILE MODULE (LIGHT PREMIUM THEME) ---
// Adaptado al estilo visual limpio del Login (Fondo Gris Claro, Tarjetas Blancas y Detalles Dorados)

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GOLDENBOOKING',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          primary: const Color(0xFFD4AF37),
          surface: const Color(0xFFF9F9F9), // Mismo fondo que tu Login
          brightness: Brightness.light,
        ),
      ),
      home: const SportsMobileScreen(),
    );
  }
}

class SportsMobileScreen extends StatefulWidget {
  const SportsMobileScreen({super.key});

  @override
  State<SportsMobileScreen> createState() => _SportsMobileScreenState();
}

class _SportsMobileScreenState extends State<SportsMobileScreen> {
  String _selectedCategory = "Tennis";
  int _selectedDayIndex = 2; // Miércoles 15
  String? _selectedTime = "11:00 AM";

  final List<Map<String, dynamic>> _categories = [
    {"name": "Fútbol", "icon": Icons.sports_soccer},
    {"name": "Básquet", "icon": Icons.sports_basketball},
    {"name": "Tennis", "icon": Icons.sports_tennis},
    {"name": "Pádel", "icon": Icons.sports_baseball}, 
  ];

  final List<Map<String, String>> _days = [
    {"day": "LUN", "num": "13"},
    {"day": "MAR", "num": "14"},
    {"day": "MIE", "num": "15"},
    {"day": "JUE", "num": "16"},
    {"day": "VIE", "num": "17"},
    {"day": "SAB", "num": "18"},
  ];

  static const Color dorado = Color(0xFFD4AF37);
  static const Color fondoGris = Color(0xFFF9F9F9); // Heredado de tu Login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoGris,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.grey[800]),
          onPressed: () {},
        ),
        title: const Text(
          'GOLDENBOOKING',
          style: TextStyle(
            color: Color(0xFF8B732A), // doradoOscuro de tu Login para legibilidad
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.grey[800]),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: dorado.withValues(alpha: 0.2),
              child: Icon(Icons.person, color: Colors.grey[700], size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            _buildHeroBanner(),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categorías", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  const Text("VER TODO", style: TextStyle(color: dorado, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // Categories list
            SizedBox(
              height: 95,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return _buildCategoryItem(cat['name'], cat['icon']);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Seleccionar Fecha", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  Text("Mayo 2024", style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            // Date Selector
            SizedBox(
              height: 75,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  return _buildDateItem(index);
                },
              ),
            ),

            // Time Slots Section
            _buildTimeSlotsSection(),

            // Reservation Summary Card
            _buildSummaryCard(),

            const SizedBox(height: 110), // Espacio para el botón flotante inferior
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: dorado,
              foregroundColor: Colors.white,
              elevation: 3,
              shadowColor: dorado.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Mismo radio de botón que tu Login
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("RESERVAR AHORA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.8)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildHeroBanner() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    height: 180,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          
          //  CAMBIA EL CONTAINER GRIS POR ESTO:
          Image.asset(
            'assets/images/aaaa.jpg', // Asegúrate de poner la ruta y extensión correcta
            fit: BoxFit.cover,
          ),

          // Degradado oscuro para mantener la legibilidad de las letras blancas
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,  
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),

          // ... El resto de tu código de texto se queda exactamente igual
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: dorado,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "EXPERIENCIA PREMIUM",
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "CLUB VALLE DORADO",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Text(
                    "Descubre reservas de espacios deportivos, hotelería y más.",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    bool isSelected = _selectedCategory == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = name),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? dorado : Colors.white,
                borderRadius: BorderRadius.circular(12), // Redondeado consistente con el login
                border: Border.all(color: isSelected ? dorado : Colors.black.withValues(alpha: 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? dorado.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(icon, color: isSelected ? Colors.white : dorado),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? dorado : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(int index) {
    bool isSelected = _selectedDayIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDayIndex = index),
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? dorado : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? dorado : Colors.black.withValues(alpha: 0.05)),
          boxShadow: isSelected ? [BoxShadow(color: dorado.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_days[index]['day']!, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.grey[500], fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_days[index]['num']!, style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.grey[800], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeGroup("MAÑANA", Icons.light_mode_outlined, ["08:00 AM", "09:30 AM", "11:00 AM"], [true, false, false]),
          const SizedBox(height: 20),
          _buildTimeGroup("TARDE", Icons.wb_sunny_outlined, ["12:30 PM", "02:00 PM", "03:30 PM"], [false, false, true]),
        ],
      ),
    );
  }

  Widget _buildTimeGroup(String title, IconData icon, List<String> times, List<bool> booked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: Colors.grey[500]),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: times.asMap().entries.map((entry) {
            int idx = entry.key;
            String time = entry.value;
            bool isBooked = booked[idx];
            bool isSelected = _selectedTime == time;

            return Expanded(
              child: GestureDetector(
                onTap: isBooked ? null : () => setState(() => _selectedTime = time),
                child: Container(
                  height: 42,
                  margin: EdgeInsets.only(right: idx == 2 ? 0 : 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? dorado.withValues(alpha: 0.1) : (isBooked ? Colors.grey[100] : Colors.white),
                    border: Border.all(
                      color: isSelected ? dorado : Colors.black.withValues(alpha: 0.05),
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? dorado : (isBooked ? Colors.grey[400] : Colors.grey[700]),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                      decoration: isBooked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: dorado.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.sports_tennis, color: dorado, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Estadio Central #01", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey[800])),
                const SizedBox(height: 2),
                Text("11:00 AM - 01:00 PM (120 min)", style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("\$210.00", style: TextStyle(color: dorado, fontWeight: FontWeight.bold, fontSize: 18)),
              Text("IVA INCL.", style: TextStyle(color: Colors.grey[400], fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, "Inicio", false),
          _buildNavItem(Icons.calendar_month, "Reservas", true),
          _buildNavItem(Icons.search, "Explorar", false),
          _buildNavItem(Icons.person_outline, "Perfil", false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? dorado : Colors.grey[400], size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? dorado : Colors.grey[500],
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 4),
          Container(width: 4, height: 4, decoration: const BoxDecoration(color: dorado, shape: BoxShape.circle)),
        ]
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 6))],
    border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
  );
}