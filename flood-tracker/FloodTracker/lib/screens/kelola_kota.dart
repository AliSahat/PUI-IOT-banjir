// ignore_for_file: deprecated_member_use, prefer_final_fields, unused_field, unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'components/pencarian.dart';

class CityManagementScreen extends StatefulWidget {
  const CityManagementScreen({super.key});

  @override
  State<CityManagementScreen> createState() => _CityManagementScreenState();
}

class _CityManagementScreenState extends State<CityManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<CityData> cities = [
    CityData(
      name: "Sendangadi",
      iku: "IKU 138",
      temperature: "24°",
      highTemp: "33°",
      lowTemp: "21°",
      color: const Color(0xFF4A5568),
    ),
    CityData(
      name: "Denpasar",
      iku: "IKU 50",
      temperature: "27°",
      highTemp: "31°",
      lowTemp: "25°",
      color: const Color(0xFF3182CE),
    ),
    CityData(
      name: "Yogyakarta",
      iku: "IKU 138",
      temperature: "25°",
      highTemp: "33°",
      lowTemp: "21°",
      color: const Color(0xFF4A5568),
    ),
  ];

  List<CityData> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = cities;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCities = cities;
      } else {
        filteredCities =
            cities
                .where(
                  (city) =>
                      city.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _addCityIfNotExists(String cityName) {
    final exists = cities.any(
      (city) => city.name.toLowerCase() == cityName.toLowerCase(),
    );
    if (!exists) {
      setState(() {
        cities.add(
          CityData(
            name: cityName,
            iku: "IKU 50",
            temperature: "25°",
            highTemp: "32",
            lowTemp: "22",
            color: Colors.blue,
          ),
        );
        filteredCities = List.from(cities);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FAFC), Color(0xFFEDF2F7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              // Search Bar
              _buildSearchBar(),

              // City List
              Expanded(child: _buildCityList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF2D3748),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              "Kelola kota",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A202C),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () async {
            final selectedCity = await Navigator.push<String>(
              context,
              MaterialPageRoute(builder: (context) => const CitySearchScreen()),
            );
            if (selectedCity != null && selectedCity.isNotEmpty) {
              _addCityIfNotExists(selectedCity);
              // Jangan langsung pop, biarkan user lihat daftar kota yang sudah bertambah
              // Navigator.pop(context, selectedCity); // HAPUS BARIS INI
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: _searchController,
              enabled: false, // Tidak bisa diketik
              decoration: InputDecoration(
                hintText: "Masukkan lokasi",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey[400],
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityList() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child:
            filteredCities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      curve: Curves.easeOutCubic,
                      child: _buildCityCard(filteredCities[index], index),
                    );
                  },
                ),
      ),
    );
  }

  Widget _buildCityCard(CityData city, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context, city.name);
          },
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [city.color, city.color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: city.color.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.white.withOpacity(0.9),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              city.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                city.iku,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${city.highTemp} / ${city.lowTemp}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        city.temperature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getWeatherIcon(city.temperature),
                          color: Colors.white.withOpacity(0.9),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Kota tidak ditemukan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Coba kata kunci lain",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String temperature) {
    int temp = int.parse(temperature.replaceAll('°', ''));
    if (temp >= 30) {
      return Icons.wb_sunny_rounded;
    } else if (temp >= 25) {
      return Icons.wb_cloudy_rounded;
    } else {
      return Icons.cloud_rounded;
    }
  }
}

class CityData {
  final String name;
  final String iku;
  final String temperature;
  final String highTemp;
  final String lowTemp;
  final Color color;

  CityData({
    required this.name,
    required this.iku,
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
    required this.color,
  });
}
